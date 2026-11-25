# Jenkins Agent Core

[![license](https://img.shields.io/github/license/dwolla/jenkins-agent-docker-core.svg?style=flat-square)](https://github.com/Dwolla/jenkins-agent-docker-core/blob/master/LICENSE)

Docker images containing the Jenkins remoting JAR and necessary dependencies.

GitHub Actions will build the Docker images for multiple supported architectures.

There is one core image. The Jenkins agent process (Remoting) runs on the inbound-agent's Java 21,
which Jenkins 2.555 and later require. `JENKINS_JAVA_BIN` pins the agent to that Java, so images
built on this one (for example the sbt images) can set `JAVA_HOME` to a different build JDK without
changing the agent's JVM.

Tags read `<remoting tag>-<sha>`, for example `3396.ve02b_5cde31b_2-4-jdk21-abc1234`.

To build locally, run `make all`.
