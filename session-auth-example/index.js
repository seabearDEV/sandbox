import express from 'express';
import sessions from "express-session";

import LoginHandler from './handlers/login.js';
import ProcessLogin from './handlers/process-login.js';
import HomeHandler from './handlers/home.js';
import Logout from './handlers/logout.js';

const app = express();

app.use(
  sessions({
    secret: "some secret",
    cookie: {
      maxAge: 1000 * 60 * 60 * 24, //24 hours
    },
    resave: true,
    saveUninitialized: false,
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/login', LoginHandler);
app.get('/', HomeHandler);
app.post('/process-login', ProcessLogin);
app.get('/logout', Logout);


app.listen(3000, () => {
  console.log(`Server is running on port 3000`);
});