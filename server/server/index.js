const path = require('path');
const express = require('express');
const services = require('./services');
const sqlServices = require('./sqltojson')
const cors = require('cors');
const config = require('./config.json')

const PORT = process.env.PORT || 3001;

const app = express();

app.use(cors());

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

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

app.get("/sqltojs", (req, res) => {
  res.json({query: sqlServices.sqlToJson(req.body)});
});

app.get("/config", (req, res) => {
  res.json(config);
});

// All other GET requests not handled before will return our React app
app.get('*', (req, res) => {
  res.sendFile(path.resolve(__dirname, '../../build', 'index.html'));
});