# trial
FROM ubuntu:18.04 as proactive-folder

WORKDIR /data
RUN ["/bin/bash", "-c", "apt-get update && apt-get install unzip -y"]
COPY activeeon_*.zip .
RUN unzip activeeon_*.zip


FROM ubuntu:18.04

ENV USER_GROUP proactive
ENV USER paserver
ENV USER_HOME /home/${USER}
ENV DATA_FOLDER ${USER_HOME}/data
ENV TMP_FOLDER ${DATA_FOLDER}/tmp
ENV PROACTIVE_HOME ${DATA_FOLDER}/scheduling

# Add user for proactive installation
RUN groupadd ${USER_GROUP}
RUN useradd ${USER} -g 0 -m
#USER ${USER}


# Create directories
RUN ["/bin/bash", "-c", "mkdir $DATA_FOLDER && \
mkdir $TMP_FOLDER"]

# Get current master of ProActive repositiories
WORKDIR ${DATA_FOLDER}

COPY --from=proactive-folder /data/activeeon_* $PROACTIVE_HOME/

# Don't write credentials files on login, because the config directory should be read-only, OpenShift enforces that
RUN sed -i -e 's/pa.scheduler.create.credentials.when.login=true/pa.scheduler.create.credentials.when.login=false/g' $PROACTIVE_HOME/config/scheduler/settings.ini

# Remove tasks from Studio
COPY studio-config.js /home/paserver/data/scheduling/dist/war/studio/scripts/proactive/config.js

VOLUME ${PROACTIVE_HOME}/logs
VOLUME ${PROACTIVE_HOME}/data
VOLUME /tmp
VOLUME ${PROACTIVE_HOME}/config

EXPOSE 8080

# Run proactive scheduler with zero nodes (Not shell exec form here, because we need to pass
#  parameters to the script and not the shell)
ENTRYPOINT ["/home/paserver/data/scheduling/bin/proactive-server", "-ln", "0", "-Dproactive.useIPaddress=true"]
