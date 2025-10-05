#!/bin/sh

# Fix /dev/console
if [ ! -e /dev/console ]; then
    echo "Redirecting missing /dev/console..."
    ln -sf /dev/null /dev/console
fi

# Ensure storage directory exists and is writable
echo "Fixing permissions for /storage..."
mkdir -p /storage
chmod -R 777 /storage || true

# Fix permission for overlay rootfs
if [ -d /offload/rootfs/storage ]; then
    echo "Fixing permissions for /offload/rootfs/storage..."
    chmod -R 777 /offload/rootfs/storage || true
fi

# Fix permission for the runtime web directory
if [ -d /offload/rootfs/usr/www ]; then
    echo "Fixing permissions for /offload/rootfs/usr/www..."
    chmod -R 777 /offload/rootfs/usr/www || true
fi

# Continue to default entrypoint
exec /sbin/docker-entrypoint "$@"
