# Use the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Fix /dev/console issue
RUN mkdir -p /dev && ln -sf /dev/null /dev/console || true

# Copy custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Ensure storage directory exists and is writable
RUN mkdir -p /storage && chmod -R 777 /storage || true

EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD []
