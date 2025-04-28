export class PreferencesModule {
    constructor() {
        this.form = document.getElementById('preferences-form');
        this.initializeEventListeners();
        this.loadPreferences();
    }

    initializeEventListeners() {
        // Gestionnaire pour le logo de l'entreprise
        document.getElementById('company-logo').addEventListener('change', (e) => {
            this.handleLogoUpload(e.target.files[0]);
        });

        // Gestionnaire pour l'export des données
        document.getElementById('export-data').addEventListener('click', () => {
            this.exportData();
        });

        // Gestionnaire pour l'import des données
        document.getElementById('import-data').addEventListener('click', () => {
            this.importData();
        });

        // Gestionnaire pour l'effacement des données
        document.getElementById('clear-data').addEventListener('click', () => {
            if (confirm('Êtes-vous sûr de vouloir effacer toutes les données ?')) {
                this.clearData();
            }
        });

        // Gestionnaire pour la soumission du formulaire
        this.form.addEventListener('submit', (e) => {
            e.preventDefault();
            this.savePreferences();
        });
    }

    async loadPreferences() {
        try {
            const response = await fetch('/api/Preferences/Get');
            if (response.ok) {
                const preferences = await response.json();
                this.populateForm(preferences);
            }
        } catch (error) {
            console.error('Erreur lors du chargement des préférences:', error);
        }
    }

    populateForm(preferences) {
        document.getElementById('technician-name').value = preferences.technicianName || '';
        document.getElementById('theme').value = preferences.theme || 'light';
        document.getElementById('temperature-unit').value = preferences.temperatureUnit || 'celsius';
        document.getElementById('default-module').value = preferences.defaultModule || '';
        document.getElementById('auto-save').checked = preferences.autoSave || false;
        document.getElementById('offline-mode').checked = preferences.offlineMode || false;

        if (preferences.companyLogo) {
            const logoPreview = document.getElementById('logo-preview');
            logoPreview.style.backgroundImage = `url(${preferences.companyLogo})`;
        }
    }

    async savePreferences() {
        const formData = this.getFormData();
        try {
            const response = await fetch('/api/Preferences/Save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            if (response.ok) {
                alert('Préférences sauvegardées avec succès');
            }
        } catch (error) {
            console.error('Erreur lors de la sauvegarde des préférences:', error);
        }
    }

    async handleLogoUpload(file) {
        const formData = new FormData();
        formData.append('logo', file);

        try {
            const response = await fetch('/api/Preferences/UploadLogo', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                const result = await response.json();
                const logoPreview = document.getElementById('logo-preview');
                logoPreview.style.backgroundImage = `url(${result.logoUrl})`;
            }
        } catch (error) {
            console.error('Erreur lors de l\'upload du logo:', error);
        }
    }

    async exportData() {
        try {
            const response = await fetch('/api/Preferences/ExportData');
            if (response.ok) {
                const blob = await response.blob();
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'preferences_backup.json';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            }
        } catch (error) {
            console.error('Erreur lors de l\'export des données:', error);
        }
    }

    async importData() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json';
        
        input.onchange = async (e) => {
            const file = e.target.files[0];
            const formData = new FormData();
            formData.append('file', file);

            try {
                const response = await fetch('/api/Preferences/ImportData', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    alert('Données importées avec succès');
                    this.loadPreferences();
                }
            } catch (error) {
                console.error('Erreur lors de l\'import des données:', error);
            }
        };

        input.click();
    }

    async clearData() {
        try {
            const response = await fetch('/api/Preferences/ClearData', {
                method: 'POST'
            });

            if (response.ok) {
                alert('Données effacées avec succès');
                this.loadPreferences();
            }
        } catch (error) {
            console.error('Erreur lors de l\'effacement des données:', error);
        }
    }

    getFormData() {
        return {
            technicianName: document.getElementById('technician-name').value,
            theme: document.getElementById('theme').value,
            temperatureUnit: document.getElementById('temperature-unit').value,
            defaultModule: document.getElementById('default-module').value,
            autoSave: document.getElementById('auto-save').checked,
            offlineMode: document.getElementById('offline-mode').checked
        };
    }
} 