#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
odoo_container=`cat $base_dir/$datafile | jq '.odoo_container' | cut -d'"' -f2`

# Stop odoo
echo "stoping: " $odoo_container
docker stop $odoo_container

exit 0