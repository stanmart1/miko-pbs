FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# --- Fix /dev/console issue safely ---
# Create a fake console so the entrypoint stops throwing errors
RUN mkdir -p /dev && \
    if [ ! -e /dev/console ]; then mknod -m 600 /dev/console c 1 3 || true; fi

# --- Ensure container starts normally ---
# Run entrypoint through sh and redirect console logs properly
ENTRYPOINT ["/bin/sh", "-c", "exec /sbin/docker-entrypoint >/proc/1/fd/1 2>/proc/1/fd/2"]
