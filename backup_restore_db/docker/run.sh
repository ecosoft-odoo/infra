#!/bin/bash
base_dir=$(dirname "$0")

# Stop odoo
$base_dir/stop_odoo.sh

# Restart postgres
$base_dir/restart_postgres.sh

# Pause bash script
$base_dir/sleep.sh

# Cleanup files
$base_dir/cleanup_files.sh

# Dump DB
$base_dir/dump_db.sh

# Remote Backup
$base_dir/housekeeping.sh

# Drop DB
$base_dir/drop_db.sh

# Duplicate DB
$base_dir/dup_db.sh

# Copy filestore odoo
$base_dir/copy_filestore.sh

# Start odoo
$base_dir/start_odoo.sh

exit 0