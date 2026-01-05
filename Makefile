JENKINS_REMOTING_TAG := 4.13.2-1-jdk11
JOB := remoting-${JENKINS_REMOTING_TAG}
CLEAN_JOB := clean-${CORE_TAG}

# Default target builds Java 11 variant
all: remoting-4.13.2-1-jdk11 remoting-4.13.3-1-jdk17

clean: ${CLEAN_JOB}
.PHONY: all clean ${JOB} ${CLEAN_JOB} remoting-4.13.2-1-jdk11 remoting-4.13.3-1-jdk17

${JOB}: remoting-%: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=$* \
	  --tag dwolla/jenkins-agent-core:$*-SNAPSHOT \
	  .

remoting-4.13.2-1-jdk11: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=4.13.2-1-jdk11 \
	  --tag dwolla/jenkins-agent-core:4.13.2-1-jdk11-SNAPSHOT \
	  .

remoting-4.13.3-1-jdk17: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=4.13.3-1-jdk17 \
	  --tag dwolla/jenkins-agent-core:4.13.3-1-jdk17-SNAPSHOT \
	  .

${CLEAN_JOB}: clean-%:
	docker rmi -f dwolla/jenkins-agent-core:$*-SNAPSHOT