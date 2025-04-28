export class PuissanceChauffageModule {
    constructor() {
        this.form = document.getElementById('puissance-chauffage-form');
        this.resultContainer = document.getElementById('puissance-result');
        this.initializeEventListeners();
    }

    initializeEventListeners() {
        this.form.addEventListener('submit', (e) => {
            e.preventDefault();
            this.calculate();
        });
    }

    calculate() {
        const surface = parseFloat(document.getElementById('surface').value);
        const hauteur = parseFloat(document.getElementById('hauteur').value);
        const tempInt = parseFloat(document.getElementById('temp-int').value);
        const tempExt = parseFloat(document.getElementById('temp-ext').value);
        const coefficientG = parseFloat(document.getElementById('coefficient-g').value);

        if (isNaN(surface) || isNaN(hauteur) || isNaN(tempInt) || isNaN(tempExt) || isNaN(coefficientG)) {
            this.showError('Veuillez remplir tous les champs avec des valeurs numériques valides');
            return;
        }

        const volume = surface * hauteur;
        const deltaT = tempInt - tempExt;
        const puissance = volume * coefficientG * deltaT;

        this.displayResult(puissance);
    }

    displayResult(puissance) {
        const resultHtml = `
            <div class="result-card">
                <h3>Résultat du calcul</h3>
                <div class="result-value">
                    <span class="label">Puissance nécessaire :</span>
                    <span class="value">${puissance.toFixed(2)} W</span>
                </div>
                <div class="result-details">
                    <p>Cette puissance est calculée pour :</p>
                    <ul>
                        <li>Une surface de ${document.getElementById('surface').value} m²</li>
                        <li>Une hauteur sous plafond de ${document.getElementById('hauteur').value} m</li>
                        <li>Une température intérieure de ${document.getElementById('temp-int').value}°C</li>
                        <li>Une température extérieure de base de ${document.getElementById('temp-ext').value}°C</li>
                        <li>Un coefficient G de ${document.getElementById('coefficient-g').value}</li>
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
            const response = await fetch('/api/PuissanceChauffage/Save', {
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
            const response = await fetch('/api/PuissanceChauffage/ExportPdf', {
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
                a.download = 'calcul_puissance_chauffage.pdf';
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
            surface: document.getElementById('surface').value,
            hauteur: document.getElementById('hauteur').value,
            tempInt: document.getElementById('temp-int').value,
            tempExt: document.getElementById('temp-ext').value,
            coefficientG: document.getElementById('coefficient-g').value
        };
    }
} 