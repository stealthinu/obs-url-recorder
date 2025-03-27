FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    DISPLAY=:99 \
    PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    HOME=/home/obsuser \
    XDG_RUNTIME_DIR=/home/obsuser/xdg

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    dbus-x11 \
    fonts-noto-cjk \
    software-properties-common \
    ffmpeg \
    && add-apt-repository ppa:obsproject/obs-studio \
    && apt-get update \
    && apt-get install -y obs-studio \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/obsuser obsuser \
    && chown -R obsuser:obsuser /home/obsuser

# OBS
COPY obs-studio /home/obsuser/.config/obs-studio
RUN chown -R obsuser:obsuser /home/obsuser/.config

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER obsuser
CMD ["/start.sh"]
