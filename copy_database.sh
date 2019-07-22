#!/bin/bash
# Get parameters from command line
for param in "$@"
do
    str1=`echo $param | cut -d'=' -f1`
    str2=`echo $param | cut -d'=' -f2`
    # Odoo Container Name
    if [ $str1 == "odoo" ]
    then
        odoo_container=$str2
    fi
    # Postgres Container Name
    if [ $str1 == "postgres" ]
    then
        postgres_container=$str2
    fi
    # Database Name
    if [ $str1 == "database" ]
    then
        database_prod=$str2
    fi
    # Postgres User
    if [ $str1 == "user" ]
    then
      postgres_user=$str2
    fi
    # filestore location
    if [ $str1 == "filestore" ]
    then
      filestore_loc=$str2
    fi
done

# Check arguments is not null
if [[ $odoo_container == "" || $postgres_container == "" || $database_prod == "" || $postgres_user == "" || $filestore_loc == "" ]]
then
    echo "Error!!! Parameter is not valid, please see detail in https://ecosoft-kx.blogspot.com/2019/07/auto-duplicate-database.html"
    exit 0
fi

# Define database_test = ${database_prod}_TEST
database_test=${database_prod}_TEST

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

exit 0
