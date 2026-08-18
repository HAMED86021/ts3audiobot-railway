#!/bin/sh
set -eu
DATA_DIR="${TS3_DATA_DIR:-/app/data}"
mkdir -p "$DATA_DIR"
CONFIG="$DATA_DIR/ts3audiobot.toml"
cat > "$CONFIG" <<EOF
[bot]
language = "en"
run = true

[bot.connect]
server_password = { pw = "${TS3_SERVER_PASSWORD:-}", hashed = false, autohash = false }
channel_password = { pw = "${TS3_CHANNEL_PASSWORD:-}", hashed = false, autohash = false }
address = "${TS3_SERVER:-}:${TS3_PORT:-9987}"
channel = "${TS3_CHANNEL:-}"
name = "${TS3_BOT_NAME:-Railway Music Bot}"

[bot.connect.identity]
key = "${TS3_IDENTITY_KEY:-}"
offset = ${TS3_IDENTITY_OFFSET:-0}
level = ${TS3_IDENTITY_LEVEL:--1}

[bot.reconnect]
ontimeout = ["1s", "2s", "5s", "10s", "30s", "1m", "5m", "repeat last"]
onerror = ["30s", "repeat last"]
onshutdown = ["5m"]

[configs]
bots_path = "bots"
send_stats = ${TS3_SEND_STATS:-false}

[db]
path = "ts3audiobot.db"

[rights]
path = "rights.toml"

[plugins]
path = "plugins"

[web]
hosts = ["*"]
port = ${TS3_WEB_PORT:-${PORT:-58913}}

[web.api]
enabled = ${TS3_WEB_ENABLED:-true}

[web.interface]
enabled = ${TS3_WEB_ENABLED:-true}
EOF
chmod 600 "$CONFIG" 2>/dev/null || true
cd /app
exec dotnet /app/TS3AudioBot.dll
