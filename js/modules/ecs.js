/**
 * Module de calcul pour l'eau chaude sanitaire (ECS)
 * Contient les fonctions relatives aux calculs d'ECS
 */

import { CONFIG } from '../config.js';
import { formatNumber } from '../utils/formatters.js';

/**
 * Calcule la puissance nécessaire pour l'ECS instantanée
 * @param {number} tempEfs - Température eau froide sanitaire en °C
 * @param {number} tempEcs - Température eau chaude sanitaire en °C
 * @param {number} debit - Débit ECS en L/min
 * @param {number} [puissanceChaudiere] - Puissance chaudière en kW (optionnel)
 * @returns {object} Résultat du calcul avec deltaT, débit et puissance
 */
export function calculerEcsInstantane(tempEfs, tempEcs, debit, puissanceChaudiere = null) {
    if (!tempEfs || !tempEcs || !debit) {
        return { 
            success: false, 
            message: "Veuillez remplir tous les champs correctement" 
        };
    }
    
    try {
        // Calcul du delta de température
        const deltaT = tempEcs - tempEfs;
        
        // Calcul de la puissance restituée (kW)
        const puissanceRestituee = (debit * deltaT) / CONFIG.ECS.COEF_CONVERSION;
        
        // Préparation des résultats
        const result = {
            success: true,
            deltaT: formatNumber(deltaT, 1),
            debit: formatNumber(debit, 1),
            puissanceRestituee: formatNumber(puissanceRestituee, 1),
            message: `ΔT : ${formatNumber(deltaT, 1)} °C | Débit : ${formatNumber(debit, 1)} L/min | ` + 
                     `Puissance restituée : ${formatNumber(puissanceRestituee, 1)} kW`
        };
        
        // Ajout de l'analyse par rapport à la puissance chaudière si disponible
        if (puissanceChaudiere) {
            const ratio = puissanceRestituee / puissanceChaudiere;
            
            if (ratio < 0.7) {
                result.coherence = "faible";
                result.messageCoherence = `Puissance restituée trop faible par rapport à la chaudière (${puissanceChaudiere} kW)`;
            } else if (ratio > 1.3) {
                result.coherence = "elevee";
                result.messageCoherence = `Consommation trop élevée par rapport à la chaudière (${puissanceChaudiere} kW)`;
            } else {
                result.coherence = "bonne";
                result.messageCoherence = "Puissance restituée cohérente";
            }
        }
        
        return result;
    } catch (error) {
        console.error("Erreur lors du calcul ECS instantané:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}

/**
 * Calcule la puissance à partir d'un volume d'ECS consommé
 * @param {number} volume - Volume d'ECS consommé en L
 * @param {number} duree - Durée de consommation en minutes
 * @param {number} tempEfs - Température eau froide sanitaire en °C
 * @param {number} tempEcs - Température eau chaude sanitaire en °C
 * @returns {object} Résultat du calcul avec débit, deltaT et puissance
 */
export function calculerEcsVolume(volume, duree, tempEfs, tempEcs) {
    if (!volume || !duree || !tempEfs || !tempEcs || duree <= 0) {
        return { 
            success: false, 
            message: "Veuillez remplir tous les champs correctement" 
        };
    }
    
    try {
        // Calcul du débit (L/min)
        const debit = (volume / duree) * 60;
        
        // Calcul du delta de température
        const deltaT = tempEcs - tempEfs;
        
        // Calcul de la puissance (kW)
        const puissance = (debit * deltaT) / CONFIG.ECS.COEF_CONVERSION;
        
        return {
            success: true,
            debit: formatNumber(debit, 1),
            deltaT: formatNumber(deltaT, 1),
            puissance: formatNumber(puissance, 1),
            message: `Débit : ${formatNumber(debit, 1)} L/min | ΔT : ${deltaT}°C | Puissance : ${formatNumber(puissance, 1)} kW`
        };
    } catch (error) {
        console.error("Erreur lors du calcul ECS volume:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}