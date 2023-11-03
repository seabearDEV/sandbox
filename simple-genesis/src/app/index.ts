// Module imports
import express from 'express';
import { fileURLToPath } from 'url';
import path, { dirname } from 'path';

// Path configuration
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Web server configuration
const web = {
    port: 4242,
    server: express()
};

// Directory to serve static content from
web.server.use(express.static(path.join(__dirname, '../public')));

// Start the web server
web.server.listen(web.port, () => {
    console.log(`Your website is listening on port ${web.port}...`);
});