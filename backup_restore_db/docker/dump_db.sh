#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
datapath="$base_dir/$datafile"
pg_user=`cat $datapath | jq '.pg_user' | cut -d'"' -f2`
pg_container=`cat $datapath | jq '.pg_container' | cut -d'"' -f2`
prod_db=`cat $datapath | jq '.prod_db' | cut -d'"' -f2`
dump_loc=`cat $datapath | jq '.dump_loc' | cut -d'"' -f2`

dbs="$(docker exec -ti $pg_container psql -U $pg_user -l | grep $pg_user | cut -d'|' -f1 | cut -d' ' -f2)"

for db in $dbs
    do
        if [[ $db == $prod_db ]]; then
            datetime=`date +"%Y%m%d_%H%M%S"`
            filename="${dump_loc}/${db}_${datetime}.sql"
            echo "backup db: " ${filename}.gz
            docker exec -t $pg_container pg_dump -c -U $pg_user $db > $filename
            gzip $filename
        fi
    done

exit 0
