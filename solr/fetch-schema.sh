#!/bin/sh

fetch-schema()
{
	local CORE=$1
	local COREDIR=${SOLR_HOME:=/opt/solr/server/solr}/$CORE

	# TODO: get this from the ckan container
	local CKAN_REPO=https://raw.githubusercontent.com/ckan/ckan
	local CKAN_REVISION=ckan-2.3.5

	#if [ ! -e $COREDIR/conf/managed-schema ]; then
		echo "Fetching schema for $CORE"
		# wget -N -O $COREDIR/conf/managed-schema $CKAN_REPO/$CKAN_REVISION/ckan/config/solr/schema.xml
		cp -p /schema.xml $COREDIR/conf/managed-schema
		rm -rf $COREDIR/conf/schema.xml
		ln -s managed-schema $COREDIR/conf/schema.xml # For CKAN
	#else
	#    echo "Schema for $CORE already exists"
	#fi
}

fetch-schema "${SOLR_CORE?"Error: SOLR_CORE not set"}"
