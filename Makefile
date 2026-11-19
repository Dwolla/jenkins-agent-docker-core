JENKINS_REMOTING_TAG := 3395.v6e5377b_0fb_3c-5-jdk21
IMAGE := dwolla/jenkins-agent-core:${JENKINS_REMOTING_TAG}-SNAPSHOT

# One core image: the agent runs on the inbound-agent's Java 21. Images that need a different
# build JDK (the sbt images) add it themselves and point JAVA_HOME at it.
all: build
.PHONY: all build clean

build: Dockerfile
	docker build \
	  --build-arg JENKINS_REMOTING_TAG=${JENKINS_REMOTING_TAG} \
	  --tag ${IMAGE} \
	  .

clean:
	docker rmi -f ${IMAGE}
