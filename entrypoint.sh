#!/bin/sh
set -e

echo "Starting MikoPBX custom entrypoint..."

# === Fix /dev/console issue ===
if [ ! -e /dev/console ]; then
    echo "Redirecting missing /dev/console..."
    ln -sf /dev/null /dev/console
fi

# === Ensure /storage exists and is writable ===
if [ ! -d /storage ]; then
    echo "Creating /storage..."
    mkdir -p /storage
fi
chmod -R 777 /storage || true

# === Database persistence setup ===
DB_STORAGE="/storage/usbdisk1/mikopbx/persistence"
ORIG_DB="/offload/rootfs/usr/www/src/Common/Models/astdb.sqlite3"

mkdir -p "$DB_STORAGE"
chmod -R 770 "$DB_STORAGE"
chown -R www:www "$DB_STORAGE"

# Move original database to storage if not already there
if [ ! -f "$DB_STORAGE/astdb.sqlite3" ] && [ -f "$ORIG_DB" ]; then
    echo "Moving database to writable storage..."
    mv "$ORIG_DB" "$DB_STORAGE/astdb.sqlite3"
fi

# Symlink database in app path to storage
if [ ! -L "$ORIG_DB" ]; then
    echo "Linking database from storage..."
    rm -f "$ORIG_DB"
    ln -s "$DB_STORAGE/astdb.sqlite3" "$ORIG_DB"
fi

# === Ensure storage directories are writable by MikoPBX user ===
chown -R www:www /storage/usbdisk1/mikopbx
chmod -R 770 /storage/usbdisk1/mikopbx

# === Log mount status for verification ===
echo "Current mount points related to /offload or /storage:"
mount | grep -E "offload|storage" || true

# === Hand over to original MikoPBX entrypoint ===
exec /sbin/docker-entrypoint "$@"
