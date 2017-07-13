
Updates
============================

------ 
Install
------
```
sudo chown <current_user>:<current_user> -R /var/lib/docker/volumes
Add two lines into ~/.bash_profile
export DBPASS1=ckan
export DBPASS2=ckan

. ~/.bash_profile
cd jack_docker/.
mkdir -p ./mnt/opengov/appfiles
docker-compose rm -f
docker volume rm -f jackdocker_ckan-data jackdocker_db-data  jackdocker_redis-data jackdocker_solr-data
docker-compose build
docker-compose up -d solrdata solr redis db
docker-compose up --build
docker exec -ti jackdocker_db_1 rm -rf /ckan11.dump /set_permission.sql
```

------
Test server
------
http://localhost:5501

------
Mini Database
------
```
jack_docker/db/ckan/ckan11.dump is from external protgres DB dump.
Inside db image, it is postgres db ckan.
Web app login: username: default
               password: default
This database is with one organization setup and one dataset setup.
```

------
Notice
------
```
If the first time you boot up images, uncomment line "ckan-paster 
--plugin=ckan db init -c "$CKAN_CONFIG_FILE" in ckan/ckan-entrypoint.sh. 
It will generate clean database for storage. If the second time or later 
to boot images, comment that line because the database exists in host. 
Docker will hook to that database and no need of a fresh db.
```

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
