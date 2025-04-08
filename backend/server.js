const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());
const db = mysql.createConnection({
 host: '172.16.198.254',
 user: 'franco',
 password: 't',
 database: 'francofolies_db'
});
db.connect(err => {
 if (err) throw err;
 console.log('Base de données connectée');
});
app.get('/concerts', (req, res) => {
 db.query('SELECT * FROM concerts', (err, result) => {
 if (err) throw err;
 res.json(result);
 });
});
app.listen(3000, () => {
 console.log('Serveur en écoute sur le port 3000');
});