#!/bin/bash
odoo_container="odoo-12.0"
postgres_container="postgres-11.2"
database_prod="AAL"
database_test="AAL_TEST"
postgres_user="odoo"
filestore_loc="/var/lib/odoo/.local/share/Odoo/filestore"

echo "=================== Start ==================="

# Stop odoo
echo "1. Stop" $odoo_container
docker stop $odoo_container
echo ""

# Restart postgres
echo "2. Restart" $postgres_container
docker restart $postgres_container
echo ""

# Sleep 5 minutes
echo "3. Stop next command 1 minutes"
sleep 60
echo ""

# Drop database test
echo "4. Drop" $database_test
docker exec $postgres_container dropdb -U $postgres_user $database_test
echo ""

# Copy prod db > test db
echo "5. Copy" $database_prod "to" $database_test
docker exec $postgres_container createdb -U $postgres_user $database_test --template=$database_prod
echo ""

# disable scheduled actions for test db
echo "6. Disable all scheduled actions"
docker exec $postgres_container psql -U $postgres_user $database_test -c "update ir_cron set active = False"
echo ""

# Start odoo
echo "7. Start" $odoo_container
docker start $odoo_container
echo ""

# copy prod filestore > test filestore
echo "8. Copy" $filestore_loc/$database_prod "to" $filestore_loc/$database_test
docker exec $odoo_container rm -r $filestore_loc/$database_test
docker exec $odoo_container cp -r $filestore_loc/$database_prod $filestore_loc/$database_test

echo "=================== Finish ==================="
