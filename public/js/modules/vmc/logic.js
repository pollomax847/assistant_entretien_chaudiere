import { CONFIG } from '../../config.js';
import { formatNumber } from '../../utils/formatters.js';

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
 */
export function verifierConformite() {
    const typeVMC = document.getElementById('typeVMC').value;
    const nbBouches = parseInt(document.getElementById('nbBouches').value);
    const debitMesure = parseFloat(document.getElementById('debitMesure').value);
    const debitMS = parseFloat(document.getElementById('debitMS').value);
    const modulesFenetre = document.getElementById('modulesFenetre').value === 'true';
    const etalonnagePortes = document.getElementById('etalonnagePortes').value === 'true';
    
    const resultat = document.getElementById('resVMC');
    let estConforme = true;
    let message = '';

    try {
        // Vérification des valeurs requises
        if (!nbBouches || isNaN(debitMesure) || isNaN(debitMS)) {
            message = '⚠️ Veuillez remplir tous les champs requis';
            estConforme = false;
        } else {
            // Vérification du débit minimum par bouche
            const debitMinTotal = nbBouches * CONFIG.REGLEMENTAIRE.VENTILATION.DEBIT_MIN_PAR_BOUCHE;
            if (debitMesure < debitMinTotal) {
                message += `❌ Débit insuffisant (${formatNumber(debitMesure, 1)} m³/h). Minimum requis : ${debitMinTotal} m³/h<br>`;
                estConforme = false;
            } else {
                message += `✅ Débit total conforme (${formatNumber(debitMesure, 1)} m³/h)<br>`;
            }

            // Vérification de la vitesse d'air
            if (debitMS < CONFIG.REGLEMENTAIRE.VENTILATION.VITESSE_MIN || 
                debitMS > CONFIG.REGLEMENTAIRE.VENTILATION.VITESSE_MAX) {
                message += `❌ Vitesse d'air non conforme (${formatNumber(debitMS, 1)} m/s). Plage acceptable : ${CONFIG.REGLEMENTAIRE.VENTILATION.VITESSE_MIN} - ${CONFIG.REGLEMENTAIRE.VENTILATION.VITESSE_MAX} m/s<br>`;
                estConforme = false;
            } else {
                message += `✅ Vitesse d'air conforme (${formatNumber(debitMS, 1)} m/s)<br>`;
            }

            // Vérification des modules de fenêtre
            if (!modulesFenetre) {
                message += '❌ Modules aux fenêtres non conformes<br>';
                estConforme = false;
            } else {
                message += '✅ Modules aux fenêtres conformes<br>';
            }

            // Vérification de l'étalonnage des portes
            if (!etalonnagePortes) {
                message += '❌ Étalonnage des portes non vérifié<br>';
                estConforme = false;
            } else {
                message += '✅ Étalonnage des portes vérifié<br>';
            }
        }

        // Affichage du résultat
        resultat.innerHTML = `
            <div class="result ${estConforme ? 'success' : 'error'}">
                <h4>${estConforme ? '✅ Installation conforme' : '❌ Installation non conforme'}</h4>
                <div class="details">
                    ${message}
                </div>
            </div>
        `;

    } catch (error) {
        console.error('Erreur lors de la vérification VMC:', error);
        resultat.innerHTML = '⚠️ Une erreur est survenue lors de la vérification';
    }
}