// Configuration Firebase
window.FIREBASE_CONFIG = {
    apiKey: "AIzaSyARWhlmqcQHMwuh3IrmjVUbB9Voe32nCaA",
    authDomain: "assistant-entretien-chaudiere.firebaseapp.com",
    projectId: "assistant-entretien-chaudiere",
    storageBucket: "assistant-entretien-chaudiere.firebasestorage.app",
    messagingSenderId: "381670946784",
    appId: "1:381670946784:web:af6163101624273f171d85",
    measurementId: "G-DMLBP48V3R"
};

// Configuration des constantes de l'application
window.APP_CONFIG = {
    defaultModule: 'module-puissance-chauffage',
    appName: 'Assistant Entretien Chaudière',
    version: '1.0.0',
    developer: 'YourName',
    appMode: 'development',
    apiBaseUrl: '/api',
    debug: true
};

// Liste des modules disponibles
window.MODULES = [
    {
        id: 'module-puissance-chauffage',
        title: 'Puissance Chauffage',
        description: 'Calculer la puissance nécessaire pour chauffer un logement',
        // Use absolute paths within the project
        icon: '/public/icons/heating.svg',
        category: 'calcul',
        tags: ['chauffage', 'puissance', 'dimensionnement']
    },
    {
        id: 'module-vase-expansion',
        title: 'Vase d\'Expansion',
        description: 'Dimensionner un vase d\'expansion pour une installation de chauffage',
        icon: '/public/icons/tank.svg',
        category: 'calcul',
        tags: ['vase', 'expansion', 'dimensionnement']
    },
    {
        id: 'module-vmc',
        title: 'Ventilation',
        description: 'Calculer les débits de ventilation nécessaires',
        icon: '/public/icons/fan.svg',
        category: 'calcul',
        tags: ['ventilation', 'vmc', 'débit', 'air']
    }
];

// Liste des constantes
window.CONSTANTS = {
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
    // Autres constantes...
};

console.log('Constants loaded successfully');

// Export the constants for ES modules
export const APP_CONFIG = window.APP_CONFIG;
export const MODULES = window.MODULES;
export const CONSTANTS = window.CONSTANTS;
