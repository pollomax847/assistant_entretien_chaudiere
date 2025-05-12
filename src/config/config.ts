import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Charger les variables d'environnement
dotenv.config({ path: path.join(__dirname, '../../.env') });

// Configuration de l'application
const config = {
  // Configuration du serveur
  server: {
    port: process.env.PORT || 3000,
    nodeEnv: process.env.NODE_ENV || 'development',
  },

  // Configuration du client
  client: {
    url: process.env.CLIENT_URL || 'http://localhost:5173',
    apiUrl: process.env.API_URL || 'http://localhost:3000',
  },

  // Configuration Firebase
  firebase: {
    apiKey: process.env.VITE_FIREBASE_API_KEY,
    authDomain: process.env.VITE_FIREBASE_AUTH_DOMAIN,
    projectId: process.env.VITE_FIREBASE_PROJECT_ID,
    storageBucket: process.env.VITE_FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.VITE_FIREBASE_APP_ID,
    measurementId: process.env.VITE_FIREBASE_MEASUREMENT_ID,
  },

  // Configuration des modules
  modules: {
    defaultPath: '/home',
    paths: {
      home: '/home',
      vmc: '/vmc',
      puissance: '/puissance-chauffage',
    },
  },
} as const;

export default config; 