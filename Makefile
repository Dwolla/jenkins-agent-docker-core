JENKINS_REMOTING_TAG := bookworm-jdk11
JOB := remoting-${JENKINS_REMOTING_TAG}
CLEAN_JOB := clean-${JENKINS_REMOTING_TAG}

# Default target builds Java 11, 17, and 21 variants
all: remoting-bookworm-jdk11 remoting-bookworm-jdk17 remoting-bookworm-jdk21

clean: ${CLEAN_JOB}
.PHONY: all clean ${JOB} ${CLEAN_JOB} remoting-bookworm-jdk11 remoting-bookworm-jdk17 remoting-bookworm-jdk21

${JOB}: remoting-%: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=$* \
	  --tag dwolla/jenkins-agent-core:$*-SNAPSHOT \
	  .

remoting-bookworm-jdk11: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=bookworm-jdk11 \
	  --tag dwolla/jenkins-agent-core:bookworm-jdk11-SNAPSHOT \
	  .

remoting-bookworm-jdk17: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=bookworm-jdk17 \
	  --tag dwolla/jenkins-agent-core:bookworm-jdk17-SNAPSHOT \
	  .

remoting-bookworm-jdk21: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=bookworm-jdk21 \
	  --tag dwolla/jenkins-agent-core:bookworm-jdk21-SNAPSHOT \
	  .

${CLEAN_JOB}: clean-%:
	docker rmi -f dwolla/jenkins-agent-core:$*-SNAPSHOT