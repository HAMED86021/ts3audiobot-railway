# TS3AudioBot on Railway

Railway-ready deployment for TS3AudioBot connecting to an existing TeamSpeak 3 server.

## Architecture

`Railway → TS3AudioBot → outbound connection → TeamSpeak 3 VPS`

## Deploy on Railway

1. Create a Railway project from this GitHub repository.
2. Add a **Volume** mounted at `/app/data`.
3. Add the variables below.
4. Keep the service at one replica.
5. Deploy.

### Variables

Required:

- `TS3_SERVER` — TeamSpeak server IP/domain
- `TS3_PORT` — normally `9987`
- `TS3_BOT_NAME` — bot nickname

Optional:

- `TS3_SERVER_PASSWORD`
- `TS3_CHANNEL`
- `TS3_CHANNEL_PASSWORD`
- `TS3_IDENTITY_KEY`
- `TS3_IDENTITY_OFFSET`
- `TS3_IDENTITY_LEVEL`
- `TS3_SEND_STATS=false`
- `TS3_WEB_ENABLED=true`
- `TS3_WEB_PORT` — leave empty to use Railway `PORT`

## TeamSpeak VPS

The TeamSpeak server must be reachable from the public Internet on its configured voice port, normally **UDP 9987**. Open that port in the VPS/cloud firewall. You do not need an inbound UDP port on Railway for the bot connection.

## Persistent storage

Mount a Railway Volume at `/app/data`. This preserves bot state and database data across redeploys.

## Security

Do not commit `.env`, passwords, privilege keys, or identity keys. Store secrets as Railway Variables.

If you expose the TS3AudioBot web/API interface publicly, protect it with authentication and/or a private access layer.

## Notes

The Docker image used here is `igorferreir4/ts3audiobot:stable`. TS3AudioBot is an independent open-source project; see its upstream repository for documentation and licensing.
