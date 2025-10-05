# Use the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Patch /dev/console issue before startup
RUN mkdir -p /dev && ln -sf /dev/null /dev/console || true

# Expose Web UI and VoIP ports
EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

# Custom entrypoint wrapper to fix /dev/console first
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD []
