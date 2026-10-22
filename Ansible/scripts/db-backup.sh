#!/bin/bash

BACKUP_DIR=/opt/backup/mysql

mkdir -p "$BACKUP_DIR"

docker compose -f /home/rockylab/fitnessWebApp/compose.yaml exec -T db \
  sh -c 'mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" fitness_web_app' \
  | gzip > "$BACKUP_DIR/fitness_$(date +%F).sql.gz"

# brisanje backupa starjih od 7 dana
find "$BACKUP_DIR" -name "fitness_*.sql.gz" -mtime +7 -delete
