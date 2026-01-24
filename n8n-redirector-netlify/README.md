# 📂 Project Structure
```n8n-redirector-netlify/          # Root of your Netlify project
│
├── netlify.toml                 # Netlify config (routes, build settings)
├── _redirects                   # Optional static redirects (fallbacks)
├── package.json                 # Dependencies (pg, netlify functions SDK, etc.)
├── functions/                   # Netlify Functions live here
│   ├── register-instance.js     # Function: register new n8n instance
│   └── oauth-router.js          # Function: handle Google OAuth callbacks
│
├── db/                          # Database schema and migrations
│   └── schema.sql               # SQL for creating `instances` table
│
├── src/                         # Optional frontend code (if you want UI)
│   └── index.html               # Landing page (optional)
│
└── README.md                    # Documentation for setup and usage
