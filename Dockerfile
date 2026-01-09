# Start from official n8n latest image
FROM n8nio/n8n:latest-alpine

# Switch to root to install packages
USER root

# Install python3, pip, and ffmpeg on Alpine
RUN apk add --no-cache python3 py3-pip ffmpeg \ && pip3 install --no-cache-dir yt-dlp


# Switch back to n8n user
USER node
