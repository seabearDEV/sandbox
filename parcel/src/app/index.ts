// Module imports
import process from 'process';
import express from 'express';

// Web server configuration
const app = {
	port: 4241,
	server: express()
};

if (process.env.NODE_ENV === "production"){
	app.server.use(express.static("_dist/prod/webapp"));
}

app.server.get('/sanity-check', (req, res) => {
	res.send(`Your app is running on port ${app.port}`);
});

// Start the web server
app.server.listen(app.port, () => {
	console.log(`Your app is running on port ${app.port}...`);
});