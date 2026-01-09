# Start with official n8n (even though it's minimal)
FROM n8nio/n8n:latest

# Now install curl & wget first (they might exist)
USER root

# Try to install packages using npm instead of apt
RUN npm install -g python3 ffmpeg yt-dlp 2>/dev/null || echo "npm install failed, trying alternative"

# Install Python and ffmpeg using Node if apt doesn't work
RUN which python3 || (apt-get update && apt-get install -y python3 python3-pip ffmpeg) || echo "apt failed"

USER node
