# Start from the official optimized n8n image
FROM n8nio/n8n:latest

# Switch to root to install system-level packages
USER root

# Install python3, pip, and ffmpeg using Alpine's manager (apk)
RUN apk add --no-cache python3 py3-pip ffmpeg && \
    pip3 install --no-cache-dir yt-dlp

# Switch back to the 'node' user for security
USER node
