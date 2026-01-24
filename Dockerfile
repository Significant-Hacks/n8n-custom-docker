FROM n8nio/n8n:latest

USER root

# Update package list and install ffmpeg + python3 + pip
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Install yt-dlp via pip
RUN pip3 install --no-cache-dir yt-dlp

USER node
