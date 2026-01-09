# Start from official n8n latest image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install curl and update system
RUN curl -fsSL https://deb.debian.org/debian/pool/main/util-linux/util-linux_2.38. 1-5+deb12u1_amd64.deb -o /tmp/util. deb || true

# Install python3, pip, and ffmpeg
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    ffmpeg && \
    pip3 install --no-cache-dir yt-dlp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to n8n user
USER node
