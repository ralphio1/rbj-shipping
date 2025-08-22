FROM karrio/server:2024.12.6

# Add your custom files
COPY ./karrio_config/ /karrio/config/
COPY ./plugins/ /karrio/plugins/
