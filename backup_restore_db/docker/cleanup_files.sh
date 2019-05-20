#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
dump_loc=`cat $base_dir/$datafile | jq '.dump_loc' | cut -d'"' -f2`

# Cleanup files
# Remove file grether than 7 days ago
for file in `find $dump_loc -mtime +6 -type f -name '*.sql.gz'`
    do
        echo "deleting: " $file
        rm $file
    done

exit 0