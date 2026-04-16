JENKINS_REMOTING_TAG := bookworm-jdk11
JOB := remoting-${JENKINS_REMOTING_TAG}
CLEAN_JOB := clean-${JENKINS_REMOTING_TAG}

# Default target builds Java 11, 17, and 21 variants
all: remoting-bookworm-jdk11 remoting-4.13.3-1-jdk17 remoting-3355.v388858a_47b_33-5-jdk21

clean: ${CLEAN_JOB}
.PHONY: all clean ${JOB} ${CLEAN_JOB} remoting-bookworm-jdk11 remoting-4.13.3-1-jdk17 remoting-3355.v388858a_47b_33-5-jdk21

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

remoting-4.13.3-1-jdk17: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=4.13.3-1-jdk17 \
	  --tag dwolla/jenkins-agent-core:4.13.3-1-jdk17-SNAPSHOT \
	  .

remoting-3355.v388858a_47b_33-5-jdk21: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=3355.v388858a_47b_33-5-jdk21 \
	  --tag dwolla/jenkins-agent-core:3355.v388858a_47b_33-5-jdk21-SNAPSHOT \
	  .

${CLEAN_JOB}: clean-%:
	docker rmi -f dwolla/jenkins-agent-core:$*-SNAPSHOT