ARG JENKINS_REMOTING_TAG

FROM jenkins/inbound-agent:$JENKINS_REMOTING_TAG
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"
ENV JENKINS_HOME=/home/jenkins

COPY build/install-esh.sh /tmp/build/install-esh.sh
COPY build/sdkman-init-wrapper.sh /usr/local/bin/sdkman-init-wrapper.sh

WORKDIR ${JENKINS_HOME}

USER root

RUN set -ex && \
    apt-get update && \
    (apt-get install -y \
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
    || (sleep 5 && apt-get update && apt-get install -y \
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
        zip)) && \
    pip3 install --upgrade \
        awscli \
        virtualenv \
        && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    /tmp/build/install-esh.sh v0.3.2 && \
    chmod +x /usr/local/bin/sdkman-init-wrapper.sh && \
    rm -rf /tmp/build && \
    mkdir -p /usr/share/man/man1/ && \
    touch /usr/share/man/man1/sh.distrib.1.gz

# change /bin/sh to use bash, because lots of our scripts use bash features
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

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
