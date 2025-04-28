export class VaseExpansionModule {
    constructor() {
        this.form = document.getElementById('vase-expansion-form');
        this.resultContainer = document.getElementById('resVase');
        this.vaseImage = document.getElementById('vaseImage');
        this.pressionVase = document.getElementById('pressionVase');
        this.initializeEventListeners();
    }

    initializeEventListeners() {
        document.getElementById('calculerVase').addEventListener('click', () => {
            this.calculate();
        });
    }

    calculate() {
        const hauteurBatiment = parseFloat(document.getElementById('hauteurBatiment').value);
        const radiateurPlusLoin = document.getElementById('radiateurPlusLoin').value;

        if (isNaN(hauteurBatiment)) {
            this.showError('Veuillez entrer une hauteur valide');
            return;
        }

        // Calcul de la pression théorique
        let pression = (hauteurBatiment / 10) + 0.3;

        // Ajout de 0.2 bar si le radiateur le plus éloigné est au dernier étage
        if (radiateurPlusLoin === 'oui') {
            pression += 0.2;
        }

        // Arrondir à 0.5 près
        pression = Math.round(pression * 2) / 2;

        this.displayResult(pression);
        this.updateVaseAnimation(pression);
    }

    displayResult(pression) {
        const resultHtml = `
            <div class="result-card">
                <h3>Résultat du calcul</h3>
                <div class="result-value">
                    <span class="label">Pression théorique :</span>
                    <span class="value">${pression.toFixed(1)} bar</span>
                </div>
                <div class="result-details">
                    <p>Cette pression est calculée pour :</p>
                    <ul>
                        <li>Une hauteur de bâtiment de ${document.getElementById('hauteurBatiment').value} m</li>
                        <li>Radiateur le plus éloigné : ${document.getElementById('radiateurPlusLoin').value === 'oui' ? 'au dernier étage' : 'ailleurs'}</li>
                    </ul>
                </div>
                <div class="safety-notes">
                    <h4>Notes de sécurité :</h4>
                    <ul>
                        <li>Vérifier toujours la pression à froid avant intervention</li>
                        <li>Ne jamais dépasser la pression maximale indiquée sur le vase</li>
                        <li>Contrôler l'état du manomètre avant toute manipulation</li>
                        <li>Vérifier l'absence de fuites après réglage</li>
                    </ul>
                </div>
                <div class="result-actions">
                    <button class="btn-secondary" onclick="this.module.saveResult()">Sauvegarder</button>
                    <button class="btn-primary" onclick="this.module.exportPdf()">Exporter en PDF</button>
                </div>
            </div>
        `;

        this.resultContainer.innerHTML = resultHtml;
    }

    updateVaseAnimation(pression) {
        // Mise à jour de l'affichage de la pression
        this.pressionVase.textContent = `${pression.toFixed(1)} bar`;

        // Animation du vase en fonction de la pression
        const scale = 1 + (pression * 0.1); // Ajuster l'échelle en fonction de la pression
        this.vaseImage.style.transform = `scale(${scale})`;
    }

    showError(message) {
        this.resultContainer.innerHTML = `
            <div class="error-card">
                <h3>Erreur</h3>
                <p>${message}</p>
            </div>
        `;
    }

    async saveResult() {
        const formData = this.getFormData();
        try {
            const response = await fetch('/api/VaseExpansion/Save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (response.ok) {
                alert('Résultat sauvegardé avec succès');
            }
        } catch (error) {
            console.error('Erreur lors de la sauvegarde:', error);
        }
    }

    async exportPdf() {
        const formData = this.getFormData();
        try {
            const response = await fetch('/api/VaseExpansion/ExportPdf', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (response.ok) {
                const blob = await response.blob();
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'calcul_vase_expansion.pdf';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            }
        } catch (error) {
            console.error('Erreur lors de l\'export PDF:', error);
        }
    }

    getFormData() {
        return {
            hauteurBatiment: document.getElementById('hauteurBatiment').value,
            radiateurPlusLoin: document.getElementById('radiateurPlusLoin').value
        };
    }
} 