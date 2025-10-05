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

# === Handle read-only /offload (from image layer) ===
if mount | grep "on /offload " | grep -q "(ro,"; then
    echo "Remounting /offload as read/write..."
    mount -o remount,rw /offload 2>/dev/null || true
fi

# If still not writable, apply overlay for writable layer
if [ ! -w /offload/rootfs/usr/www ]; then
    echo "Applying overlay to /offload/rootfs/usr/www..."
    mkdir -p /storage/www-overlay /storage/www-work
    mount -t overlay overlay \
        -o lowerdir=/offload/rootfs/usr/www,upperdir=/storage/www-overlay,workdir=/storage/www-work \
        /offload/rootfs/usr/www || true
fi

# === Ensure database directory is writable ===
if [ -d /offload/rootfs/usr/www/db ]; then
    chmod -R 777 /offload/rootfs/usr/www/db || true
else
    mkdir -p /offload/rootfs/usr/www/db
    chmod -R 777 /offload/rootfs/usr/www/db
fi

# === Log mount status for verification ===
echo "Current mount points related to /offload or /storage:"
mount | grep -E "offload|storage" || true

# === Hand over to original MikoPBX entrypoint ===
exec /sbin/docker-entrypoint "$@"
