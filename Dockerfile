FROM n8nio/n8n:latest-debian

USER root

RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir yt-dlp

USER node
