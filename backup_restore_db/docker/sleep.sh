#!/bin/bash
base_dir=$(dirname "$0")
datafile="data.json"
delay=`cat $base_dir/$datafile | jq '.delay' | cut -d'"' -f2`

# Pause bash script
echo "Pause bash script: " $delay
sleep $delay

exit 0