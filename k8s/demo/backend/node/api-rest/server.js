const express = require('express');
const cors = require('cors');
const app = express();
app.use(express.json());
require('./src/Routes/index')(app);

app.use(cors());
app.use(express.json());
app.listen(3333);