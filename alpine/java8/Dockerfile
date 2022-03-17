FROM dwolla/jenkins-agent-nucleus AS nucleus
FROM koalaman/shellcheck-alpine:v0.7.2 AS shellcheck
FROM adoptopenjdk/openjdk8:jdk8u302-b08-alpine-slim
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=3.10

COPY --from=nucleus / /

COPY --from=shellcheck /bin/shellcheck /bin/

RUN apk -U upgrade \
        && \
    apk add --update-cache --no-cache \
        bash \
        ca-certificates \
        curl \
        esh \
        expect \
        git \
        gnupg \
        jq \
        make \
        openssh-client \
        python3 \
        py3-pip \
    && \
    pip3 install --upgrade --no-cache-dir pip && \
    pip3 install --upgrade --no-cache-dir \
        awscli \
        virtualenv \
        && \
    adduser -S -h ${JENKINS_HOME} jenkins && \
    chown -R jenkins ${JENKINS_HOME} && \
    chmod 755 /usr/local/bin/jenkins-agent

WORKDIR ${JENKINS_HOME}
USER jenkins

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent"

ENTRYPOINT ["jenkins-agent"]