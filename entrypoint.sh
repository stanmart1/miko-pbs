#!/bin/sh
# Ensure /dev/console exists to prevent spam errors
if [ ! -e /dev/console ]; then
    echo "Redirecting missing /dev/console..."
    ln -sf /dev/null /dev/console
fi

# Ensure /storage exists and is writable
if [ ! -d /storage ]; then
    mkdir -p /storage
fi

echo "Fixing permissions for /storage..."
chmod -R 777 /storage || true

# Hand over control to the original entrypoint
exec /sbin/docker-entrypoint "$@"
