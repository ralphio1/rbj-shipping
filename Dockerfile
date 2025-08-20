FROM karrio/server:latest

# Add your custom files
COPY ./karrio_config/ /karrio/config/
COPY ./plugins/ /karrio/plugins/

# Set environment variables if needed
ENV CUSTOM_SETTING=value
