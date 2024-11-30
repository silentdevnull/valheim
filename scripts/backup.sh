#!/bin/bash

# Saves 15 days of backups

BACKUP_DIR="/backups"
VALHEIM_DIR="/home/steam/.config/unity3d/IronGate/Valheim"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p "${BACKUP_DIR}"
tar -czf "${BACKUP_DIR}/valheim_${DATE}.tar.gz" -C "${VALHEIM_DIR}" .

ls -t "${BACKUP_DIR}"/*.tar.gz | tail -n +15 | xargs -r rm


# Add discord webhook uri
