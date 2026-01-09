# Start with Node 18 Debian (has apt-get)
FROM node:18-bullseye

# Install system packages for video scraping/processing
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    ffmpeg \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages for scraping
RUN pip3 install --no-cache-dir \
    yt-dlp \
    instagrapi \
    facebook-sdk \
    requests

# Install n8n globally
RUN npm install -g n8n

# Create app directory
WORKDIR /home/node/app

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
