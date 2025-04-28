export class VmcModule {
    constructor() {
        this.form = document.getElementById('vmc-form');
        this.resultContainer = document.getElementById('vmc-result');
        this.initializeEventListeners();
    }

    initializeEventListeners() {
        if (this.form) {
            this.form.addEventListener('submit', (e) => this.handleSubmit(e));
        }
    }

    async handleSubmit(e) {
        e.preventDefault();
        const formData = this.getFormData();
        
        try {
            const response = await fetch('/api/vmc/calculer', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) {
                throw new Error('Erreur lors du calcul des débits VMC');
            }

            const result = await response.json();
            this.displayResult(result);
        } catch (error) {
            this.showError(error.message);
        }
    }

    getFormData() {
        return {
            surface: parseFloat(this.form.querySelector('#surface').value),
            cuisine: this.form.querySelector('#cuisine').checked,
            salleDeBain: this.form.querySelector('#salleDeBain').checked,
            wc: this.form.querySelector('#wc').checked,
            nombrePieces: parseInt(this.form.querySelector('#nombrePieces').value)
        };
    }

    displayResult(result) {
        this.resultContainer.innerHTML = `
            <div class="result-card">
                <h3>Résultats du calcul VMC</h3>
                <div class="result-grid">
                    <div class="result-item">
                        <span class="label">Débit total :</span>
                        <span class="value">${result.debitTotal.toFixed(2)} m³/h</span>
                    </div>
                    <div class="result-item">
                        <span class="label">Débit cuisine :</span>
                        <span class="value">${result.debitCuisine.toFixed(2)} m³/h</span>
                    </div>
                    <div class="result-item">
                        <span class="label">Débit salle de bain :</span>
                        <span class="value">${result.debitSalleDeBain.toFixed(2)} m³/h</span>
                    </div>
                    <div class="result-item">
                        <span class="label">Débit WC :</span>
                        <span class="value">${result.debitWc.toFixed(2)} m³/h</span>
                    </div>
                </div>
                <div class="result-actions">
                    <button class="btn btn-primary" onclick="vmcModule.saveResult()">
                        <i class="fas fa-save"></i> Sauvegarder
                    </button>
                    <button class="btn btn-secondary" onclick="vmcModule.exportPdf()">
                        <i class="fas fa-file-pdf"></i> Exporter en PDF
                    </button>
                </div>
            </div>
        `;
    }

    showError(message) {
        this.resultContainer.innerHTML = `
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <p>${message}</p>
            </div>
        `;
    }

    async saveResult() {
        try {
            const formData = this.getFormData();
            const response = await fetch('/api/vmc/sauvegarder', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) {
                throw new Error('Erreur lors de la sauvegarde');
            }

            showNotification('Résultats sauvegardés avec succès', 'success');
        } catch (error) {
            showNotification(error.message, 'error');
        }
    }

    async exportPdf() {
        try {
            const formData = this.getFormData();
            const response = await fetch('/api/vmc/export-pdf', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) {
                throw new Error('Erreur lors de la génération du PDF');
            }

            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'calcul_vmc.pdf';
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);
        } catch (error) {
            showNotification(error.message, 'error');
        }
    }
}

// Initialisation du module
const vmcModule = new VmcModule(); 