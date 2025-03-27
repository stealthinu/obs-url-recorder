#!/bin/bash

# XDG_RUNTIME_DIRの作成
mkdir -p ${XDG_RUNTIME_DIR}
chmod 700 ${XDG_RUNTIME_DIR}

# URLの設定を環境変数から取得してJSONを更新
OBS_URL=${OBS_BROWSER_URL:-"https://www.youtube.com/shorts/9KaytlBoqM4"}
sed -i "s|\"url\": \".*\"|\"url\": \"$OBS_URL\"|" /home/obsuser/.config/obs-studio/basic/scenes/Untitled.json

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
