#!/bin/sh

cat /set_permission.sql | psql -U postgres --set ON_ERROR_STOP=1 
