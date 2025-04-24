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

// Configuration des modules
export const MODULES = {
    VMC: {
        name: "VMC",
        path: "/vmc",
        icon: "ventilation"
    },
    CHAUFFAGE: {
        name: "Chauffage",
        path: "/chauffage",
        icon: "heating"
    },
    ECS: {
        name: "ECS",
        path: "/ecs",
        icon: "water"
    },
    GAZ: {
        name: "Test Gaz",
        path: "/gaz",
        icon: "gas"
    },
    REGLEMENTAIRE: {
        name: "Réglementaire",
        path: "/reglementaire",
        icon: "rules"
    },
    RADIATEURS: {
        name: "Radiateurs",
        path: "/radiateurs",
        icon: "radiator"
    }
};

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