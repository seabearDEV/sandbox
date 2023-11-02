// Module imports
import express from 'express';

// Web server configuration
const web = {
    port: 4242,
    server: express()
};

// Directory to serve static content from
web.server.use(express.static("./dist/public"));

web.server.get("/html/header", (req, res) => {
    console.log(req);
    res.send(
        `
        <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Node.js Static Website</title>
    <link rel="stylesheet" href="css/style.css">
</head>
        `
    );
});

// Start the web server
web.server.listen(web.port, () => {
    console.log(`Your website is listening on port ${web.port}...`);
});