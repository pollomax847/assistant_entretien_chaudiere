// Module VMC
window.modules = window.modules || {};

// Configuration du module VMC
const VMC_CONFIG = window.VMC_CONFIG || {
  minDebit: 15, // m³/h par pièce
  minDebitMS: 0.5, // m/s minimum
  maxDebitMS: 4 // m/s maximum
};

// Module de vérification et calcul pour VMC
window.modules['/vmc'] = {
  render: async (container) => {
    // Récupérer le contenu HTML du module VMC
    container.innerHTML = `
      <section id="section-vmc" class="vmc-section">
          <h1>Vérification VMC</h1>
          <div class="form-card">
              <form id="formVmc">
                  <div class="form-group">
                      <label for="typeVMC">Type d'installation :</label>
                      <select id="typeVMC">
                          <option>VMC simple flux classique</option>
                          <option>VMC sanitaire (autoréglable)</option>
                          <option>Caisson Sekoia</option>
                          <option>VTI (VMC Très Intelligent)</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label for="nbBouches">Nombre de bouches :</label>
                      <input type="number" id="nbBouches" min="1" value="1">
                  </div>
                  <div class="form-group">
                      <label for="debitMesure">Débit total mesuré (m³/h) :</label>
                      <input type="number" id="debitMesure" min="0">
                  </div>
                  <div class="form-group">
                      <label for="debitMS">Débit en m/s :</label>
                      <input type="number" id="debitMS" step="0.1" min="0">
                  </div>
                  <div class="form-group">
                      <label for="modulesFenetre">Modules aux fenêtres conformes ?</label>
                      <select id="modulesFenetre">
                          <option>Oui</option>
                          <option>Non</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label for="etalonnagePortes">Rappel : avez-vous vérifié l'étalonnage des portes ?</label>
                      <select id="etalonnagePortes">
                          <option>Oui</option>
                          <option>Non</option>
                      </select>
                  </div>
                  <div class="action-group">
                      <button type="button" id="btnVerifierVmc" class="btn-primary">Vérifier conformité</button>
                  </div>
              </form>
              <div id="resVMC" class="result-container"></div>
          </div>
      </section>
    `;

    // Initialiser les écouteurs d'événements
    const btnVerifier = container.querySelector('#btnVerifierVmc');
    if (btnVerifier) {
      btnVerifier.addEventListener('click', () => {
        verifierConformiteVMC();
      });
    }

    // Fonction pour vérifier la conformité de la VMC
    function verifierConformiteVMC() {
      const typeVMC = document.getElementById('typeVMC').value;
      const nbBouches = parseInt(document.getElementById('nbBouches').value) || 0;
      const debitMesure = parseFloat(document.getElementById('debitMesure').value) || 0;
      const debitMS = parseFloat(document.getElementById('debitMS').value) || 0;
      const modulesFenetre = document.getElementById('modulesFenetre').value === 'Oui';
      const etalonnagePortes = document.getElementById('etalonnagePortes').value === 'Oui';
      
      const resultsContainer = document.getElementById('resVMC');
      
      // Vérification du débit minimum requis
      const debitMinRequis = nbBouches * VMC_CONFIG.minDebit;
      const debitConforme = debitMesure >= debitMinRequis;
      const debitMSConforme = debitMS >= VMC_CONFIG.minDebitMS && debitMS <= VMC_CONFIG.maxDebitMS;
      
      // Calcul global de la conformité
      const isConforme = debitConforme && debitMSConforme && modulesFenetre && etalonnagePortes;
      
      // Affichage des résultats
      resultsContainer.innerHTML = `
        <h3>Résultats de la vérification</h3>
        <div class="result-items">
          <div class="result-item ${debitConforme ? 'success' : 'error'}">
            <span class="result-label">Débit total:</span>
            <span class="result-value">${debitMesure} m³/h ${debitConforme ? '✓' : '✗'}</span>
            <span class="result-note">Minimum requis: ${debitMinRequis} m³/h</span>
          </div>
          
          <div class="result-item ${debitMSConforme ? 'success' : 'error'}">
            <span class="result-label">Débit en m/s:</span>
            <span class="result-value">${debitMS} m/s ${debitMSConforme ? '✓' : '✗'}</span>
            <span class="result-note">Plage acceptable: ${VMC_CONFIG.minDebitMS} - ${VMC_CONFIG.maxDebitMS} m/s</span>
          </div>
          
          <div class="result-item ${modulesFenetre ? 'success' : 'error'}">
            <span class="result-label">Modules fenêtres:</span>
            <span class="result-value">${modulesFenetre ? 'Conformes ✓' : 'Non conformes ✗'}</span>
          </div>
          
          <div class="result-item ${etalonnagePortes ? 'success' : 'error'}">
            <span class="result-label">Étalonnage portes:</span>
            <span class="result-value">${etalonnagePortes ? 'Vérifié ✓' : 'Non vérifié ✗'}</span>
          </div>
          
          <div class="result-summary ${isConforme ? 'success' : 'error'}">
            <h4>Conclusion</h4>
            <p>VMC ${isConforme ? 'CONFORME' : 'NON CONFORME'}</p>
            ${!isConforme ? '<p class="error-message">Veuillez corriger les points non conformes</p>' : ''}
          </div>
        </div>
      `;
    }
  }
};