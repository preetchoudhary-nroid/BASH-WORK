#!/bin/bash
TARGET_DIR=$1
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 /path/to/folder"
  exit 1
fi
mkdir -p "$BACKUP_DIR"
zip -r "$BACKUP_DIR/backup_$TIMESTAMP.zip" "$TARGET_DIR"

cd "$BACKUP_DIR" || exit
ls -t | tail -n +6 | xargs -r rm --
echo "BACKUP COMPLETE. older backups pruned"