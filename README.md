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

## 📂 Repository Structure
```n8n-custom-docker/
├── Dockerfile                  # Custom image definition (n8n + yt-dlp + ffmpeg)
├── digest.txt                   # Stores last known n8n Docker digest
└── .github/
└── workflows/
└── check-n8n-update.yml  # GitHub Action to auto-check for new n8n releases

