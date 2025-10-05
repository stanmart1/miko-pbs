FROM ghcr.io/mikopbx/mikopbx-x86-64:latest

# Fix /dev/console error (safe workaround)
RUN ln -sf /dev/null /dev/console

# Default port for MikoPBX web UI
EXPOSE 80

# Keep the original entrypoint from the base image
CMD ["/entrypoint.sh"]
