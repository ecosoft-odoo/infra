#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
datapath="$base_dir/$datafile"
pg_user=`cat $datapath | jq '.pg_user' | cut -d'"' -f2`
pg_container=`cat $datapath | jq '.pg_container' | cut -d'"' -f2`
prod_db=`cat $datapath | jq '.prod_db' | cut -d'"' -f2`
test_db=`cat $datapath | jq '.test_db' | cut -d'"' -f2`

dbs="$(docker exec -ti $pg_container psql -U $pg_user -l | grep $pg_user | cut -d'|' -f1 | cut -d' ' -f2)"

# Check case if found test db will be 1 but not will be 0
found_test_db=0
for db in $dbs
    do
        if [[ $db == $test_db ]]; then
            found_test_db=1
        fi
    done

# Create test db
if [[ $found_test_db == 0 ]]; then
    echo "creating db: " $test_db
    docker exec -ti $pg_container createdb -U $pg_user $test_db --template="$prod_db"
fi

exit 0