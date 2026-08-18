# TS3AudioBot stable 0.12.2 community Docker image.
# The upstream project documents Docker as a community-maintained build.
FROM igorferreir4/ts3audiobot:stable@sha256:ee8e66a61ea1e901d6d00bebbdbb05288c47fc481d1ac18d5aff078ad1bdf4ed

USER root

COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh

RUN chmod +x /usr/local/bin/railway-entrypoint.sh \
    && mkdir -p /app/data

ENV TS3_DATA_DIR=/app/data

WORKDIR /app/data

ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
