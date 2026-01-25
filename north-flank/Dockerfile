FROM n8nio/n8n:latest

USER root

# Step 1: Download apk-tools-static
RUN wget https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/apk-tools-static-2.14.6-r3.apk \
    && tar -xvf apk-tools-static-2.14.6-r3.apk

# Step 2: Use apk.static to install python3, pip, ffmpeg, bash, util-linux (for uuidgen)
RUN ./sbin/apk.static --repository https://dl-cdn.alpinelinux.org/alpine/v3.21/main/ \
    --allow-untrusted add python3 py3-pip ffmpeg bash util-linux

# Step 3: Create Python virtual environment and install yt-dlp
RUN python3 -m venv /home/node/venv \
    && . /home/node/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install yt-dlp

# Step 4: Fix permissions for node user
RUN chown -R node:node /home/node/venv

# Step 5: Create entrypoint script that generates instID and sets WEBHOOK_URL globally
RUN printf '#!/bin/sh\n\
set -e\n\
if [ -z "$instID" ]; then\n\
  instID=$(uuidgen)\n\
fi\n\
WEBHOOK_URL="https://wonderful-froyo-fd4695.netlify.app/${instID}/"\n\
# Write to /etc/environment so it is global\n\
echo "instID=$instID" >> /etc/environment\n\
echo "WEBHOOK_URL=$WEBHOOK_URL" >> /etc/environment\n\
export instID WEBHOOK_URL\n\
echo "Container started with instID=$instID and WEBHOOK_URL=$WEBHOOK_URL"\n\
exec tini -s -- "$@"\n' \
    > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /home/node
USER node

# Runner configuration
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=external
ENV N8N_RUNNERS_AUTH_TOKEN=changeme
ENV N8N_RUNNERS=${NF_HOSTS}
ENV TINI_SUBREAPER=1

EXPOSE 5678

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["n8n"]
