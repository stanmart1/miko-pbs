# Base image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Create dummy /dev/console to silence entrypoint spam
RUN mkdir -p /dev && \
    ( [ -e /dev/console ] || mknod -m 600 /dev/console c 1 3 ) && \
    ln -sf /dev/null /dev/console

# Redirect entrypoint logs properly so it doesn't try to open console
ENTRYPOINT ["/bin/sh", "-c", "exec /sbin/docker-entrypoint >/proc/1/fd/1 2>/proc/1/fd/2"]

# MikoPBX runs its web UI on port 80
EXPOSE 80
