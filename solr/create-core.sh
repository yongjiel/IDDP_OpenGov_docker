#!/bin/sh

create-core()
{
	local CORE=$1
	local COREDIR=${SOLR_HOME:=/opt/solr/server/solr}/$CORE
	local CONFIG=${SOLR_CONFIG:=basic_configs}

	if [ ! -e $COREDIR/core.properties ]; then
	    echo "Creating core $CORE"
		mkdir -p $COREDIR
	    cp -a $SOLR_HOME/configsets/$CONFIG/* $COREDIR/
	    rm -f $COREDIR/conf/managed-schema # TEMP
	    touch $COREDIR/core.properties
	else
	    echo "Core $CORE already exists"
	fi
}

create-core "${SOLR_CORE?"Error: SOLR_CORE not set"}"
