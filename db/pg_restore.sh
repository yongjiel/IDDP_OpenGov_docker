#!/bin/sh

psql -U postgres < /ckan11.dump 
#rm /ckan11.dump