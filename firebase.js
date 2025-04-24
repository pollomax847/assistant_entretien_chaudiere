// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyARWhlmqcQHMwuh3IrmjVUbB9Voe32nCaA",
  authDomain: "assistant-entretien-chaudiere.firebaseapp.com",
  projectId: "assistant-entretien-chaudiere",
  storageBucket: "assistant-entretien-chaudiere.firebasestorage.app",
  messagingSenderId: "381670946784",
  appId: "1:381670946784:web:af6163101624273f171d85",
  measurementId: "G-DMLBP48V3R"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth(app);
const db = getFirestore(app);

export { app, analytics, auth, db }; 