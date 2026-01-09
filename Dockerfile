# Use the absolute latest 2.x version (Debian-based)
FROM n8nio/n8n:2.3.2

USER root

# 1. Debian uses apt-get
# 2. We need python3-pip and ffmpeg
# 3. We use --break-system-packages because modern Debian prevents global pip installs by default
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip ffmpeg && \
    pip3 install --no-cache-dir yt-dlp --break-system-packages && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER node
