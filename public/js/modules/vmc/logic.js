/**
 * Module VMC - Logique de vérification
 */

import { CONFIG } from '../../config.js';
import { formatNumber, formatResult } from '../../utils/formatters.js';

/**
 * Initialise les écouteurs d'événements pour la VMC
 */
export function initVMC() {
    ['typeVMC', 'nbBouches', 'debitMesure', 'debitMS', 'modulesFenetre', 'etalonnagePortes'].forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.addEventListener('input', verifierConformite);
        }
    });
}

/**
 * Vérifie la conformité de l'installation VMC
 * 
 * @param {Object} params - Paramètres de la VMC
 * @param {string} params.type - Type de VMC (simple-auto, simple-hygro-a, etc.)
 * @param {number} params.nbBouches - Nombre de bouches d'extraction
 * @param {number} params.debitMh - Débit total mesuré en m³/h
 * @param {number} params.debitMs - Débit mesuré en m/s (cuisine)
 * @param {boolean} params.modulesFenetres - Conformité des modules aux fenêtres
 * @param {boolean} params.etalonnagePortes - Vérification de l'étalonnage des portes
 * @returns {Object} Résultat de la vérification
 */
export function verifierVmc(params) {
    // Vérifier les paramètres requis
    if (!params.type || !params.nbBouches || !params.debitMh) {
        return {
            success: false,
            message: "Veuillez remplir tous les champs obligatoires",
        };
    }

    try {
        // Déterminer les normes de débit selon le type de VMC
        let normesDebit = CONFIG.VMC.NORMES_DEBIT.SIMPLE_FLUX;
        
        if (params.type === 'simple-hygro-a') normesDebit = CONFIG.VMC.NORMES_DEBIT.HYGRO_A;
        else if (params.type === 'simple-hygro-b') normesDebit = CONFIG.VMC.NORMES_DEBIT.HYGRO_B;
        else if (params.type === 'double-flux') normesDebit = CONFIG.VMC.NORMES_DEBIT.DOUBLE_FLUX;
        else if (params.type === 'gaz') normesDebit = CONFIG.VMC.NORMES_DEBIT.GAZ;
        
        // Calculer le débit moyen par bouche
        const debitMoyen = params.debitMh / params.nbBouches;
        
        // Vérifier la conformité du débit
        const debitConforme = debitMoyen >= normesDebit.min && debitMoyen <= normesDebit.max;
        
        // Préparer les messages et statuts
        let messages = [];
        let isConforme = true;
        
        // Vérification du débit moyen
        if (!debitConforme) {
            messages.push(`Débit moyen par bouche: ${formatNumber(debitMoyen, 1)} m³/h (hors norme: ${normesDebit.min}-${normesDebit.max} m³/h)`);
            isConforme = false;
        } else {
            messages.push(`Débit moyen par bouche: ${formatNumber(debitMoyen, 1)} m³/h (conforme)`);
        }
        
        // Vérification du débit en m/s si fourni
        if (params.debitMs) {
            if (params.debitMs < 0.5 || params.debitMs > 2.5) {
                messages.push(`Vitesse d'air: ${formatNumber(params.debitMs, 1)} m/s (hors plage recommandée: 0.5-2.5 m/s)`);
                isConforme = false;
            } else {
                messages.push(`Vitesse d'air: ${formatNumber(params.debitMs, 1)} m/s (conforme)`);
            }
        }
        
        // Vérification des entrées d'air aux fenêtres
        if (!params.modulesFenetres) {
            messages.push("Entrées d'air aux fenêtres non conformes");
            isConforme = false;
        } else {
            messages.push("Entrées d'air aux fenêtres conformes");
        }
        
        // Vérification de l'étalonnage des portes
        if (!params.etalonnagePortes) {
            messages.push("Étalonnage/détalonnage des portes non vérifié");
            isConforme = false;
        } else {
            messages.push("Étalonnage/détalonnage des portes vérifié");
        }
        
        // Résultat final
        return {
            success: true,
            conforme: isConforme,
            messages: messages,
            message: isConforme ? "VMC CONFORME" : "VMC NON CONFORME",
            type: isConforme ? "success" : "error"
        };
        
    } catch (error) {
        console.error("Erreur lors de la vérification VMC:", error);
        return {
            success: false,
            message: "Une erreur est survenue lors de la vérification"
        };
    }
}