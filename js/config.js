/**
 * Configuration globale de l'application
 * Ce fichier contient des constantes et paramètres utilisés dans l'application
 */

export const CONFIG = {
    // Paramètres de calcul
    CHAUFFAGE: {
        TEMPERATURE_REFERENCE: 19, // Température de référence en °C
        COEF_SECURITE: 1.1, // Coefficient de sécurité pour les calculs de puissance
    },
    ECS: {
        TEMP_EFS_DEFAULT: 10, // Température eau froide par défaut (°C)
        TEMP_ECS_DEFAULT: 55, // Température eau chaude par défaut (°C)
        COEF_CONVERSION: 0.0143, // Coefficient pour conversion débit/puissance
    },
    GAZ: {
        PCS: {
            NATUREL: 9.6, // Pouvoir Calorifique Supérieur gaz naturel (kWh/m³)
            PROPANE: 12.8, // PCS propane (kWh/m³)
            BUTANE: 25.9, // PCS butane (kWh/m³)
        },
        PRESSION_NOMINALE: 20, // Pression nominale en mbar
    },
    REGLEMENTAIRE: {
        VENTILATION: {
            DEBIT_MIN_PAR_BOUCHE: 15, // Débit minimum en m³/h par bouche VMC
            VITESSE_MIN: 0.8, // Vitesse minimale en m/s
            VITESSE_MAX: 2.5, // Vitesse maximale en m/s
        },
    },
};