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

# Set permission for datastore
COPY  set_permission.sql /
COPY  set_permission.sh /docker-entrypoint-initdb.d/
RUN   rm -rf /set_permission.sql

# restore postgres db
COPY ckan11.dump  /
COPY pg_restore.sh /docker-entrypoint-initdb.d/
RUN  rm -rf /ckan11.dump
