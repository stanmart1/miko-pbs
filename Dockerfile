# Start from the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Option A: Patch their entrypoint so logs go to stdout (clean)
RUN sed -i 's#/dev/console#/proc/1/fd/1#g' /sbin/docker-entrypoint

# Option B: Completely bypass their entrypoint and run PBX manually
# (uncomment this CMD if Option A doesn’t fix it)
# CMD ["/bin/sh", "-c", "/etc/init.d/mikopbx start && tail -f /dev/null"]
