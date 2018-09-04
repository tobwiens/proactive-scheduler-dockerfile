# Java-8
FROM java:openjdk-8-jdk

ENV USER_GROUP proactive
ENV USER paserver
ENV USER_HOME /home/${USER}
ENV DATA_FOLDER ${USER_HOME}/data
ENV TMP_FOLDER ${DATA_FOLDER}/tmp
ENV PROACTIVE_HOME ${DATA_FOLDER}/scheduling

RUN echo $PROACTIVE_HOME

# Update and install tools
RUN ["/bin/bash", "-c", "apt-get update && apt-get install git -y"]

# Add user for proactive installation
RUN groupadd ${USER_GROUP}
RUN useradd ${USER} -g ${USER_GROUP} -m
USER ${USER}


# Create directories
RUN ["/bin/bash", "-c", "mkdir $DATA_FOLDER && \
mkdir $TMP_FOLDER"]

# Get current master of ProActive repositiories
WORKDIR ${DATA_FOLDER}

# Build Scheduling
RUN ["/bin/bash", "-c", " git clone https://github.com/ow2-proactive/scheduling.git"]
WORKDIR ${PROACTIVE_HOME}
RUN ["/bin/bash", "-c", "./gradlew serialver dist"]

# Create directories for the web interfaces
RUN ["/bin/bash", "-c", "mkdir dist/war/studio && \
mkdir dist/war/rm && \
mkdir dist/war/scheduler"]

# Get Studio interface
WORKDIR ${TMP_FOLDER}
RUN ["/bin/bash", "-c", "git clone https://github.com/ow2-proactive/studio.git && \
mv studio/app/* $PROACTIVE_HOME/dist/war/studio/ && \
rm -rf $TMP_FOLDER/studio"]

# Get Scheduler and Resource Manager Interface
WORKDIR ${TMP_FOLDER}
RUN ["/bin/bash", "-c", "git clone https://github.com/ow2-proactive/scheduling-portal.git && \
cd scheduling-portal && \
./gradlew war && \
mv scheduler-portal/build/libs/scheduler-portal-*.war $PROACTIVE_HOME/dist/war/scheduler.war && \
mv rm-portal/build/libs/rm-portal-*.war $PROACTIVE_HOME/dist/war/rm.war && \
rm -rf $TMP_FOLDER/scheduling-portal"]

VOLUME ${PROACTIVE_HOME}/logs
VOLUME ${PROACTIVE_HOME}/data
VOLUME /tmp

EXPOSE 8080

# Run proactive scheduler with zero nodes
ENTRYPOINT ["/bin/bash", "-c", "$PROACTIVE_HOME/bin/proactive-server", "-ln" ,"0", "-Dproactive.useIPaddress=true"]
