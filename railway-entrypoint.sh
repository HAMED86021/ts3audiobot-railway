#!/bin/sh
set -eu

DATA_DIR="${TS3_DATA_DIR:-/app/data}"
CONFIG="$DATA_DIR/ts3audiobot.toml"

mkdir -p "$DATA_DIR"

# Escape a value for a TOML basic string.
toml_escape() {
    printf '%s' "${1:-}" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

SERVER="$(toml_escape "${TS3_SERVER:-}")"
PORT="${TS3_PORT:-9987}"
BOT_NAME="$(toml_escape "${TS3_BOT_NAME:-Railway Music Bot}")"
SERVER_PASSWORD="$(toml_escape "${TS3_SERVER_PASSWORD:-}")"
CHANNEL="$(toml_escape "${TS3_CHANNEL:-}")"
CHANNEL_PASSWORD="$(toml_escape "${TS3_CHANNEL_PASSWORD:-}")"
IDENTITY_KEY="$(toml_escape "${TS3_IDENTITY_KEY:-}")"
IDENTITY_OFFSET="${TS3_IDENTITY_OFFSET:-0}"
IDENTITY_LEVEL="${TS3_IDENTITY_LEVEL:--1}"
SEND_STATS="${TS3_SEND_STATS:-false}"
WEB_ENABLED="${TS3_WEB_ENABLED:-true}"

if [ -n "${TS3_WEB_PORT:-}" ]; then
    WEB_PORT="$TS3_WEB_PORT"
elif [ -n "${PORT:-}" ]; then
    WEB_PORT="$PORT"
else
    WEB_PORT="58913"
fi

cat > "$CONFIG" <<EOF
# Generated at container start from Railway environment variables.
# Runtime state is kept in this directory on the Railway Volume.

[bot]
bot_group_id = 0
generate_status_avatar = true
set_status_description = true
language = "en"
run = true

[bot.commands]
matcher = "ic3"
long_message = "Split"
long_message_split_limit = 1
color = true
command_complexity = 64

[bot.connect]
server_password = { pw = "$SERVER_PASSWORD", hashed = false, autohash = false }
channel_password = { pw = "$CHANNEL_PASSWORD", hashed = false, autohash = false }
client_version = { build = "", platform = "", sign = "" }
address = "$SERVER:$PORT"
channel = "$CHANNEL"
badges = ""
name = "$BOT_NAME"

[bot.connect.identity]
key = "$IDENTITY_KEY"
offset = $IDENTITY_OFFSET
level = $IDENTITY_LEVEL

[bot.reconnect]
ontimeout = ["1s", "2s", "5s", "10s", "30s", "1m", "5m", "repeat last"]
onkick = []
onban = []
onerror = ["30s", "repeat last"]
onshutdown = ["5m"]

[bot.audio]
volume = { default = 50.0, min = 25.0, max = 75.0 }
max_user_volume = 100.0
bitrate = 48
send_mode = "voice"

[bot.playlists]

[bot.history]
enabled = true
fill_deleted_ids = true

[bot.events]
onconnect = ""
ondisconnect = ""
onidle = ""
idletime = "0s"
onalone = ""
alone_delay = "0s"
onparty = ""
party_delay = "0s"
onsongstart = ""

[configs]
bots_path = "bots"
send_stats = $SEND_STATS

[db]
path = "ts3audiobot.db"

[factories]
media = { path = "" }

[factories.youtube]
prefer_resolver = "YoutubeDl"
youtube_api_key = ""

[tools]
youtube-dl = { path = "/usr/local/bin/youtube-dl" }

[tools.ffmpeg]
path = "ffmpeg"

[rights]
path = "rights.toml"

[plugins]
path = "plugins"

[plugins.load]

[web]
hosts = ["*"]
port = $WEB_PORT

[web.api]
enabled = $WEB_ENABLED
command_complexity = 64
matcher = "exact"

[web.interface]
enabled = $WEB_ENABLED
path = ""
EOF

chmod 600 "$CONFIG" 2>/dev/null || true

# Generate rights.toml if missing — prevents interactive console prompt crash on Railway.
RIGHTS_FILE="$DATA_DIR/rights.toml"
if [ ! -f "$RIGHTS_FILE" ]; then
    cat > "$RIGHTS_FILE" <<'RIGHTS'
[*]
"+" = ["*"]
RIGHTS
    chmod 600 "$RIGHTS_FILE" 2>/dev/null || true
fi

cd "$DATA_DIR"

printf '%s\n' "=============================================="
printf '%s\n' " TS3AudioBot - Railway"
printf '%s\n' " Server : ${TS3_SERVER:-<not set>}:$PORT"
printf '%s\n' " Bot    : ${TS3_BOT_NAME:-Railway Music Bot}"
printf '%s\n' " Web    : $WEB_PORT"
printf '%s\n' " Data   : $DATA_DIR"
printf '%s\n' "=============================================="

exec dotnet /app/TS3AudioBot.dll
