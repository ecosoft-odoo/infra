#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
datapath="$base_dir/$datafile"
dump_loc=`cat $datapath | jq '.dump_loc' | cut -d'"' -f2`
prod_db=`cat $datapath | jq '.prod_db' | cut -d'"' -f2`
dest_dump_loc=`cat $datapath | jq '.dest_dump_loc' | cut -d'"' -f2`
dest_user=`cat $datapath | jq '.dest_user' | cut -d'"' -f2`
dest_port=`cat $datapath | jq '.dest_port' | cut -d'"' -f2`
dest_ip=`cat $datapath | jq '.dest_ip' | cut -d'"' -f2`

# Remote Backup
echo "remote backup ...."
rsync -avz --delete -e "ssh -p $dest_port" $dump_loc $dest_user@$dest_ip:$dest_dump_loc/$prod_db

exit 0