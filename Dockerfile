# Use the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Fix for missing /dev/console issue
RUN mkdir -p /dev && ln -sf /dev/null /dev/console || true

# Copy custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose necessary ports
EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

# Use our entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD []
