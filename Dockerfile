# The agent process (Jenkins Remoting) always runs on the Java 21 that ships in the inbound-agent
# image, because Jenkins 2.555+ refuses agents on an older JVM. Builds use a separate build JDK,
# chosen with BUILD_JDK, as JAVA_HOME and first on PATH, so build steps see the same Java as
# before. The inbound-agent launch script prefers JENKINS_JAVA_BIN over JAVA_HOME for the agent.
ARG JENKINS_REMOTING_TAG=3395.v6e5377b_0fb_3c-5-jdk21
ARG BUILD_JDK=21

# Build JDKs, pinned by digest; a new JDK release is a reviewed change to the tag and digest.
FROM eclipse-temurin:11.0.33_10-jdk@sha256:8b64035b610d11979ee0fdefca06355b8fcfb7001ec657a5223ca996b82614b4 AS build-jdk-11
FROM eclipse-temurin:17.0.21_9-jdk@sha256:5465815640e10433422217335e15a523a3e57021a1f2ae0fc3849380d237979f AS build-jdk-17
FROM eclipse-temurin:21.0.13_9-jdk@sha256:0a3f329821dcadf54b2a3033a15e2e9f007069a9db43d7f51897e6b80e726b07 AS build-jdk-21
FROM eclipse-temurin:25.0.5_8-jdk@sha256:b8705e936964c228dfce359e63dbf08f6c69cb380ed1d576b1f6b1064f15567d AS build-jdk-25
FROM build-jdk-${BUILD_JDK} AS build-jdk

FROM jenkins/inbound-agent:$JENKINS_REMOTING_TAG
ARG BUILD_JDK
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"
LABEL com.dwolla.jenkins-agent.agent-jvm="21"
LABEL com.dwolla.jenkins-agent.build-jdk="${BUILD_JDK}"
ENV JENKINS_HOME=/home/jenkins

COPY --from=build-jdk /opt/java/openjdk /opt/java/build-jdk
ENV JENKINS_JAVA_BIN=/opt/java/openjdk/bin/java \
    JAVA_HOME=/opt/java/build-jdk \
    PATH=/opt/java/build-jdk/bin:$PATH

COPY build/install-esh.sh /tmp/build/install-esh.sh
COPY build/sdkman-init-wrapper.sh /usr/local/bin/sdkman-init-wrapper.sh

WORKDIR ${JENKINS_HOME}

USER root

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
