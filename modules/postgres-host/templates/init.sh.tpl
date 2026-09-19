#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y postgresql15 postgresql15-server postgresql15-contrib

postgresql-setup --initdb

echo "host all all ${vpc_cidr} scram-sha-256" >> /var/lib/pgsql/data/pg_hba.conf
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf

systemctl enable --now postgresql

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${admin_password}';"
sudo -u postgres psql <<'PSQL'
    CREATE ROLE dionysus_app WITH LOGIN PASSWORD '${db_app_password}';
    CREATE DATABASE dionysus OWNER dionysus_app;
PSQL

# Nightly backup: dump every database, upload to S3, keep local copies for 3 days
cat > /usr/local/bin/pg-backup.sh <<'BACKUP'
#!/bin/bash
set -euo pipefail
STAMP=$(date +%Y-%m-%d)
DUMP_DIR=/var/backups/postgres
mkdir -p "$DUMP_DIR"
sudo -u postgres pg_dumpall | gzip > "$DUMP_DIR/all-$STAMP.sql.gz"
aws s3 cp "$DUMP_DIR/all-$STAMP.sql.gz" "s3://${backup_bucket}/postgres/all-$STAMP.sql.gz"
find "$DUMP_DIR" -type f -mtime +3 -delete
BACKUP
chmod +x /usr/local/bin/pg-backup.sh

echo "0 3 * * * root /usr/local/bin/pg-backup.sh" > /etc/cron.d/pg-backup
