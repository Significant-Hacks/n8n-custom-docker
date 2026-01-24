import { Client } from 'pg';

export async function handler(event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method not allowed' };
  }

  const { token, domain } = JSON.parse(event.body);

  const client = new Client({
    connectionString: process.env.NETLIFY_DATABASE_URL, // Neon DB URL injected by Netlify
    ssl: { rejectUnauthorized: false }
  });
  await client.connect();

  await client.query(
    'INSERT INTO instances (token, domain) VALUES ($1, $2) ON CONFLICT (token) DO UPDATE SET domain=$2',
    [token, domain]
  );

  await client.end();

  return { statusCode: 200, body: 'Instance registered' };
}
