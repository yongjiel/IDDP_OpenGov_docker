Docker deployment of OpenGov
============================

To run the OpenGov application in Docker:

```Bash
# In one terminal
docker-compose build # Takes a while
docker-compose up -d redis solr db

# In another terminal
docker-compose logs -f
# Wait for db to finish initializing

# In the original terminal
docker-compose up -d
```

Eventually, the wait for the db to finish initializing will be automated. Until this is done, however, ckan will error out before the db is ready, and on restarting it Apache sometimes thinks another copy of itself is running. Again, clearing the PID file can probably be automated on container start, but this hasn't been done yet.

You can now use http://localhost:8001 to connect to the application. Note that the datapusher is exposed on 8800 as well.

The data is stored in named volumes. These can be viewed with:

```Bash
docker volume ls
```

It's possible to edit `docker-compose.yml` to map existing host directories into the containers instead of using the named volumes. This will be done for the datastore volume on the dev/uat/production systems because the files are stored on a network share (samba). The Postgres directory on the `db` server will be migrated into the `db-data` named volume. The `solr-data` volume will be populated by having `ckan` regenerate the `solr` index.

To see where a named volume's data is stored:

```Bash
docker volume inspect VOLNAME
```

To stop everything temporarily:

```Bash
docker-compose stop
```

The containers can be restarted again with `docker-compose start`.

To stop and/or remove the containers:

```Bash
docker-compose down
```

To remove the volumes as well:

```Bash
docker volume rm docker_{ckan,db,redis,solr}-data
```

Currently, a copy of the solr schema from `ab_scheming` is kept with the `solr` Dockerfile and inserted into the `solr` image. We need to figure out a more robust way to do this. One possibility is to use the 'managed scheming' capability of solr to insert our extra fields via the API, but we'd need to investigate how best to make use of this.

The definition of the git commits used for ckan and each of its extensions is specified in `ckan/packages.txt`. This will need to be changed for the next deployment since the current state matches the current deployment.
