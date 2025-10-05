# Use the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Fix for /dev/console issue — redirect to /dev/null if not available
RUN mkdir -p /dev && ln -sf /dev/null /dev/console || true

# Expose Web UI and VoIP ports
EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

# Default entrypoint from base image (do not override)
ENTRYPOINT ["/sbin/docker-entrypoint"]

# Default command
CMD []
