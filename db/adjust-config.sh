# This script is sourced by docker-entrypoint.sh

sed -i '/^host/d' $PGDATA/pg_hba.conf
(
	echo "# From docker-entrypoint.sh"
	echo
	echo "# Allow application servers"
	for H in $POSTGRES_APP_HOSTS
	do
		echo "host all all $H md5"
	done

	echo "# Allow replication servers"
	for H in $POSTGRES_REP_HOSTS
	do
		echo "host replication rep $H md5"
	done
) >>$PGDATA/pg_hba.conf


cat >>$PGDATA/postgresql.conf <<-EOF

	# From docker-entrypoint.sh

	max_connections = 400

	log_destination = 'stderr'
	logging_collector = on
	log_rotation_size = 50MB
	log_line_prefix = '< %m >'

	wal_level = hot_standby
	archive_mode = on
	max_wal_senders = 10
	hot_standby = on
EOF
