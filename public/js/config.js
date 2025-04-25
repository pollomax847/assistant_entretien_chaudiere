/**
 * Configuration globale pour l'application
 */

export const CONFIG = {
    CHAUFFAGE: {
        TEMPERATURE_REFERENCE: 19, // Température de référence en °C
        COEF_SECURITE: 1.1 // Coefficient de sécurité pour les calculs de puissance
    },
    ECS: {
        TEMP_EFS_DEFAULT: 10, // Température eau froide par défaut (°C)
        TEMP_ECS_DEFAULT: 45, // Température eau chaude par défaut (°C)
        COEF_CONVERSION: 14.3 // Coefficient pour conversion débit/puissance
    },
    GAZ: {
        PCS: {
            NATUREL: 9.6, // Pouvoir Calorifique Supérieur gaz naturel (kWh/m³)
            PROPANE: 12.8 // PCS propane (kWh/kg)
        },
        PRESSION_NOMINALE: 20 // Pression nominale en mbar
    },
    VMC: {
        NORMES_DEBIT: {
            SIMPLE_FLUX: { min: 15, max: 30 },
            HYGRO_A: { min: 10, max: 40 },
            HYGRO_B: { min: 5, max: 45 },
            DOUBLE_FLUX: { min: 20, max: 50 },
            GAZ: { min: 15, max: 30 }
        }
    }
};