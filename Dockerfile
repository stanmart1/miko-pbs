# Use the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Fix /dev/console issue safely
RUN mkdir -p /dev && ln -sf /dev/null /dev/console || true

# Ensure /storage exists and has proper permissions
RUN mkdir -p /storage && \
    chown -R 1000:1000 /storage && \
    chmod -R 777 /storage

# Expose Web UI and VoIP ports
EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

# Add a custom entrypoint wrapper
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run your wrapper first
ENTRYPOINT ["/entrypoint.sh"]

CMD []
