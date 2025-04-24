/**
 * Module de calcul pour les installations gaz
 * Contient les fonctions relatives aux calculs gaz et vérifications réglementaires
 */

import { CONFIG } from '../config.js';
import { formatNumber } from '../utils/formatters.js';

/**
 * Calcule les paramètres gaz à partir des index de compteur
 * @param {number} indexDebut - Index début de compteur
 * @param {number} indexFin - Index fin de compteur
 * @param {number} duree - Durée de mesure en secondes
 * @param {number} pci - Pouvoir calorifique inférieur du gaz
 * @param {number} pression - Pression gaz mesurée en mbar
 * @returns {object} Résultat du calcul avec débit, puissance et pression
 */
export function calculerDebitGaz(indexDebut, indexFin, duree, pci, pression) {
    if (!indexDebut || !indexFin || !duree || !pci || !pression) {
        return { 
            success: false, 
            message: "Veuillez remplir tous les champs correctement" 
        };
    }
    
    try {
        // Calcul du volume consommé
        const volume = indexFin - indexDebut;
        
        // Calcul du débit horaire (m³/h)
        const debitHoraire = (volume * 3600) / duree;
        
        // Calcul de la puissance (kW)
        const puissance = debitHoraire * pci;
        
        // Calcul du rapport de pression
        const pressionNormale = pression / CONFIG.GAZ.PRESSION_NOMINALE;
        
        return {
            success: true,
            debit: formatNumber(debitHoraire, 2),
            puissance: formatNumber(puissance, 2),
            pression: formatNumber(pression, 0),
            rapport: formatNumber(pressionNormale, 2),
            message: `Débit : ${formatNumber(debitHoraire, 2)} m³/h | Puissance : ${formatNumber(puissance, 2)} kW | ` +
                     `Pression : ${formatNumber(pression, 0)} mbar (${formatNumber(pressionNormale, 2)} × Pn)`
        };
    } catch (error) {
        console.error("Erreur lors du calcul débit gaz:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}

/**
 * Calcule les paramètres gaz à partir du test Top Gaz (compteur à cadran)
 * @param {number} digit1 - Premier chiffre relevé
 * @param {number} digit2 - Deuxième chiffre relevé
 * @param {number} digit3 - Troisième chiffre relevé
 * @param {number} duree - Durée du test en secondes
 * @param {number} pcs - Pouvoir calorifique supérieur du gaz
 * @param {number} [puissanceChaudiere] - Puissance nominale de la chaudière (optionnel)
 * @returns {object} Résultat du calcul avec débit, puissance et écart
 */
export function calculerTopGaz(digit1, digit2, digit3, duree, pcs, puissanceChaudiere = null) {
    if (digit1 === undefined || digit2 === undefined || digit3 === undefined || !duree || !pcs) {
        return { 
            success: false, 
            message: "Veuillez remplir tous les chiffres du compteur" 
        };
    }
    
    try {
        // Volume en litres mesuré (3 digits)
        const volumeLitres = digit1 * 100 + digit2 * 10 + digit3;
        
        // Conversion en débit horaire (m³/h)
        const debitHoraire = (volumeLitres * 3600) / (duree * 1000);
        
        // Calcul de la puissance (kW)
        const puissance = debitHoraire * pcs;
        
        // Préparation des résultats
        const result = {
            success: true,
            volume: volumeLitres,
            duree: duree,
            debitHoraire: formatNumber(debitHoraire, 2),
            puissance: formatNumber(puissance, 1),
            message: `Volume mesuré : ${volumeLitres} L | Durée du test : ${duree} secondes | ` +
                     `Débit horaire : ${formatNumber(debitHoraire, 2)} m³/h | Puissance mesurée : ${formatNumber(puissance, 1)} kW`
        };
        
        // Ajout de l'analyse par rapport à la puissance chaudière si disponible
        if (puissanceChaudiere) {
            const ecart = ((puissance - puissanceChaudiere) / puissanceChaudiere * 100);
            const ecartAbsolu = Math.abs(ecart);
            
            result.ecart = formatNumber(ecart, 1);
            
            if (ecartAbsolu > 10) {
                result.coherence = "non";
                result.messageCoherence = `Écart important avec la puissance chaudière (${formatNumber(ecart, 1)}%)`;
            } else {
                result.coherence = "oui";
                result.messageCoherence = `Puissance cohérente avec la chaudière (${formatNumber(ecart, 1)}%)`;
            }
        }
        
        return result;
    } catch (error) {
        console.error("Erreur lors du calcul Top Gaz:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors du calcul" 
        };
    }
}

/**
 * Vérifie la conformité d'une installation gaz
 * @param {object} params - Paramètres de vérification
 * @param {boolean} params.regletteVaso - Si la réglette Vaso est conforme
 * @param {boolean} params.roai - Si le ROAI est conforme
 * @param {boolean} params.distances - Si les distances sont conformes
 * @returns {object} Résultat de la vérification avec statut et message
 */
export function verifierConformiteGaz(params) {
    const { regletteVaso, roai, distances } = params;
    
    try {
        const conforme = regletteVaso && roai && distances;
        
        let message = conforme ? "✔️ Conforme" : "⚠️ Non conforme";
        let details = [];
        
        if (!regletteVaso) details.push("❌ Réglette VASO non conforme");
        if (!roai) details.push("❌ ROAI non conforme");
        if (!distances) details.push("❌ Distances non respectées");
        
        return {
            success: true,
            conforme: conforme,
            message: message,
            details: details
        };
    } catch (error) {
        console.error("Erreur lors de la vérification conformité gaz:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors de la vérification" 
        };
    }
}

/**
 * Vérifie la conformité de la ventilation avec une hotte
 * @param {string} typeHotte - Type de hotte (motorisee/statique)
 * @param {string} typeAppareil - Type d'appareil (A/B/C)
 * @param {number} volumePiece - Volume de la pièce en m³
 * @param {boolean} clapet - Présence d'un clapet anti-retour
 * @param {boolean} asservissement - Présence d'un asservissement
 * @returns {object} Résultat de la vérification avec statut et message
 */
export function verifierVentilation(typeHotte, typeAppareil, volumePiece, clapet, asservissement) {
    try {
        let conforme = true;
        let messages = [];
        
        // Vérification de compatibilité hotte motorisée / appareil type B
        if (typeHotte === "motorisee" && typeAppareil === "B" && !asservissement) {
            conforme = false;
            messages.push("⚠️ Hotte motorisée interdite avec appareil type B sans asservissement");
        }
        
        // Vérification de la présence d'un clapet anti-retour
        if (!clapet) {
            conforme = false;
            messages.push("⚠️ Clapet anti-retour requis");
        }
        
        return {
            success: true,
            conforme: conforme,
            message: conforme ? "✔️ Conforme" : messages.join(" | "),
            details: messages
        };
    } catch (error) {
        console.error("Erreur lors de la vérification ventilation:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors de la vérification" 
        };
    }
}

/**
 * Vérifie la conformité de l'évacuation des fumées
 * @param {string} materiau - Matériau du conduit
 * @param {number} pente - Pente du conduit en %
 * @param {number} longueur - Longueur du conduit en m
 * @param {number} coudes - Nombre de coudes
 * @param {number} distanceOuvrants - Distance aux ouvrants en m
 * @returns {object} Résultat de la vérification avec statut et message
 */
export function verifierEvacuation(materiau, pente, longueur, coudes, distanceOuvrants) {
    try {
        let conforme = true;
        let messages = [];
        
        // Vérification de la pente
        if (pente < 1 || pente > 3) {
            conforme = false;
            messages.push("⚠️ Pente doit être entre 1% et 3%");
        }
        
        // Vérification du matériau pour type B
        if (materiau === "pvc" && typeAppareil === "B") {
            conforme = false;
            messages.push("⚠️ PVC interdit avec appareil type B");
        }
        
        // Vérification du nombre de coudes
        if (coudes > 3) {
            conforme = false;
            messages.push("⚠️ Maximum 3 coudes autorisés");
        }
        
        // Vérification de la distance aux ouvrants
        if (distanceOuvrants < 0.4) {
            conforme = false;
            messages.push("⚠️ Distance minimale aux ouvrants : 0.4m");
        }
        
        return {
            success: true,
            conforme: conforme,
            message: conforme ? "✔️ Conforme" : messages.join(" | "),
            details: messages
        };
    } catch (error) {
        console.error("Erreur lors de la vérification évacuation:", error);
        return { 
            success: false, 
            message: "Une erreur est survenue lors de la vérification" 
        };
    }
}