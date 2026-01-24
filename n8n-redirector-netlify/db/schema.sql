CREATE TABLE IF NOT EXISTS instances (
  token TEXT PRIMARY KEY,
  domain TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
