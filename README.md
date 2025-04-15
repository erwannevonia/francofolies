# Francofolies

Application sous Flutter pour afficher et aider les utilisateurs à savoir quels concerts il y a.

---

## Utilisation

Pour utiliser l'application, il faut d'abord faire `node server.js` dans le dossier `backend` du projet, puis l'application peut être lancée en utilisant `flutter run` dans le terminal.

Le fichier ressemble à ça :

```javascript
const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());
const db = mysql.createConnection({
 host: '127.0.0.1',
 user: 'root',
 password: 't',
 database: 'francofolies_db'
});
db.connect(err => {
 if (err) throw err;
 console.log('Base de données connectée');
});
app.get('/concert', (req, res) => {
  const query = `
    SELECT cd.ID_CONCERT, ca.NOM_ARTISTE, cd.DATE_SHOW, cs.NOM_SCENE
    FROM CONCERT_DATE cd
    JOIN CONCERT_ARTISTE ca ON cd.ID_CONCERT = ca.ID_CONCERT
    JOIN CONCERT_SCENE cs ON ca.ID_SCENE = cs.ID_SCENE
  `;
  
  db.query(query, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});
app.get('/concerts', (req, res) => {
  const { scene, artiste, date } = req.query;
  
  let query = `
    SELECT cd.ID_CONCERT, ca.NOM_ARTISTE, cd.DATE_SHOW, cs.NOM_SCENE
    FROM CONCERT_DATE cd
    JOIN CONCERT_ARTISTE ca ON cd.ID_CONCERT = ca.ID_CONCERT
    JOIN CONCERT_SCENE cs ON ca.ID_SCENE = cs.ID_SCENE
    WHERE 1=1
  `;
  let params = [];

  if (scene) {
    query += ` AND cs.NOM_SCENE LIKE ?`;
    params.push(`%${scene}%`);
  }
  if (artiste) {
    query += ` AND ca.NOM_ARTISTE LIKE ?`;
    params.push(`%${artiste}%`);
  }
  if (date) {
    query += ` AND DATE(cd.DATE_SHOW) = ?`;
    params.push(date);
  }

  db.query(query, params, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});
app.listen(3000, () => {
 console.log('Serveur en écoute sur le port 3000');
});
```

---

## MCD

Base de données actuelle

```sql
CREATE TABLE CONCERT_SCENE(
   ID_SCENE INT AUTO_INCREMENT,
   NOM_SCENE VARCHAR(100)  NOT NULL,
   PRIMARY KEY(ID_SCENE)
);

CREATE TABLE CONCERT_DATE(
   ID_CONCERT INT,
   DATE_SHOW DATETIME NOT NULL,
   PRIMARY KEY(ID_CONCERT)
);

CREATE TABLE UTILISATEUR(
   ID_USER INT AUTO_INCREMENT,
   PSEUDO_USER VARCHAR(100)  NOT NULL,
   PASSWORD_USER VARCHAR(100)  NOT NULL,
   PRIMARY KEY(ID_USER)
);

CREATE TABLE CONCERT_ARTISTE(
   ID_ARTISTE INT,
   NOM_ARTISTE VARCHAR(100)  NOT NULL,
   ID_SCENE INT NOT NULL,
   ID_CONCERT INT NOT NULL,
   PRIMARY KEY(ID_ARTISTE),
   FOREIGN KEY(ID_SCENE) REFERENCES CONCERT_SCENE(ID_SCENE),
   FOREIGN KEY(ID_CONCERT) REFERENCES CONCERT_DATE(ID_CONCERT)
);

CREATE TABLE FAVORIS(
   ID_CONCERT INT,
   ID_USER INT,
   PRIMARY KEY(ID_CONCERT, ID_USER),
   FOREIGN KEY(ID_CONCERT) REFERENCES CONCERT_DATE(ID_CONCERT),
   FOREIGN KEY(ID_USER) REFERENCES UTILISATEUR(ID_USER)
);```