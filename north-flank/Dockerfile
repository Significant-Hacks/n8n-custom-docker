FROM n8nio/n8n:latest

USER root

# Step 1: Download apk-tools-static
RUN wget https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/apk-tools-static-2.14.6-r3.apk \
    && tar -xvf apk-tools-static-2.14.6-r3.apk

# Step 2: Use apk.static to install python3, pip, ffmpeg
RUN ./sbin/apk.static --repository https://dl-cdn.alpinelinux.org/alpine/v3.21/main/ \
    --allow-untrusted add python3 py3-pip ffmpeg

# Step 3: Create Python virtual environment and install yt-dlp
RUN python3 -m venv /home/node/venv \
    && . /home/node/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install yt-dlp

# Step 4: Fix permissions for node user
RUN chown -R node:node /home/node/venv

WORKDIR /home/node
USER node

# Runner configuration (manual for VPS)
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=external
ENV N8N_RUNNERS_AUTH_TOKEN=changeme

# Build-time instance ID
ARG instID=defaultid
# Generate a random instID during build
RUN instID=$(cat /proc/sys/kernel/random/uuid) && \
    echo "ENV instID=$instID" >> /home/node/.inst-env
ENV instID=${instID}
ENV WEBHOOK_URL=https://wonderful-froyo-fd4695.netlify.app/${instID}/

# User must override N8N_RUNNERS at runtime
ENV N8N_RUNNERS=https://example.com

# Fix tini warning
ENV TINI_SUBREAPER=1

EXPOSE 5678

ENTRYPOINT ["/tini","-s","--"]
CMD ["n8n"]
