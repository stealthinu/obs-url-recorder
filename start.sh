#!/bin/bash

# XDG_RUNTIME_DIRの作成
mkdir -p ${XDG_RUNTIME_DIR}
chmod 700 ${XDG_RUNTIME_DIR}

# 画面解像度設定（デフォルト：1280x720）
SCREEN_WIDTH=${SCREEN_WIDTH:-1280}
SCREEN_HEIGHT=${SCREEN_HEIGHT:-720}
# フレームレート設定（デフォルト：30fps）
SCREEN_FPS=${SCREEN_FPS:-30}

# 録画フォーマット設定（デフォルト：mp4）
REC_FORMAT=${REC_FORMAT:-mp4}

# 環境変数の設定とバリデーション
OBS_BROWSER_URL=${OBS_BROWSER_URL:-"https://obsproject.com/browser-source"}
OBS_WEBSOCKET_PORT=${OBS_WEBSOCKET_PORT:-"4455"}
OBS_WEBSOCKET_PASSWORD=${OBS_WEBSOCKET_PASSWORD:-"obswebsocket"}

# 設定ファイルの更新
CONFIG_DIR="/home/obsuser/.config/obs-studio"
SCENE_FILE="${CONFIG_DIR}/basic/scenes/Untitled.json"
WEBSOCKET_CONFIG_FILE="${CONFIG_DIR}/plugin_config/obs-websocket/config.json"
# OBS プロファイル設定ファイル（解像度・FPS）
BASIC_INI_FILE="${CONFIG_DIR}/basic/profiles/Untitled/basic.ini"

# 設定ファイルの存在確認
if [ ! -f "${SCENE_FILE}" ]; then
    echo "Error: Scene configuration file not found at ${SCENE_FILE}"
    exit 1
fi

if [ ! -f "${WEBSOCKET_CONFIG_FILE}" ]; then
    echo "Error: WebSocket configuration file not found at ${WEBSOCKET_CONFIG_FILE}"
    exit 1
fi

# プロファイル設定ファイルの存在確認
if [ ! -f "${BASIC_INI_FILE}" ]; then
    echo "Error: Video profile file not found at ${BASIC_INI_FILE}"
    exit 1
fi

# URLの特殊文字をエスケープ
ESCAPED_URL=$(echo "${OBS_BROWSER_URL}" | sed 's/[?&]/\\&/g')

# 設定ファイルの更新
sed -i "s|{OBS_BROWSER_URL}|${ESCAPED_URL}|g" "${SCENE_FILE}"
## --- 動的に解像度・FPSを反映させる --- ##
# Placeholder 置換でシンプルに💡
# {SCREEN_WIDTH} / {SCREEN_HEIGHT} / {SCREEN_FPS} を数値へ展開
# Scene JSON では値を数値で埋め込みたいため、クォートごと置換
sed -i "s|\"{SCREEN_WIDTH}\"|${SCREEN_WIDTH}|g" "${SCENE_FILE}"
sed -i "s|\"{SCREEN_HEIGHT}\"|${SCREEN_HEIGHT}|g" "${SCENE_FILE}"
sed -i "s|\"{SCREEN_FPS}\"|${SCREEN_FPS}|g" "${SCENE_FILE}"

# INI ファイルはそのままプレースホルダー文字列を数値へ
sed -i "s|{SCREEN_WIDTH}|${SCREEN_WIDTH}|g" "${BASIC_INI_FILE}"
sed -i "s|{SCREEN_HEIGHT}|${SCREEN_HEIGHT}|g" "${BASIC_INI_FILE}"
sed -i "s|{SCREEN_FPS}|${SCREEN_FPS}|g" "${BASIC_INI_FILE}"
sed -i "s|{REC_FORMAT}|${REC_FORMAT}|g" "${BASIC_INI_FILE}"
# OBS WebSocket プレースホルダー
sed -i "s|{OBS_WEBSOCKET_PORT}|${OBS_WEBSOCKET_PORT}|g" "${WEBSOCKET_CONFIG_FILE}"
sed -i "s|{OBS_WEBSOCKET_PASSWORD}|${OBS_WEBSOCKET_PASSWORD}|g" "${WEBSOCKET_CONFIG_FILE}"

# DBUS Xvfb
dbus-daemon --session --address=unix:path=/tmp/dbus.sock &
Xvfb :99 -screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x24 &
sleep 1

# ~/.fluxbox ディレクトリ作成
mkdir -p /home/obsuser/.fluxbox

# OBS を自動最大化させるルール書き込み
cat >/home/obsuser/.fluxbox/apps <<'EOF'
[app] (name=obs)
  [Maximized] {yes}
[end]
EOF
chown obsuser:obsuser /home/obsuser/.fluxbox/apps

# Fluxbox
fluxbox &

# VNC Server
x11vnc -display :99 -forever -nopw -shared &

# OBS Studio
obs
