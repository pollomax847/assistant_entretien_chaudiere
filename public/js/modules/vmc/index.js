/**
 * Module VMC - Interface utilisateur
 */

import { verifierVmc } from './logic.js';
import { applyStyles } from './styles.js';

/**
 * Initialise le module VMC
 */
export function initVmc() {
    const typeVmc = document.getElementById('vmc-type');
    const nbBouches = document.getElementById('vmc-bouches');
    const debitMh = document.getElementById('vmc-debit-mh');
    const debitMs = document.getElementById('vmc-debit-ms');
    const modulesFenetres = document.getElementById('vmc-modules-fenetres');
    const etalonnagePortes = document.getElementById('vmc-etalonnage-portes');
    const verifierBtn = document.getElementById('btn-verifier-vmc');
    
    // Si le bouton existe
    if (verifierBtn) {
        verifierBtn.addEventListener('click', () => {
            performVmcVerification();
        });
    }
    
    // Vérification automatique quand les champs changent
    [typeVmc, nbBouches, debitMh, debitMs, modulesFenetres, etalonnagePortes].forEach(el => {
        if (el) {
            if (el.tagName === 'SELECT') {
                el.addEventListener('change', performVmcVerification);
            } else {
                el.addEventListener('input', performVmcVerification);
            }
        }
    });
}

/**
 * Effectue la vérification de la VMC
 */
function performVmcVerification() {
    const typeVmc = document.getElementById('vmc-type')?.value;
    const nbBouches = parseInt(document.getElementById('vmc-bouches')?.value);
    const debitMh = parseFloat(document.getElementById('vmc-debit-mh')?.value);
    const debitMs = parseFloat(document.getElementById('vmc-debit-ms')?.value);
    const modulesFenetres = document.getElementById('vmc-modules-fenetres')?.value === 'oui';
    const etalonnagePortes = document.getElementById('vmc-etalonnage-portes')?.value === 'oui';
    
    const resultContainer = document.getElementById('result-vmc');
    
    if (!resultContainer) return;
    
    // Vérifier si les champs requis sont remplis
    if (!typeVmc || isNaN(nbBouches) || isNaN(debitMh)) {
        resultContainer.innerHTML = '<p>Veuillez remplir les champs obligatoires</p>';
        resultContainer.className = 'result-box';
        return;
    }
    
    // Effectuer la vérification
    const result = verifierVmc({
        type: typeVmc,
        nbBouches: nbBouches,
        debitMh: debitMh,
        debitMs: debitMs || null,
        modulesFenetres: modulesFenetres,
        etalonnagePortes: etalonnagePortes
    });
    
    // Afficher le résultat
    if (result.success) {
        const statusIcon = result.conforme ? '✅' : '⚠️';
        const statusClass = result.conforme ? 'success' : 'error';
        
        resultContainer.innerHTML = `
            <p class="${statusClass}">
                <strong>${statusIcon} ${result.message}</strong>
            </p>
            <ul>
                ${result.messages.map(msg => `<li>${msg}</li>`).join('')}
            </ul>
        `;
        
        resultContainer.className = `result-box ${statusClass}`;
    } else {
        resultContainer.innerHTML = `<p>${result.message}</p>`;
        resultContainer.className = 'result-box';
    }
}

/**
 * Render the VMC module UI
 */
export async function render(container) {
    // Appliquer les styles spécifiques au module
    applyStyles();

    // Créer l'interface utilisateur
    const html = `
        <div class="vmc-container">
            <h1>Module VMC - Chauffage Expert</h1>
            <section id="vmc">
                <div class="form-group">
                    <label>Type d'installation :
                        <select id="vmc-type">
                            <option value="simple_flux">VMC simple flux classique</option>
                            <option value="sanitaire">VMC sanitaire (autoréglable)</option>
                            <option value="sekoia">Caisson Sekoia</option>
                            <option value="vti">VTI (VMC Très Intelligent)</option>
                        </select>
                    </label>
                </div>

                <div class="form-group">
                    <label>Nombre de bouches : 
                        <input type="number" id="vmc-bouches" min="1">
                    </label>
                </div>

                <div class="form-group">
                    <label>Débit total mesuré (m³/h) : 
                        <input type="number" id="vmc-debit-mh" min="0" step="0.1">
                    </label>
                </div>

                <div class="form-group">
                    <label>Débit en m/s : 
                        <input type="number" id="vmc-debit-ms" min="0" step="0.1">
                    </label>
                </div>

                <div class="form-group">
                    <label>Modules aux fenêtres conformes ?
                        <select id="vmc-modules-fenetres">
                            <option value="oui">Oui</option>
                            <option value="non">Non</option>
                        </select>
                    </label>
                </div>

                <div class="form-group">
                    <label>Rappel : avez-vous vérifié l'étalonnage des portes ?
                        <select id="vmc-etalonnage-portes">
                            <option value="oui">Oui</option>
                            <option value="non">Non</option>
                        </select>
                    </label>
                </div>

                <div class="form-group">
                    <button id="btn-verifier-vmc" class="btn-primary">Vérifier conformité</button>
                </div>

                <div id="result-vmc" class="result"></div>
            </section>
        </div>
    `;

    container.innerHTML = html;

    // Initialise le module VMC
    initVmc();
}