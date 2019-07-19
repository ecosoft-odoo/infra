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
3. Edit variable in copy_database.sh
   - **odoo_container** is container name of odoo
   - **postgres_container** is container name of postgres
   - **database_prod** is database name of production
   - **database_test** is database name of test
   - **postgres_user** is user of postgres
   - **filestore_dir** is path of filestore odoo
3. Make sure /var/scripts exist, if it doesn't exist please create.
   - mkdir /var/scripts
4. Copy copy_database.sh to directory of scripts
   - cp copy_database.sh /var/scripts/copy_database.sh
5. Set time to run copy_database.sh in crontab
   1. Open crontab
      - nano /etc/crontab
   2. Put m h   * * *   root    /var/scripts/copy_database.sh > /var/log/copy_database.log 2>&1 (m = minues, h = hours)
      - Ex: 0 2   * * *   root    /var/scripts/copy_database.sh > /var/log/copy_database.log 2>&1
   3. save crontab
6. You can see log in /var/log/copy_database.log
   - tail -f /var/log/copy_database.log
