# Start from official n8n latest image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install yt-dlp and ffmpeg
RUN apt-get update && apt-get install -y python3-pip ffmpeg && pip3 install yt-dlp

# Switch back to n8n user
USER node
