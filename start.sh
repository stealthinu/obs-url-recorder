#!/bin/bash

# XDG_RUNTIME_DIRの作成
mkdir -p ${XDG_RUNTIME_DIR}
chmod 700 ${XDG_RUNTIME_DIR}

# 環境変数の設定とバリデーション
OBS_BROWSER_URL=${OBS_BROWSER_URL:-"https://obsproject.com/browser-source"}
OBS_WEBSOCKET_PORT=${OBS_WEBSOCKET_PORT:-"4455"}
OBS_WEBSOCKET_PASSWORD=${OBS_WEBSOCKET_PASSWORD:-"obswebsocket"}

# 設定ファイルの更新
CONFIG_DIR="/home/obsuser/.config/obs-studio"
SCENE_FILE="${CONFIG_DIR}/basic/scenes/Untitled.json"
WEBSOCKET_CONFIG_FILE="${CONFIG_DIR}/plugin_config/obs-websocket/config.json"

# 設定ファイルの存在確認
if [ ! -f "${SCENE_FILE}" ]; then
    echo "Error: Scene configuration file not found at ${SCENE_FILE}"
    exit 1
fi

if [ ! -f "${WEBSOCKET_CONFIG_FILE}" ]; then
    echo "Error: WebSocket configuration file not found at ${WEBSOCKET_CONFIG_FILE}"
    exit 1
fi

# URLの特殊文字をエスケープ
ESCAPED_URL=$(echo "${OBS_BROWSER_URL}" | sed 's/[?&]/\\&/g')

# 設定ファイルの更新
sed -i "s|{OBS_BROWSER_URL}|${ESCAPED_URL}|g" "${SCENE_FILE}"
sed -i "s|{OBS_WEBSOCKET_PORT}|${OBS_WEBSOCKET_PORT}|g" "${WEBSOCKET_CONFIG_FILE}"
sed -i "s|{OBS_WEBSOCKET_PASSWORD}|${OBS_WEBSOCKET_PASSWORD}|g" "${WEBSOCKET_CONFIG_FILE}"

# DBUS Xvfb
dbus-daemon --session --address=unix:path=/tmp/dbus.sock &
Xvfb :99 -screen 0 1280x720x24 &
sleep 1

# Fluxbox
fluxbox &

# VNC Server
x11vnc -display :99 -forever -nopw -shared &

# OBS Studio
obs
