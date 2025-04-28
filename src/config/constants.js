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

// Configuration générale de l'application
export const APP_CONFIG = {
    appName: 'Assistant Entretien Chaudière',
    version: '1.0.0',
    developer: 'YourName',
    appMode: 'development',
    apiBaseUrl: '/api',
    debug: true,
    localStoragePrefix: 'assistant_chauffage_',
    defaultModule: '/vmc'
};

// Configuration des modules disponibles dans l'application
export const MODULES = [
    {
        id: 'module-puissance-chauffage',
        path: '/puissance-chauffage',
        title: 'Puissance Chauffage',
        description: 'Calcul de la puissance de chauffage nécessaire',
        icon: '/public/icons/heating.svg',
        category: 'calcul',
        tags: ['chauffage', 'puissance', 'dimensionnement']
    },
    {
        id: 'module-vase-expansion',
        path: '/vase-expansion',
        title: 'Vase d\'Expansion',
        description: 'Calcul du dimensionnement du vase d\'expansion',
        icon: '/public/icons/tank.svg',
        category: 'calcul',
        tags: ['vase', 'expansion', 'dimensionnement']
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
        description: 'Vérification et calcul VMC',
        icon: '/public/icons/fan.svg',
        category: 'calcul',
        tags: ['ventilation', 'vmc', 'débit', 'air']
    }
];

// Paramètres pour les modules VMC
export const VMC_CONFIG = {
    minDebit: 15, // m³/h par pièce
    minDebitMS: 0.5, // m/s minimum
    maxDebitMS: 4, // m/s maximum
};

// Constantes techniques
export const CONSTANTS = {
    MATERIAUX: {
        'brique': { conductivite: 0.84, capaciteThermique: 840 },
        'beton': { conductivite: 2.3, capaciteThermique: 920 },
        'bois': { conductivite: 0.15, capaciteThermique: 1700 },
        'isolation': { conductivite: 0.04, capaciteThermique: 1450 }
    },
    ZONES_CLIMATIQUES: {
        'H1': -7,
        'H2': -4,
        'H3': 0,
        'H4': 5
    },
    TYPES_CHAUFFAGE: {
        'radiateur': { rendement: 0.9, temperatureDepart: 70 },
        'plancher': { rendement: 0.95, temperatureDepart: 40 },
        'ventilo': { rendement: 0.85, temperatureDepart: 60 }
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

// Exposer les constantes globalement pour la compatibilité
window.FIREBASE_CONFIG = FIREBASE_CONFIG;
window.APP_CONFIG = APP_CONFIG;
window.MODULES = MODULES;
window.CONSTANTS = CONSTANTS;
window.THEME = THEME;