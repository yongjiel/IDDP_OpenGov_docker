#!/bin/sh

echo "RESTORE database..."
psql -U postgres < /ckan11.dump 
rm -rf /ckan11.dump