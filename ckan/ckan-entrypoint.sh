#!/bin/bash
set -e


: ${CKAN_SQLALCHEMY_URL:?}
: ${CKAN_SOLR_URL:?}
: ${CKAN_REDIS_URL:?}
: ${CKAN_DATASTORE_READ_URL:?}
: ${CKAN_DATASTORE_WRITE_URL:?}
: ${CKAN_SITE_URL:?}
: ${CKAN_STORAGE_PATH:?}

CKAN_CONFIG_FILE="${CKAN_CONFIG}/ckan.ini"

if [ ! -e "${CKAN_CONFIG_FILE}" ]; then

  echo "Creating a default config"

  # Let CKAN create a default config file
  ckan-paster make-config ckan "$CKAN_CONFIG_FILE"

  # Add our custom settings
  ckan-paster --plugin=ckan config-tool "$CKAN_CONFIG_FILE" \
    -f $CKAN_HOME/ckan-settings.ini
fi

echo "Updating config from environment"

# Copy the current env into the config
# CKAN 6.2 picks up these automatically:
#   CKAN_SQLALCHEMY_URL CKAN_SOLR_URL CKAN_REDIS_URL
ckan-paster --plugin=ckan config-tool "$CKAN_CONFIG_FILE" -e \
  "sqlalchemy.url = ${CKAN_SQLALCHEMY_URL}" \
  "solr_url = ${CKAN_SOLR_URL}" \
  "ckan.redis.url = ${CKAN_REDIS_URL}" \
  "ckan.datastore.read_url = ${CKAN_DATASTORE_READ_URL}" \
  "ckan.datastore.write_url = ${CKAN_DATASTORE_WRITE_URL}" \
  "ckan.site_url = ${CKAN_SITE_URL}" \
  "ckan.storage_path = ${CKAN_STORAGE_PATH}"

echo "Making directories"

# Ensure storage directory exists and is writable by Apache modules
mkdir -p "${CKAN_STORAGE_PATH}"
chown www-data: "$CKAN_STORAGE_PATH"

#echo "Initializing database"

# Initialize the Database
#ckan-paster --plugin=ckan db init -c "$CKAN_CONFIG_FILE"

echo "Executing" "$@"

exec "$@"
