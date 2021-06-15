FROM dwolla/jenkins-agent-nucleus AS nucleus
FROM openjdk:8-jre-slim-buster
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"

ENV JENKINS_HOME=/home/jenkins \
    JENKINS_AGENT=/usr/share/jenkins \
    AGENT_VERSION=3.10

COPY --from=nucleus / /

COPY build/install-esh.sh /tmp/build/install-esh.sh

WORKDIR ${JENKINS_HOME}

# apt-key loop inspired by https://github.com/nodejs/docker-node/issues/340#issuecomment-321669029
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
    for key in \
      58118E89F3A912897C070ADBF76221572C52609D \
    ; do \
      apt-key adv --no-tty --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" || \
      apt-key adv --no-tty --batch --keyserver hkp://keyserver.pgp.com:80 --recv-keys "$key" || \
      apt-key adv --no-tty --batch --keyserver hkp://ipv4.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
    done && \
    pip3 install --upgrade \
        awscli \
        virtualenv \
        && \
    /tmp/build/install-esh.sh v0.3.1 && \
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
