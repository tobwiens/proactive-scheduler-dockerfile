# Run on top of ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER Tobias Wiens <https://github.com/tobwiens/proactive-scheduler-dockerfile/>

# Update and install tools
RUN ["/bin/bash", "-c", "apt-get update && apt-get install wget unzip -y"]

# Environment variables - determine the proactive version
ENV PROACTIVE_ZIP ProActiveWorkflowsScheduling-linux-x64-7.3.0.zip
ENV PROACTIVE_URL_TO_ZIP http://www.activeeon.com/public_content/releases/ProActive/7.3.0
ENV PROACTIVE_HOME /data/scheduling

# Create directories
RUN ["/bin/bash", "-c", "mkdir /data && \
mkdir /data/tmp && \
mkdir $PROACTIVE_HOME && \
mkdir $PROACTIVE_HOME/dist"]

# Download proactive and copy libraries, config files and addons
WORKDIR /data/tmp
RUN ["/bin/bash", "-c", "wget $PROACTIVE_URL_TO_ZIP/$PROACTIVE_ZIP && \
unzip $PROACTIVE_ZIP && \
rm $PROACTIVE_ZIP && \
cp -r ProActiveWorkflowsScheduling-*/* $PROACTIVE_HOME && \
rm -rf /data/tmp"]

# Run proactive scheduler with zero nodes
ENTRYPOINT ["/data/scheduling/bin/proactive-server", "-ln" ,"0", "-Dproactive.useIPaddress=true"]
