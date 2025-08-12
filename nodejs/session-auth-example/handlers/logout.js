export default function Logout(req, res) {
  req.session.destroy();
  res.redirect('/login');
}