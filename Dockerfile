FROM karrio/server:latest

# Add your custom files
COPY ./karrio_config/ /karrio/config/
COPY ./plugins/ /karrio/plugins/
