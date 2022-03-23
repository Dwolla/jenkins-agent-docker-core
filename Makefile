TEMURIN_TAGS := 8u322-b06-jdk 11.0.14.1_1-jdk
JOBS := $(addprefix temurin-,${TEMURIN_TAGS})

all: ${JOBS}
.PHONY: all ${JOBS}

${JOBS}: temurin-%: Dockerfile
	docker build \
	  --build-arg TEMURIN_TAG=$* \
	  --tag dwolla/jenkins-agent-core:$*-SNAPSHOT \
	  .
