const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.status(200).json({ message: 'Hello, CI/CD!' });
});

let server;

if (require.main === module) {
  server = app.listen(port, () => {
    console.log(`App running on http://localhost:${port}`);
  });
}

module.exports = { app, server };
