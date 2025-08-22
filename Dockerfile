FROM karrio/server:2024.12.10

# Add your custom files
COPY ./karrio_config/ /karrio/config/
COPY ./plugins/ /karrio/plugins/
