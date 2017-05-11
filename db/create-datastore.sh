#!/bin/sh

psql -U postgres <<-EOF
	create user datastore login password '$POSTGRES_PASS2';
	create database datastore with owner datastore;
	alter user $POSTGRES_USER nosuperuser;
EOF
