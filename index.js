const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 25570;

app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/message', (req, res) => {
  res.status(200).json({ message: 'Hello, CI/CD!' });
});

let server;

if (require.main === module) {
  server = app.listen(port, () => {
    console.log(`App running on http://localhost:${port}`);
  });
}

module.exports = { app, server };
