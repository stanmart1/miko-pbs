#!/bin/sh
# Ensure /dev/console exists to prevent spam errors
if [ ! -e /dev/console ]; then
    echo "Redirecting missing /dev/console..."
    ln -sf /dev/null /dev/console
fi

# Hand over control to the original entrypoint
exec /sbin/docker-entrypoint "$@"
