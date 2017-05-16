#!/bin/sh

echo "SET PERMISSION for datastore..."
cat /set_permission.sql | psql -U postgres --set ON_ERROR_STOP=1 
rm -rf /set_permission.sql
