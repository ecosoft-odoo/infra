#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
datapath="$base_dir/$datafile"
pg_user=`cat $datapath | jq '.pg_user' | cut -d'"' -f2`
pg_container=`cat $datapath | jq '.pg_container' | cut -d'"' -f2`
test_db=`cat $datapath | jq '.test_db' | cut -d'"' -f2`

dbs="$(docker exec -ti $pg_container psql -U $pg_user -l | grep $pg_user | cut -d'|' -f1 | cut -d' ' -f2)"

for db in $dbs
    do
        if [[ $db == $test_db ]]; then
            echo "drop db: " $db
            docker exec -ti $pg_container dropdb -U $pg_user $db
        fi
    done

exit 0