/**
 * Service Firebase
 * Initialise et exporte les fonctionnalités Firebase
 */

import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { firebaseConfig } from "./firebase.config.js";

/**
 * Initialise Firebase avec la configuration sécurisée
 */
let app, analytics, auth, db;

try {
  // Initialiser Firebase
  app = initializeApp(firebaseConfig);
  analytics = getAnalytics(app);
  auth = getAuth(app);
  db = getFirestore(app);
  
  console.log("Firebase initialisé avec succès");
} catch (error) {
  console.error("Erreur lors de l'initialisation de Firebase:", error);
}

export { app, analytics, auth, db };