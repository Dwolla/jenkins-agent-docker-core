FROM dwolla/jenkins-agent-nucleus AS nucleus
FROM eclipse-temurin:11
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=3.10

COPY --from=nucleus / /

WORKDIR ${JENKINS_HOME}

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
        shellcheck \
        zip \
        && \
    rm -rf /tmp/build && \
    mkdir -p ${JENKINS_HOME} && \
    useradd --home ${JENKINS_HOME} --system jenkins && \
    chown -R jenkins ${JENKINS_HOME} && \
    mkdir -p /usr/share/man/man1/ && \
    touch /usr/share/man/man1/sh.distrib.1.gz

USER jenkins

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent"

ENTRYPOINT ["jenkins-agent"]
