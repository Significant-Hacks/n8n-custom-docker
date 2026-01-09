# Start from official n8n latest image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install python3, pip, and ffmpeg using apt (not apk)
RUN apt-get update && \
    apt-get install -y python3 python3-pip ffmpeg && \
    pip3 install --no-cache-dir yt-dlp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to n8n user
USER node
