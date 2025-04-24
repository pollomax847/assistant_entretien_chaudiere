import { verifierConformite } from './logic.js';
import { applyStyles } from './styles.js';

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
                        <select id="typeVMC">
                            <option value="simple_flux">VMC simple flux classique</option>
                            <option value="sanitaire">VMC sanitaire (autoréglable)</option>
                            <option value="sekoia">Caisson Sekoia</option>
                            <option value="vti">VTI (VMC Très Intelligent)</option>
                        </select>
                    </label>
                </div>

                <div class="form-group">
                    <label>Nombre de bouches : 
                        <input type="number" id="nbBouches" min="1">
                    </label>
                </div>

                <div class="form-group">
                    <label>Débit total mesuré (m³/h) : 
                        <input type="number" id="debitMesure" min="0" step="0.1">
                    </label>
                </div>

                <div class="form-group">
                    <label>Débit en m/s : 
                        <input type="number" id="debitMS" min="0" step="0.1">
                    </label>
                </div>

                <div class="form-group">
                    <label>Modules aux fenêtres conformes ?
                        <select id="modulesFenetre">
                            <option value="true">Oui</option>
                            <option value="false">Non</option>
                        </select>
                    </label>
                </div>

                <div class="form-group">
                    <label>Rappel : avez-vous vérifié l'étalonnage des portes ?
                        <select id="etalonnagePortes">
                            <option value="true">Oui</option>
                            <option value="false">Non</option>
                        </select>
                    </label>
                </div>

                <div class="form-group">
                    <button id="verifierVMC" class="btn-primary">Vérifier conformité</button>
                </div>

                <div id="resVMC" class="result"></div>
            </section>
        </div>
    `;

    container.innerHTML = html;

    // Ajouter les écouteurs d'événements
    document.getElementById('verifierVMC').addEventListener('click', verifierConformite);
} 