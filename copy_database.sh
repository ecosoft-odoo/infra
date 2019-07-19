#!/bin/bash
odoo_container="odoo-12.0"
postgres_container="postgres-11.2"
database_prod="AAL"
database_test="AAL_TEST"
postgres_user="odoo"
filestore_dir="/odoo-12.0/data/.local/share/Odoo/filestore"

echo "=================== Start ==================="

# Stop odoo
echo "Stop" $odoo_container
docker stop $odoo_container

# Restart postgres
echo "Restart" $postgres_container
docker restart $postgres_container

# Sleep 5 minutes
echo "Stop next command 5 minutes"
sleep 5m

# Drop database test
echo "Drop" $database_test
docker exec $postgres_container dropdb -U $postgres_user $database_test

# Copy prod db > test db
echo "Copy" $database_prod "to" $database_test
docker exec $postgres_container createdb -U $postgres_user $database_test --template=$database_prod

# disable scheduled actions for test db
echo "Disable all scheduled actions"
docker exec $postgres_container psql -U $postgres_user $database_test -c "update ir_cron set active = False"

# copy prod data file > test data file
echo "Copy" $filestore_dir/$database_prod "to" $filestore_dir/$database_test
rm -r $filestore_dir/$database_test
cp -r $filestore_dir/$database_prod $filestore_dir/$database_test

# Start odoo
echo "Start" $odoo_container
docker start $odoo_container

echo "=================== Finish ==================="
