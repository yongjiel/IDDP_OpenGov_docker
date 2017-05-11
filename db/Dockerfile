FROM postgres:9.6

LABEL maintainer="Neil Mayhew <neil.mayhew@gov.ab.ca>"
LABEL description="CKAN Database"

# Customize default user/pass/db
ENV POSTGRES_USER ckan
ENV POSTGRES_PASSWORD ckan
ENV POSTGRES_DB ckan

# Customize configuration on first run
ENV POSTGRES_APP_HOSTS "all"
ENV POSTGRES_REP_HOSTS "all"
COPY adjust-config.sh    /docker-entrypoint-initdb.d/
COPY create-datastore.sh /docker-entrypoint-initdb.d/
