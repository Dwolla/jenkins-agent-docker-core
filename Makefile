JENKINS_REMOTING_TAG := 4.13.3-1-jdk11
JOB := remoting-${JENKINS_REMOTING_TAG}
CLEAN_JOB := clean-${CORE_TAG}

clean: ${CLEAN_JOB}
.PHONY: all clean ${JOB} ${CLEAN_JOB}

${JOB}: remoting-%: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=$* \
	  --tag dwolla/jenkins-agent-core:$*-SNAPSHOT \
	  .

${CLEAN_JOB}: clean-%:
	docker rmi -f dwolla/jenkins-agent-core:$*-SNAPSHOT