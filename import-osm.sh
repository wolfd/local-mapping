#!/bin/bash

set -e
set -x

if [ -z "$DIRECTORY_OF_OSM_FILES" ]
then
  echo "\$DIRECTORY_OF_OSM_FILES must be specified, gets mounted to container"
  exit 1
fi

if [ -z "$OSM_FILE" ]
then
  echo "\$OSM_FILE must be specified (e.g. \"planet.osm.pbf\"), gets imported"
  exit 1
fi

NUM_CORES=$(getconf _NPROCESSORS_ONLN)
FREE_MEM=$(free -m | awk '/^Mem:/{print $4}')
PROB_SAFE_MEM=$(($FREE_MEM / 6 * 4))

docker run -it --rm \
  --network local-mapping_default \
  -e PGPASS=secretmapping \
  --link $(docker-compose ps postgis | sed -n 3p | cut -d" " -f1):pg \
  -v $DIRECTORY_OF_OSM_FILES:/osm \
  -v "$(pwd)"/openstreetmap-carto:/transforms openfirmware/osm2pgsql \
  -c "osm2pgsql --create --slim --hstore --style /transforms/openstreetmap-carto.style --tag-transform-script /transforms/openstreetmap-carto.lua --cache $PROB_SAFE_MEM --number-processes $NUM_CORES --database osm --username osm --host pg --port 5432 /osm/$OSM_FILE"
