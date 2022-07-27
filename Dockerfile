ARG JENKINS_REMOTING_TAG

FROM jenkins/inbound-agent:$JENKINS_REMOTING_TAG
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"
ENV JENKINS_HOME=/home/jenkins

COPY build/install-esh.sh /tmp/build/install-esh.sh

WORKDIR ${JENKINS_HOME}

USER root

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
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
    pip3 install --upgrade \
        awscli \
        virtualenv \
        && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    /tmp/build/install-esh.sh v0.3.1 && \
    rm -rf /tmp/build && \
    mkdir -p /usr/share/man/man1/ && \
    touch /usr/share/man/man1/sh.distrib.1.gz

# change /bin/sh to use bash, because lots of our scripts use bash features
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER jenkins

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent"

ENTRYPOINT ["jenkins-agent"]
