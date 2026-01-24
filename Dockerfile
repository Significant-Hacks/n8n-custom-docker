# Start from official n8n image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install FFmpeg, Python3, pip, and yt-dlp
RUN apk add --no-cache ffmpeg python3 py3-pip \
    && pip3 install --no-cache-dir yt-dlp

# Switch back to node user for n8n runtime
USER node
