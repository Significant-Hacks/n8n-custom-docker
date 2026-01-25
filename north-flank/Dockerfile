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

# Step 5: Create entrypoint script with conditional instID assignment
RUN printf '#!/bin/sh\n\
set -e\n\
# If WEBHOOK_URL contains ${instID}, generate a UUID\n\
if echo "$WEBHOOK_URL" | grep -q "\\${instID}"; then\n\
  instID=$(uuidgen)\n\
  WEBHOOK_URL=$(echo "$WEBHOOK_URL" | sed "s/\\${instID}/$instID/")\n\
else\n\
  # Otherwise, extract the last path segment as instID\n\
  instID=$(basename "$WEBHOOK_URL")\n\
fi\n\
export instID WEBHOOK_URL\n\
# Write to a file so SSH shells can source it\n\
echo "export instID=$instID" > /home/node/env-vars.sh\n\
echo "export WEBHOOK_URL=$WEBHOOK_URL" >> /home/node/env-vars.sh\n\
echo "Container started with instID=$instID"\n\
echo "WEBHOOK_URL=$WEBHOOK_URL"\n\
exec tini -s -- "$@"\n' \
    > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /home/node
USER node

# Runner configuration (Northflank injects NF_HOSTS)
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=external
ENV N8N_RUNNERS_AUTH_TOKEN=changeme
ENV N8N_RUNNERS=${NF_HOSTS}
ENV TINI_SUBREAPER=1

# Default WEBHOOK_URL template (uses ${instID} by default)
ENV WEBHOOK_URL=https://wonderful-froyo-fd4695.netlify.app/${instID}/

# Ensure env-vars.sh is sourced for interactive shells
RUN echo ". /home/node/env-vars.sh" >> /home/node/.profile

EXPOSE 5678

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["n8n"]
