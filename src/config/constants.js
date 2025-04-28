// Configuration Firebase
export const FIREBASE_CONFIG = {
    apiKey: "AIzaSyARWhlmqcQHMwuh3IrmjVUbB9Voe32nCaA",
    authDomain: "assistant-entretien-chaudiere.firebaseapp.com",
    projectId: "assistant-entretien-chaudiere",
    storageBucket: "assistant-entretien-chaudiere.firebasestorage.app",
    messagingSenderId: "381670946784",
    appId: "1:381670946784:web:af6163101624273f171d85",
    measurementId: "G-DMLBP48V3R"
};

// Configuration des modules disponibles dans l'application
export const MODULES = [
  {
    id: 'module-puissance-chauffage',
    path: '/puissance-chauffage',
    title: 'Puissance Chauffage',
    description: 'Calcul de la puissance de chauffage nécessaire'
  },
  {
    id: 'module-vase-expansion',
    path: '/vase-expansion',
    title: 'Vase d\'Expansion',
    description: 'Calcul du dimensionnement du vase d\'expansion'
  },
  {
    id: 'module-equilibrage',
    path: '/equilibrage',
    title: 'Équilibrage Réseau',
    description: 'Équilibrage du réseau de chauffage'
  },
  {
    id: 'module-radiateurs',
    path: '/radiateurs',
    title: 'Radiateurs',
    description: 'Dimensionnement des radiateurs'
  },
  {
    id: 'module-vmc',
    path: '/vmc',
    title: 'VMC',
    description: 'Vérification et calcul VMC'
  }
];

// Paramètres pour les modules VMC
export const VMC_CONFIG = {
  minDebit: 15, // m³/h par pièce
  minDebitMS: 0.5, // m/s minimum
  maxDebitMS: 4, // m/s maximum
};

// Configuration générale de l'application
export const APP_CONFIG = {
  appName: 'Assistant Entretien Chaudière',
  localStoragePrefix: 'assistant_chauffage_',
  defaultModule: '/vmc'
};

// Fonction pour charger les favoris
export function loadFavorites() {
  try {
    const favorites = localStorage.getItem(`${APP_CONFIG.localStoragePrefix}favorites`);
    return favorites ? JSON.parse(favorites) : [];
  } catch (error) {
    console.error('Erreur lors du chargement des favoris:', error);
    return [];
  }
}

// Configuration des styles
export const THEME = {
    colors: {
        primary: "#4CAF50",
        secondary: "#2196F3",
        success: "#4CAF50",
        warning: "#FFC107",
        error: "#F44336",
        background: "#FFFFFF",
        text: "#333333"
    },
    spacing: {
        small: "8px",
        medium: "16px",
        large: "24px"
    },
    breakpoints: {
        mobile: "480px",
        tablet: "768px",
        desktop: "1024px"
    }
};