# Run on top of ubuntu
FROM dockerfile/ubuntu
MAINTAINER Tobias Wiens <tobwiens@gmail.com>

# Environment variables - determine the proactive version
ENV PROACTIVE_ZIP ProActiveWorkflowsScheduling-linux-x64-6.1.0.zip
ENV PROACTIVE_URL_TO_ZIP http://www.activeeon.com/public_content/releases/ProActive/6.1.0
ENV PROACTIVE_HOME /data/scheduling

# Create directories
RUN ["/bin/bash", "-c", "mkdir /data && \
mkdir /data/tmp && \
mkdir $PROACTIVE_HOME && \
mkdir $PROACTIVE_HOME/dist"]

# Download proactive and copy libraries, config files and addons
WORKDIR /data/tmp
RUN ["/bin/bash", "-c", "wget $PROACTIVE_URL_TO_ZIP/$PROACTIVE_ZIP && \
unzip ProActiveWorkflowsScheduling-linux-x64-6.1.0.zip && \
rm ProActiveWorkflowsScheduling-linux-x64-6.1.0.zip && \
cp -r ProActiveWorkflowsScheduling-linux-x64-6.1.0/* $PROACTIVE_HOME && \
rm -rf /data/tmp"]

# Run proactive scheduler with zero nodes
ENTRYPOINT ["/data/scheduling/bin/proactive-server", "-ln" ,"0", "-Dproactive.useIPaddress=true"]
