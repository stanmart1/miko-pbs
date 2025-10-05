#!/bin/sh
set -e

echo "Starting MikoPBX custom entrypoint..."

# === Fix /dev/console issue ===
if [ ! -e /dev/console ]; then
    echo "Redirecting missing /dev/console..."
    ln -sf /dev/null /dev/console
fi

# === Ensure /storage exists and is writable ===
mkdir -p /storage/mikopbx/persistence
chown -R www:www /storage/mikopbx
chmod -R 770 /storage/mikopbx

# === Redirect SQLite databases to /storage ===
for dbfile in /offload/rootfs/usr/www/src/Common/Models/*.sqlite3; do
    if [ -f "$dbfile" ]; then
        echo "Moving $dbfile to /storage..."
        mv "$dbfile" /storage/mikopbx/persistence/ || true
    fi
done

# Symlink the databases back to the original path
for dbfile in /storage/mikopbx/persistence/*.sqlite3; do
    ln -sf "$dbfile" "/offload/rootfs/usr/www/src/Common/Models/$(basename $dbfile)"
done

# === Overlay /offload/www to make it writable (optional) ===
mkdir -p /storage/www-overlay /storage/www-work
mount -t overlay overlay \
    -o lowerdir=/offload/rootfs/usr/www,upperdir=/storage/www-overlay,workdir=/storage/www-work \
    /offload/rootfs/usr/www || true

# Log for verification
echo "Mount points and storage permissions:"
mount | grep -E "offload|storage" || true
ls -ld /storage/mikopbx /storage/mikopbx/persistence
ls -l /storage/mikopbx/persistence

# Hand over control to original entrypoint
exec /sbin/docker-entrypoint "$@"
