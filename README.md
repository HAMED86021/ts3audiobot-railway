# TS3AudioBot on Railway

Railway-ready deployment for TS3AudioBot connecting to an existing TeamSpeak 3 server.

## Architecture

`Railway → TS3AudioBot → outbound connection → TeamSpeak 3 VPS`

TS3AudioBot is a headless TeamSpeak 3 client/music bot. The TeamSpeak voice connection is initiated from Railway; Railway does not need an inbound UDP voice listener for this architecture.

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
- `TS3_IDENTITY_KEY` — keep this secret
- `TS3_IDENTITY_OFFSET`
- `TS3_IDENTITY_LEVEL`
- `TS3_SEND_STATS=false`
- `TS3_WEB_ENABLED=true`
- `TS3_WEB_PORT` — leave empty to use Railway's `PORT`

See `.env.example` for all variables.

## TeamSpeak VPS

The TeamSpeak server must be reachable from the public Internet on its configured voice port, normally **UDP 9987**. Open that port in the VPS/cloud firewall. You do not need to expose UDP 9987 on Railway for this bot connection.

## Persistent storage

Mount a Railway Volume at `/app/data`. The bot database, rights, bot configuration and other runtime state use this directory.

## Security

Do not commit `.env`, passwords, privilege keys, or identity keys. Store secrets as Railway Variables.

If you expose the TS3AudioBot web/API interface publicly, use its API authentication and preferably put HTTPS/private access in front of it. The upstream documentation explicitly recommends protecting the API rather than exposing it directly. 

## Version / image

The Dockerfile pins the multi-platform community image `igorferreir4/ts3audiobot:stable` by digest. The image's current `stable` tag is TS3AudioBot **0.12.2**. The upstream project currently lists **0.12.0** as its latest official stable release; the Docker image is a community-maintained distribution.

The image already contains the required .NET runtime, FFmpeg and youtube-dl setup, so this repository does not install those dependencies again.

## First boot

The entrypoint generates `ts3audiobot.toml` from Railway variables before starting the bot. Relative TS3AudioBot paths are resolved from `/app/data`, matching the upstream/community Docker image layout.

After the bot connects, use the TeamSpeak chat command `!help`. For administrative permissions, follow the upstream setup flow and use a TeamSpeak privilege key with `!bot setup <privilege-key>`.

## Upstream

TS3AudioBot: https://github.com/Splamy/TS3AudioBot
