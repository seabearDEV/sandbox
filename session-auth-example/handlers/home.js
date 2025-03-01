export default function HomeHandler(req, res) {
  if (!req.session.userid) {
    res.redirect("/login");
  }

  res.setHeader('Content-Type', 'text/html');
  res.write(`
  <h1>Welcome back ${req.session.userid}</h1>
  <a href="/logout">Logout</a>
`)

  res.end();
};