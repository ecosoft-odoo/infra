#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
odoo_container=`cat $base_dir/$datafile | jq '.odoo_container' | cut -d'"' -f2`

# Start odoo
echo "starting: " $odoo_container
docker start $odoo_container

exit 0