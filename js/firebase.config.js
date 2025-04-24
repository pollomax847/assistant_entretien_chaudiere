/**
 * Configuration Firebase sécurisée
 * Utilise des variables d'environnement pour les clés sensibles
 */

// Configuration Firebase à charger à partir de variables d'environnement
// ou d'un fichier chargé dynamiquement à l'exécution
export const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY || window.env?.FIREBASE_API_KEY,
  authDomain: "assistant-entretien-chaudiere.firebaseapp.com",
  projectId: "assistant-entretien-chaudiere",
  storageBucket: "assistant-entretien-chaudiere.firebasestorage.app",
  messagingSenderId: "381670946784",
  appId: process.env.FIREBASE_APP_ID || window.env?.FIREBASE_APP_ID,
  measurementId: process.env.FIREBASE_MEASUREMENT_ID || window.env?.FIREBASE_MEASUREMENT_ID
};