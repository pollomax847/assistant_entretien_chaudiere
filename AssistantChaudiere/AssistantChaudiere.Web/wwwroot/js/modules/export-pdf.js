export class ExportPdfModule {
    constructor() {
        this.form = document.getElementById('export-pdf-form');
        this.signaturePad = new SignaturePad(document.getElementById('signature-pad'));
        this.initializeEventListeners();
    }

    initializeEventListeners() {
        // Gestionnaire pour effacer la signature
        document.getElementById('clear-signature').addEventListener('click', () => {
            this.signaturePad.clear();
        });

        // Gestionnaire pour la prévisualisation
        document.getElementById('preview-pdf').addEventListener('click', () => {
            this.previewPdf();
        });

        // Gestionnaire pour la soumission du formulaire
        this.form.addEventListener('submit', (e) => {
            e.preventDefault();
            this.generatePdf();
        });
    }

    async previewPdf() {
        const formData = this.getFormData();
        try {
            const response = await fetch('/api/ExportPdf/Preview', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (response.ok) {
                const blob = await response.blob();
                const url = URL.createObjectURL(blob);
                const previewFrame = document.getElementById('preview-frame');
                previewFrame.src = url;
                document.getElementById('pdf-preview').classList.remove('hidden');
            }
        } catch (error) {
            console.error('Erreur lors de la prévisualisation:', error);
        }
    }

    async generatePdf() {
        const formData = this.getFormData();
        try {
            const response = await fetch('/api/ExportPdf/Generate', {
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
                a.download = `rapport_${formData.clientName}_${formData.interventionDate}.pdf`;
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            }
        } catch (error) {
            console.error('Erreur lors de la génération du PDF:', error);
        }
    }

    getFormData() {
        const selectedModules = Array.from(document.querySelectorAll('input[name="modules"]:checked'))
            .map(checkbox => checkbox.value);

        return {
            clientName: document.getElementById('client-name').value,
            clientAddress: document.getElementById('client-address').value,
            interventionDate: document.getElementById('intervention-date').value,
            interventionType: document.getElementById('intervention-type').value,
            modules: selectedModules,
            observations: document.getElementById('observations').value,
            signature: this.signaturePad.toDataURL()
        };
    }
} 