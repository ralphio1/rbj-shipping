FROM karrio/server:latest

# Add your custom dependencies
RUN pip install --no-cache-dir

# Add your custom files
COPY ./karrio_config/ /karrio/config/
COPY ./plugins/ /karrio/plugins/

# Set environment variables if needed
ENV CUSTOM_SETTING=value
