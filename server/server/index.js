const path = require('path');
const express = require('express');
const services = require('./services');


const PORT = process.env.PORT || 3001;

const app = express();

app.use(express.json());

app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});

// Have Node serve the files for our built React app
app.use(express.static(path.resolve(__dirname, '../../build')));

// Handle GET requests to /api route
app.post("/api", (req, res) => {
  res.json({query: services.ruleQuery(req.body)});
});

// All other GET requests not handled before will return our React app
app.get('*', (req, res) => {
  res.sendFile(path.resolve(__dirname, '../../build', 'index.html'));
});