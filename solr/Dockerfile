FROM solr:6.5

LABEL maintainer="Neil Mayhew <neil.mayhew@gov.ab.ca>"
LABEL description="CKAN Solr"

# Disable logging to console
RUN sed -i '/^log4j.rootLogger=/s/, *CONSOLE//' /opt/solr/server/resources/log4j.properties

ENV SOLR_CORE ckan

# Set up auto-initialization
COPY create-core.sh  /docker-entrypoint-initdb.d/00-create-core.sh
COPY fetch-schema.sh /docker-entrypoint-initdb.d/01-fetch-schema.sh

# Temp
COPY schema.xml /
