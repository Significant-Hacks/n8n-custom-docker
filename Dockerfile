# Start from official n8n latest image
FROM n8nio/n8n:1.64.0-debian-debian

# Switch to root to install packages
USER root

# Install python3, pip, and ffmpeg on Alpine
RUN apt-get update && apt-get install -y python3-pip ffmpeg \ && pip3 install --no-cache-dir yt-dlp


# Switch back to n8n user
USER node
