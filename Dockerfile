FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Fix /dev/console issue
RUN mkdir -p /dev && ln -sf /dev/null /dev/console || true

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD []
