# One core image for every agent. The agent process (Jenkins Remoting) runs on the Java 21 that ships
# in the inbound-agent image, which Jenkins 2.555+ requires. JENKINS_JAVA_BIN pins the agent to that
# Java, so an image built on this one can point JAVA_HOME at a different build JDK (as the sbt images
# do) without changing the JVM the agent runs on. The inbound-agent launch script prefers
# JENKINS_JAVA_BIN over JAVA_HOME.
ARG JENKINS_REMOTING_TAG=3396.ve02b_5cde31b_2-4-jdk21

FROM jenkins/inbound-agent:$JENKINS_REMOTING_TAG

# Set by BuildKit. When the base tag has no image for the target platform, BuildKit
# silently falls back to a compatible one (e.g. arm/v7 for arm64), so fail instead.
ARG TARGETARCH

LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"
ENV JENKINS_HOME=/home/jenkins \
    JENKINS_JAVA_BIN=/opt/java/openjdk/bin/java

COPY build/install-esh.sh /tmp/build/install-esh.sh
COPY build/sdkman-init-wrapper.sh /usr/local/bin/sdkman-init-wrapper.sh

WORKDIR ${JENKINS_HOME}

USER root

RUN BASE_ARCH="$(dpkg --print-architecture)" ; \
    if [ -n "$TARGETARCH" ] && [ "$BASE_ARCH" != "$TARGETARCH" ] ; then \
        echo "base image architecture $BASE_ARCH does not match target $TARGETARCH" ; \
        exit 97 ; \
    fi

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
        asciidoctor \
        apt-transport-https \
        bash \
        bc \
        ca-certificates \
        curl \
        expect \
        git \
        gpg \
        jq \
        make \
        python3 \
        python3-pip \
        python3-venv \
        shellcheck \
        zip \
        && \
    pip3 install --break-system-packages --upgrade --ignore-installed \
        awscli \
        virtualenv && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    /tmp/build/install-esh.sh v0.3.2 && \
    chmod +x /usr/local/bin/sdkman-init-wrapper.sh && \
    rm -rf /tmp/build && \
    mkdir -p /usr/share/man/man1/ && \
    touch /usr/share/man/man1/sh.distrib.1.gz

# change /bin/sh to use bash, because lots of our scripts use bash features
RUN ln -sf /bin/bash /bin/sh

USER jenkins

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent" && \
    git config --global init.defaultBranch main && \
    git config --global 'credential.https://github.com.username' 'x-access-token' && \
    git config --global 'credential.https://github.com.helper' '!f() { if [ "$1" = get ]; then case "${GH_TOKEN-}" in (*[![:space:]]*) echo "password=${GH_TOKEN}";; (*) echo "error: GH_TOKEN is missing" >&2; exit 1;; esac; fi; }; f'

# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash && \
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk version"

ENTRYPOINT ["jenkins-agent"]
