FROM karrio/server:latest

# Copy startup script
COPY ./startup.sh /karrio/startup.sh
RUN chmod +x /karrio/startup.sh

# Add your custom files
COPY ./karrio_config/ /karrio/config/
COPY ./plugins/ /karrio/plugins/

# Set environment variables if needed
ENV CUSTOM_SETTING=value

# Use our custom startup script
ENTRYPOINT ["/karrio/startup.sh"]
CMD ["./entrypoint"]
