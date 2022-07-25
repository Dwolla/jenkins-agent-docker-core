JENKINS_REMOTING_TAGS := 4.13.2-1-jdk8 4.13.2-1-jdk11
JOBS := $(addprefix remoting-,${JENKINS_REMOTING_TAGS})

all: ${JOBS}
.PHONY: all ${JOBS}

${JOBS}: remoting-%: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=$* \
	  --tag dwolla/jenkins-agent-core:$*-SNAPSHOT \
	  .
