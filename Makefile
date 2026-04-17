JENKINS_REMOTING_TAG := 3261.v9c670a_4748a_9-8-jdk11
JOB := remoting-${JENKINS_REMOTING_TAG}
CLEAN_JOB := clean-${JENKINS_REMOTING_TAG}

# Default target builds Java 11, 17, and 21 variants
all: remoting-3261.v9c670a_4748a_9-8-jdk11 remoting-3307.v632ed11b_3a_c7-1-jdk17 remoting-3307.v632ed11b_3a_c7-1-jdk21

clean: ${CLEAN_JOB}
.PHONY: all clean ${JOB} ${CLEAN_JOB} remoting-3261.v9c670a_4748a_9-8-jdk11 remoting-3307.v632ed11b_3a_c7-1-jdk17 remoting-3307.v632ed11b_3a_c7-1-jdk21

${JOB}: remoting-%: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=$* \
	  --tag dwolla/jenkins-agent-core:$*-SNAPSHOT \
	  .

remoting-3261.v9c670a_4748a_9-8-jdk11: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=3261.v9c670a_4748a_9-8-jdk11 \
	  --tag dwolla/jenkins-agent-core:3261.v9c670a_4748a_9-8-jdk11-SNAPSHOT \
	  .

remoting-3307.v632ed11b_3a_c7-1-jdk17: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=3307.v632ed11b_3a_c7-1-jdk17 \
	  --tag dwolla/jenkins-agent-core:3307.v632ed11b_3a_c7-1-jdk17-SNAPSHOT \
	  .

remoting-3307.v632ed11b_3a_c7-1-jdk21: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=3307.v632ed11b_3a_c7-1-jdk21 \
	  --tag dwolla/jenkins-agent-core:3307.v632ed11b_3a_c7-1-jdk21-SNAPSHOT \
	  .

${CLEAN_JOB}: clean-%:
	docker rmi -f dwolla/jenkins-agent-core:$*-SNAPSHOT
