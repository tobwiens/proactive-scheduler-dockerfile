FROM java:openjdk-8-jdk as scheduling-api

WORKDIR /data
# Update and install tools
RUN ["/bin/bash", "-c", "apt-get update && apt-get install git -y"]

RUN git clone https://github.com/ow2-proactive/scheduling-api.git
RUN pwd
RUN ls scheduling-api/scheduling-api-http/

WORKDIR /data/scheduling-api
RUN ./gradlew build war


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
RUN useradd ${USER} -g 0 -m
#USER ${USER}


# Create directories
RUN ["/bin/bash", "-c", "mkdir $DATA_FOLDER && \
mkdir $TMP_FOLDER"]

# Get current master of ProActive repositiories
WORKDIR ${DATA_FOLDER}

# Build Scheduling
RUN ["/bin/bash", "-c", " git clone https://github.com/ow2-proactive/scheduling.git"]
WORKDIR ${PROACTIVE_HOME}
RUN ["/bin/bash", "-c", "./gradlew serialver dist"]

COPY --from=scheduling-api /data/scheduling-api/scheduling-api-http/build/libs/*.war $PROACTIVE_HOME/dist/war/scheduling-api.war

# Don't write credentials files on login, because the config directory should be read-only, OpenShift enforces that
RUN sed -i -e 's/pa.scheduler.create.credentials.when.login=true/pa.scheduler.create.credentials.when.login=false/g' $PROACTIVE_HOME/config/scheduler/settings.ini

VOLUME ${PROACTIVE_HOME}/logs
VOLUME ${PROACTIVE_HOME}/data
VOLUME /tmp
VOLUME ${PROACTIVE_HOME}/config

EXPOSE 8080

# Run proactive scheduler with zero nodes (Not shell exec form here, because we need to pass
#  parameters to the script and not the shell)
ENTRYPOINT ["/home/paserver/data/scheduling/bin/proactive-server", "-ln", "0", "-Dproactive.useIPaddress=true"]
