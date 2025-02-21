ARG JENKINS_REMOTING_TAG

FROM jenkins/inbound-agent:$JENKINS_REMOTING_TAG
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-core"
ENV JENKINS_HOME=/home/jenkins

WORKDIR ${JENKINS_HOME}

USER root

RUN set -ex && \
    apt-get update && \
    apt-get install -y \
        apt-transport-https \
        asciidoctor \
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
        wget \
        zip \
        && \
    pip3 install --upgrade \
        virtualenv \
        && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /tmp/build && \
    mkdir -p /usr/share/man/man1/ && \
    touch /usr/share/man/man1/sh.distrib.1.gz

# install esh
RUN wget https://github.com/jirutka/esh/archive/v0.3.2/esh-0.3.2.tar.gz && \
    tar -xzf esh-0.3.2.tar.gz && \
    rm -f esh-0.3.2.tar.gz
RUN cd esh-0.3.2 && \
    make test && \
    make install prefix=/usr/local DESTDIR=/
RUN rm -rf esh-0.3.2

# install awscli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    rm -f awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws

# change /bin/sh to use bash, because lots of our scripts use bash features
RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER jenkins

RUN git config --global user.email "dev+jenkins@dwolla.com" && \
    git config --global user.name "Jenkins Build Agent" && \
    git config --global init.defaultBranch main

ENTRYPOINT ["jenkins-agent"]
