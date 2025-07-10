// Simple Notepad backend using Node.js and Express
const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const PORT = 3000;

// Serve static files (HTML, CSS, JS) from Apache's public directory
// If running behind Apache, set up a reverse proxy or serve from /var/www/html
app.use(express.static(path.join(__dirname, 'public')));

app.use(express.json());

// Save notepad content to a file
app.post('/save', (req, res) => {
  const { content } = req.body;
  fs.writeFile('notepad.txt', content, (err) => {
    if (err) return res.status(500).send('Error saving file');
    res.send('File saved');
  });
});

// Load notepad content from a file
app.get('/load', (req, res) => {
  fs.readFile('notepad.txt', 'utf8', (err, data) => {
    if (err) return res.json({ content: '' });
    res.json({ content: data });
  });
});

app.listen(PORT, () => {
  console.log(`Notepad app listening on port ${PORT}`);
});
