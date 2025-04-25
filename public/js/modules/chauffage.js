/**
 * Module de calcul pour le chauffage
 * Contient les fonctions relatives au calcul de puissance de chauffage
 */

import { CONFIG } from '../config.js';
import { formatNumber } from '../utils/formatters.js';

/**
 * Calcule la puissance de chauffage nécessaire
 * @param {number} volume - Volume de la pièce en m³
 * @param {number} coefG - Coefficient G d'isolation
 * @param {number} tempExt - Température extérieure de base en °C
 * @returns {object} Résultat du calcul avec puissance en kW
 */
export function calculerPuissanceChauffage(volume, coefG, tempExt) {
    if (!volume || !coefG || tempExt === undefined) {
        return { 
            success: false, 
            message: "Veuillez remplir tous les champs correctement" 
        };
    }
    
    try {
        // Calcul de la puissance selon la formule P = G * V * ΔT / 1000
        const deltaT = CONFIG.CHAUFFAGE.TEMPERATURE_REFERENCE - tempExt;
        const puissance = (coefG * volume * deltaT / 1000) * CONFIG.CHAUFFAGE.COEF_SECURITE;
        
        return {
            success: true,
            volume: formatNumber(volume, 1),
            deltaT: formatNumber(deltaT, 1),
            puissance: formatNumber(puissance, 2),
            message: `Volume : ${formatNumber(volume, 1)} m³ | ΔT : ${formatNumber(deltaT, 1)}°C | Puissance : ${formatNumber(puissance, 2)} kW`
        };
    } catch (error) {
        console.error("Erreur lors du calcul de puissance chauffage:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}

/**
 * Calcule la puissance d'un radiateur selon ses dimensions et son type
 * @param {string} type - Type de radiateur
 * @param {number} hauteur - Hauteur en mm
 * @param {number} longueur - Longueur en mm
 * @param {string} [panneau] - Type de panneau (pour radiateurs à panneaux)
 * @returns {object} Résultat du calcul avec puissance en W
 */
export function calculerPuissanceRadiateur(type, hauteur, longueur, panneau = null) {
    if (!type || !hauteur || !longueur) {
        return { 
            success: false, 
            message: "Veuillez renseigner les dimensions et le type" 
        };
    }
    
    try {
        // Détermination du coefficient selon le type d'émetteur
        let coef = 0.06; // Valeur par défaut (acier)
        
        if (type === "Panneaux") {
            if (panneau === "T11") coef = 0.08;
            else if (panneau === "T22") coef = 0.12;
            else if (panneau === "T33") coef = 0.15;
        } else if (type === "Fonte") coef = 0.09;
        else if (type === "Aluminium") coef = 0.10;
        else if (type === "FonteAlu") coef = 0.11;
        else if (type === "SecheServiette") coef = 0.07;
        
        // Calcul de la surface en m²
        const surface = (hauteur * longueur) / 1000000;
        // Calcul de la puissance en W
        const puissance = surface * coef * 1000;
        
        return {
            success: true,
            surface: formatNumber(surface, 2),
            puissance: formatNumber(puissance, 0),
            message: `Puissance estimée : ${formatNumber(puissance, 0)} W`
        };
    } catch (error) {
        console.error("Erreur lors du calcul de puissance radiateur:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}

/**
 * Calcule les paramètres pour le vase d'expansion
 * @param {number} hauteurBatiment - Hauteur du bâtiment en m
 * @param {boolean} radiateurLoin - Si le radiateur le plus éloigné est au dernier étage
 * @returns {object} Résultat du calcul avec pression et réglage
 */
export function calculerVaseExpansion(hauteurBatiment, radiateurLoin) {
    if (!hauteurBatiment) {
        return { 
            success: false, 
            message: "Veuillez renseigner la hauteur du bâtiment" 
        };
    }
    
    try {
        // Calcul de la pression (hauteur en m / 10 + marge de sécurité)
        const pression = (hauteurBatiment / 10 + 0.3);
        
        // Détermination du réglage en fonction de la distance du radiateur
        let reglage;
        if (radiateurLoin) {
            reglage = "1,5 tours";
        } else {
            reglage = "Réglage à adapter en fonction du réseau";
        }
        
        return {
            success: true,
            pression: formatNumber(pression, 1),
            reglage: reglage,
            message: `Pression de gonflage recommandée : ${formatNumber(pression, 1)} bar | ${reglage}`
        };
    } catch (error) {
        console.error("Erreur lors du calcul de vase d'expansion:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}