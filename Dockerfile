# Start from official n8n latest image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# First, let's see what's available
RUN which apt-get || which apk || which yum || echo "No package manager found"

# Install python3, pip, and ffmpeg
RUN apt-get update && \
    apt-get install -y python3 python3-pip ffmpeg && \
    pip3 install --no-cache-dir yt-dlp

# Switch back to n8n user
USER node
