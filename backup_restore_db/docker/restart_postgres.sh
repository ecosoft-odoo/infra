#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
pg_container=`cat $base_dir/$datafile | jq '.pg_container' | cut -d'"' -f2`

# Restart postgres
echo "restarting: " $pg_container
docker restart $pg_container

exit 0