FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Create a dummy console device so entrypoint logging works
RUN mkdir -p /dev && mknod -m 600 /dev/console c 1 3 || true

# Some shells abort on console errors; redirect them instead
ENV CONSOLE_DEVICE=/dev/console

EXPOSE 80

# Run the image's native entrypoint
ENTRYPOINT ["/sbin/docker-entrypoint"]
CMD []
