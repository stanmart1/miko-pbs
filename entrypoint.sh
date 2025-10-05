#!/bin/sh

# Fix /dev/console
if [ ! -e /dev/console ]; then
    echo "Redirecting missing /dev/console..."
    ln -sf /dev/null /dev/console
fi

# Ensure storage directory exists and is writable
echo "Fixing permissions for /storage..."
mkdir -p /storage
chmod -R 777 /storage

# For some builds, the database might actually be under /offload/rootfs/storage
if [ -d /offload/rootfs/storage ]; then
    echo "Fixing permissions for /offload/rootfs/storage..."
    chmod -R 777 /offload/rootfs/storage
fi

# Continue to default entrypoint
exec /sbin/docker-entrypoint "$@"
