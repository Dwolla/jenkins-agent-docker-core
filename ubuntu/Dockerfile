FROM dwolla/jenkins-agent-nucleus AS nucleus
FROM eclipse-temurin:8u302-b08-jdk
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=3.10

COPY --from=nucleus / /

WORKDIR ${JENKINS_HOME}

# apt-key loop inspired by https://github.com/nodejs/docker-node/issues/340#issuecomment-321669029
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install git -y && \
    set -ex && \
    apt-get install -y \
        apt-transport-https \
        awscli \
        bash \
        bc \
        ca-certificates \
        curl \
        expect \
        gpg \
        jq \
        make \
        python3 \
        python3-pip \
        python3-venv \
        shellcheck \
        unixodbc-dev \
        zip \
        && \
    rm -rf /tmp/build && \
    mkdir -p ${JENKINS_HOME} && \
    useradd --home ${JENKINS_HOME} --system jenkins && \
    chown -R jenkins ${JENKINS_HOME} && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    mkdir -p /usr/share/man/man1/ && \
    touch /usr/share/man/man1/sh.distrib.1.gz

USER jenkins

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent"

ENTRYPOINT ["jenkins-agent"]
