# Jenkins Agent Core

[![license](https://img.shields.io/github/license/dwolla/jenkins-agent-docker-core.svg?style=flat-square)](https://github.com/Dwolla/jenkins-agent-docker-core/blob/master/LICENSE)

Docker images containing the Jenkins remoting JAR and necessary dependencies.

GitHub Actions will build the Docker images for multiple supported architectures.

Every image runs the Jenkins agent process (Remoting) on Java 21, which Jenkins 2.555 and later
require, and gives builds a separate build JDK (11, 17, 21 or 25):

| | Where | How it's selected |
|---|---|---|
| Agent JVM | `/opt/java/openjdk` (Java 21, from `jenkins/inbound-agent`) | `JENKINS_JAVA_BIN` |
| Build JDK | `/opt/java/build-jdk` (Eclipse Temurin, pinned by digest) | `JAVA_HOME`, and first on `PATH` |

Tags read `<remoting tag>-build-jdk<N>-<sha>`, for example
`3395.v6e5377b_0fb_3c-5-jdk21-build-jdk11-abc1234`: the agent runs on Java 21 and builds see JDK 11.

To build locally, run `make all`, or `make build-jdk11` (or 17, 21, 25) for one variant.
