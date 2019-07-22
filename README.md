# Copy Database Script
**This script file to consist of**
1. Drop test database
2. Copy production database to test database
3. Disable scheduled actions for test database
4. Copy production filestore to test filestore

**Usage**
1. Download script file to your directory
   - git clone https://github.com/ecosoft-odoo/infra.git -b copy_database_script copy_database_script
2. Move into directory of copy_database_script
   - cd copy_database_script
3. Make sure /var/scripts exist, if it doesn't exist please create.
   - mkdir /var/scripts
4. Copy copy_database.sh to directory of scripts
   - cp copy_database.sh /var/scripts/copy_database.sh
5. Set time and pass parameters to run copy_database.sh in crontab
   1. Open crontab
      - nano /etc/crontab
   2. Put m h   * * *   root    /var/scripts/copy_database.sh **odoo**=odoo_container_name **postgres**=postgres_container_name **database**=database_name **user**=user_of_postgres **filestore**=path_of_filestore_odoo > /var/log/copy_database.log 2>&1 (m = minues, h = hours)
      - Ex: 0 2   * * *   root    /var/scripts/copy_database.sh odoo=odoo-12.0 postgres=postgres-11.2 database=AAL user=odoo filestore=/var/lib/odoo/.local/share/Odoo/filestore > /var/log/copy_database.log 2>&1
   3. save crontab
6. You can see log in /var/log/copy_database.log
   - tail -f /var/log/copy_database.log
