# This Dockerfile builds the scheduling master only.

# Java-8
FROM java:openjdk-8-jdk
MAINTAINER Tobias Wiens <https://github.com/tobwiens/proactive-scheduler-dockerfile/>

# Update and install tools
RUN ["/bin/bash", "-c", "apt-get update && apt-get install git -y"]

# Environment variables - determine the proactive version
ENV PROACTIVE_HOME /data/scheduling

# Create directories
RUN ["/bin/bash", "-c", "mkdir /data && \
mkdir /data/tmp"]

# Get current master of ProActive repositiories
WORKDIR /data

# Build Scheduling
RUN ["/bin/bash", "-c", " git clone https://github.com/ow2-proactive/scheduling.git"]
WORKDIR /data/scheduling
RUN ["/bin/bash", "-c", "./gradlew dist"]

EXPOSE 8080

# Run proactive scheduler with zero nodes
ENTRYPOINT ["/data/scheduling/bin/proactive-server", "-ln" ,"0", "-Dproactive.useIPaddress=true"]
