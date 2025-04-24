export const MODULES = {
    VMC: {
        name: "VMC",
        path: "/vmc",
        icon: "ventilation",
        description: "Vérification de conformité des installations VMC"
    },
    CHAUFFAGE: {
        name: "Chauffage",
        path: "/chauffage",
        icon: "heating",
        description: "Calcul de puissance et dimensionnement"
    },
    ECS: {
        name: "ECS",
        path: "/ecs",
        icon: "water",
        description: "Calcul ECS instantané"
    },
    GAZ: {
        name: "Test Gaz",
        path: "/gaz",
        icon: "gas",
        description: "Mesure de puissance et Top Gaz"
    },
    REGLEMENTAIRE: {
        name: "Réglementaire",
        path: "/reglementaire",
        icon: "rules",
        description: "Vérifications de conformité"
    },
    RADIATEURS: {
        name: "Radiateurs",
        path: "/radiateurs",
        icon: "radiator",
        description: "Calcul et équilibrage des radiateurs"
    }
};

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