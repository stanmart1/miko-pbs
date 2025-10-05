# Use the official MikoPBX image
FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Install tini (a minimal init system that handles PID 1 correctly)
RUN apt-get update && apt-get install -y tini && apt-get clean

# Prevent console spam by redirecting /dev/console
RUN mkdir -p /dev && ln -sf /dev/null /dev/console

# Expose web and SIP/VoIP ports
EXPOSE 80 443 5060/udp 5061/tcp 4569/udp 18000-18100/udp

# Use tini to manage processes safely
ENTRYPOINT ["/usr/bin/tini", "--", "/sbin/docker-entrypoint"]

# Default command
CMD []
