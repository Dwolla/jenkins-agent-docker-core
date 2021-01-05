FROM dwolla/jenkins-agent-nucleus AS nucleus
FROM openjdk:8-jre-alpine
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=3.10

COPY --from=nucleus / /

RUN apk add --update-cache --no-cache \
        bash \
        ca-certificates \
        curl \
        git \
        gnupg \
        jq \
        make \
        openssh-client \
        python3 \
    && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade \
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
