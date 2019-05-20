#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
datapath="$base_dir/$datafile"
filestore_loc=`cat $datapath | jq '.filestore_loc' | cut -d'"' -f2`
prod_db=`cat $datapath | jq '.prod_db' | cut -d'"' -f2`
test_db=`cat $datapath | jq '.test_db' | cut -d'"' -f2`

# Delete filestore
for dir in `find $filestore_loc -type d -name $test_db`
    do
        echo "Deleting: " $dir
        rm -r $dir
    done

# Check case if found filestore will be 1 but not will be 0
found_filestore=0
for dir in `find $filestore_loc -type d -name $prod_db`
    do
      found_filestore=1  
    done

# Copy filestore
if [[ $found_filestore == 1 ]]; then
    echo "creating filestore: " $filestore_loc/$test_db
    cp -r $filestore_loc/$prod_db $filestore_loc/$test_db
fi