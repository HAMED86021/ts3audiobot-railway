FROM igorferreir4/ts3audiobot:stable
USER root
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh && mkdir -p /app/data
ENV TS3_DATA_DIR=/app/data
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
