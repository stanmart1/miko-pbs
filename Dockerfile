FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Create a dummy /dev/console to prevent startup spam
RUN mkdir -p /dev && mknod -m 600 /dev/console c 1 3 || true

# Start the PBX, silencing the console-open errors
CMD /sbin/docker-entrypoint 2>&1 | grep -v "can't open /dev/console"
