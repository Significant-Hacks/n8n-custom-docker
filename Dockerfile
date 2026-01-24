FROM n8nio/n8n:latest

USER root

# Step 1: Download apk-tools-static
RUN wget https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/apk-tools-static-2.14.6-r3.apk \
    && tar -xvf apk-tools-static-2.14.6-r3.apk

# Step 2: Use apk.static to install python3, pip, ffmpeg
RUN ./sbin/apk.static --repository https://dl-cdn.alpinelinux.org/alpine/v3.21/main/ \
    --allow-untrusted add python3 py3-pip ffmpeg

# Step 3: Create Python virtual environment
RUN python3 -m venv /home/node/venv \
    && . /home/node/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install yt-dlp

# Step 4: Fix permissions for node user
RUN chown -R node:node /home/node/venv

USER node

# Restore the original entrypoint with Tini
ENTRYPOINT ["/tini", "--"]
CMD ["n8n"]
