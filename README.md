# Francofolies

Application sous Flutter pour afficher et aider les utilisateurs à savoir quels concerts il y a.

---

## Utilisation

Pour utiliser l'application, il faut d'abord faire `node server.js` dans le dossier `backend` du projet, puis l'application peut-être lancée en utilisant `flutter run` dans le terminal.

---

## MCD

Base de données actuelle

```sql
CREATE DATABASE francofolies_db;
USE francofolies_db;
CREATE TABLE concerts (
 id INT AUTO_INCREMENT PRIMARY KEY,
 artiste VARCHAR(255) NOT NULL,
 date DATE NOT NULL,
 lieu VARCHAR(255) NOT NULL
);
INSERT INTO concerts (artiste, date, lieu) VALUES
('Angèle', '2025-07-12', 'Scène principale'),
('Stromae', '2025-07-13', 'Scène océan'),
('Orelsan', '2025-07-14', 'Scène principale');
```
