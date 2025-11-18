import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import cors from 'cors';
import helmet from 'helmet';
import config from '../config/config.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middleware de sécurité
app.use(helmet());
app.use(cors({
  origin: config.client.url,
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Servir les fichiers statiques
app.use(express.static(path.join(__dirname, '../dist')));
app.use('/assets', express.static(path.join(__dirname, '../src/assets')));

// Routes API
// TODO: Importer et utiliser les routes API ici

// Route pour la page d'accueil
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../index.html'));
});

// Gestion des erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// Démarrer le serveur
app.listen(config.server.port, () => {
  console.log(`Server running on http://localhost:${config.server.port}`);
  console.log(`Environment: ${config.server.nodeEnv}`);
});
