JENKINS_REMOTING_TAG := 3395.v6e5377b_0fb_3c-5-jdk21
BUILD_JDKS := 11 17 21 25

# Every variant runs the agent on Java 21 (JENKINS_REMOTING_TAG); BUILD_JDK is the JDK builds see.
# Tags read <remoting tag>-build-jdk<N>, e.g. 3395.v6e5377b_0fb_3c-5-jdk21-build-jdk11.
VARIANTS := $(addprefix build-jdk,${BUILD_JDKS})

all: ${VARIANTS}
clean: $(addprefix clean-,${VARIANTS})
.PHONY: all clean ${VARIANTS} $(addprefix clean-,${VARIANTS})

${VARIANTS}: build-jdk%: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=${JENKINS_REMOTING_TAG} \
	  --build-arg BUILD_JDK=$* \
	  --tag dwolla/jenkins-agent-core:${JENKINS_REMOTING_TAG}-build-jdk$*-SNAPSHOT \
	  .

$(addprefix clean-,${VARIANTS}): clean-build-jdk%:
	docker rmi -f dwolla/jenkins-agent-core:${JENKINS_REMOTING_TAG}-build-jdk$*-SNAPSHOT
