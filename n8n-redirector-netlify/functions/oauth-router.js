import { Client } from 'pg';

export async function handler(event) {
  const pathParts = event.path.split('/');
  const token = pathParts[1]; // e.g. /<token>/rest/oauth2-credential/callback

  const client = new Client({
    connectionString: process.env.NETLIFY_DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  });
  await client.connect();

  const res = await client.query('SELECT domain FROM instances WHERE token=$1', [token]);
  await client.end();

  if (res.rows.length === 0) {
    return { statusCode: 404, body: 'Instance not found' };
  }

  const domain = res.rows[0].domain;
  const forwardPath = pathParts.slice(2).join('/'); // rest/oauth2-credential/callback
  const redirectUrl = `https://${domain}/${forwardPath}`;

  return {
    statusCode: 302,
    headers: { Location: redirectUrl }
  };
}
