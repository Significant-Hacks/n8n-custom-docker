# n8n Custom Docker Image + externals (e.g. yt-dlp & ffmpeg)

This repository provides a custom Docker image for [n8n](https://n8n.io), extended with additional libraries to support media processing and command-line automation.

---

## 📦 Included Components

### n8n
- **Purpose**: Workflow automation platform.
- **Capabilities**: Connects APIs, databases, and services; supports triggers, data transformation, and integrations.
- **Usage**: Runs as the base application inside this Docker image.

### yt-dlp
- **Purpose**: Command-line program for downloading videos and extracting metadata from many websites.
- **Capabilities**:
  - Retrieve video URLs.
  - Extract metadata such as title, description, duration, upload date, and statistics (when available).
  - Output structured JSON for easy parsing.
- **Integration with n8n**:
  - Use the **Execute Command node** to run `yt-dlp` commands.
  - Pipe JSON output into a **Function node** for parsing and transformation.
  - Store results in databases or forward to other services.

### ffmpeg
- **Purpose**: Multimedia framework for handling video and audio.
- **Capabilities**:
  - Convert between formats.
  - Extract audio from video.
  - Resize, trim, or transcode media files.
- **Integration with n8n**:
  - Use the **Execute Command node** to run `ffmpeg` commands.
  - Combine with n8n’s file storage or cloud integrations to process and deliver media.

---

## ⚙️ General Workflow Integration

1. **Execute Command Node**  
   - Run shell commands inside n8n workflows.  
   - Example:  
     ```bash
     yt-dlp -j "https://example.com/video"
     ```

2. **Function Node**  
   - Parse JSON output from yt-dlp.  
   - Transform metadata into structured items for downstream nodes.

3. **Database / API Nodes**  
   - Store metadata in MongoDB, PostgreSQL, or MySQL.  
   - Send processed data to external APIs or services.

4. **File Handling**  
   - Use ffmpeg to process downloaded media.  
   - Upload results to cloud storage or deliver via integrations.

---

## 🔄 Automatic Updates

- A GitHub Action checks daily for new upstream `n8nio/n8n:latest` releases.
- If a new digest is detected, it updates `digest.txt` and commits the change.
- This triggers a rebuild on hosting platforms (e.g., Render), ensuring the image stays current.

---

## 📖 Example Use Cases (General)

- Automating video metadata extraction for analytics.  
- Converting downloaded media into different formats.  
- Building workflows that combine API calls with media processing.  
- Creating pipelines that enrich, store, and forward structured data.

---

## 🛠 Notes

- This image is designed for **general automation** and media handling.  
- Only public content is accessible without authentication; private or restricted sources may require cookies or login.  
- Hosting environments with ephemeral storage should use external storage for persistence.  
- Keep yt-dlp and ffmpeg updated to ensure compatibility with supported sites and formats.

---


## How I managed to install python/pip & other PKGs
---

### Step 1: Tried installing Python via npm (failed)
```sh
npm install python
python --version
# Result: ash: python: not found
```

---

### Step 2: Tried using apk directly (failed)
```sh
apk add --no-cache python3 py3-pip
# Result: ash: apk: not found
```

---

### Step 3: Checked available tools
```sh
tar --version
# tar (busybox) 1.37.0
```

---

### Step 4: Tried old apk-tools-static link (failed)
```sh
wget http://dl-cdn.alpinelinux.org/alpine/v3.5/main/x86_64/apk-tools-static-2.6.8-r1.apk
# Result: HTTP/1.1 404 Not Found
```

---

### Step 5: Downloaded latest apk-tools-static (success)
```sh
wget https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/apk-tools-static-2.14.6-r3.apk
```

---

### Step 6: Unpacked the apk-tools-static package
```sh
tar -xvf apk-tools-static-2.14.6-r3.apk
# Creates sbin/apk.static
```

---

### Step 7: Installed Python3, pip, and ffmpeg using apk.static
```sh
./sbin/apk.static --repository https://dl-cdn.alpinelinux.org/alpine/v3.21/main/ --allow-untrusted add python3 py3-pip ffmpeg
```

---

### Step 8: Verified installations
```sh
python3 --version
# Python 3.12.12

pip3 --version
# pip 25.1.1

ffmpeg -version
# ffmpeg 6.1.2
```

---

### Step 9: Tried pip install yt-dlp (failed due to PEP 668 restriction)
```sh
pip3 install yt-dlp
# error: externally-managed-environment
```

---

### Step 10: Created a Python virtual environment (venv)
```sh
python3 -m venv /home/node/venv
. /home/node/venv/bin/activate
```

---

### Step 11: Installed yt-dlp inside venv (success)
```sh
pip install yt-dlp
yt-dlp --version
# yt-dlp 2025.12.8
```

---

### Step 12: Confirmed pip works inside venv
```sh
pip install --upgrade pip
# Pip upgraded successfully inside venv
```

---

✅ At this point, Python, pip, ffmpeg, and yt-dlp are all installed and usable inside the container. With this insight, i recoded the whole process to the dcoker file so that everythiing be handled from the image building. And with trial and error it worked fine. I itested this on [NORTHFLANK VPS](https://app.northflank.com/) provider on freetier.

👉 Use `/home/node/venv/bin/yt-dlp` and `ffmpeg` in n8n Execute Command nodes to integrate them into workflows.

---


## 📂 Repository Structure
```n8n-custom-docker/
├── Dockerfile                  # Custom image definition (n8n + yt-dlp + ffmpeg)
├── digest.txt                   # Stores last known n8n Docker digest
└── .github/
└── workflows/
└── check-n8n-update.yml  # GitHub Action to auto-check for new n8n releases

