// Gestion des préférences utilisateur
document.addEventListener('DOMContentLoaded', () => {
    loadPreferences();
    setupPreferencesForm();
    setupDataManagement();
});

// Chargement des préférences
function loadPreferences() {
    const prefs = JSON.parse(localStorage.getItem('userPreferences')) || {};
    
    // Remplir le formulaire avec les préférences existantes
    document.getElementById('technician-name').value = prefs.technicianName || '';
    document.getElementById('theme').value = prefs.theme || 'light';
    document.getElementById('temperature-unit').value = prefs.temperatureUnit || 'celsius';
    document.getElementById('default-module').value = prefs.defaultModule || 'module-puissance-chauffage';
    document.getElementById('auto-save').checked = prefs.autoSave || false;
    document.getElementById('offline-mode').checked = prefs.offlineMode || false;
    
    // Charger le logo de l'entreprise
    if (prefs.companyLogo) {
        document.getElementById('logo-preview').innerHTML = `
            <img src="${prefs.companyLogo}" alt="Logo entreprise" style="max-width: 200px;">
        `;
    }
    
    // Appliquer le thème
    applyTheme(prefs.theme);
}

// Configuration du formulaire de préférences
function setupPreferencesForm() {
    const form = document.getElementById('preferences-form');
    if (!form) return;
    
    // Gestion de la soumission du formulaire
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        savePreferences();
    });
    
    // Gestion du changement de thème
    document.getElementById('theme').addEventListener('change', (e) => {
        applyTheme(e.target.value);
    });
    
    // Gestion du logo de l'entreprise
    document.getElementById('company-logo').addEventListener('change', handleLogoUpload);
}

// Sauvegarde des préférences
function savePreferences() {
    const prefs = {
        technicianName: document.getElementById('technician-name').value,
        theme: document.getElementById('theme').value,
        temperatureUnit: document.getElementById('temperature-unit').value,
        defaultModule: document.getElementById('default-module').value,
        autoSave: document.getElementById('auto-save').checked,
        offlineMode: document.getElementById('offline-mode').checked,
        companyLogo: localStorage.getItem('companyLogo')
    };
    
    localStorage.setItem('userPreferences', JSON.stringify(prefs));
    
    // Afficher un message de confirmation
    showNotification('Préférences sauvegardées avec succès', 'success');
}

// Application du thème
function applyTheme(theme) {
    document.body.classList.remove('theme-light', 'theme-dark');
    document.body.classList.add(`theme-${theme}`);
}

// Gestion du logo de l'entreprise
function handleLogoUpload(e) {
    const file = e.target.files[0];
    if (!file) return;
    
    const reader = new FileReader();
    reader.onload = (e) => {
        const logoPreview = document.getElementById('logo-preview');
        logoPreview.innerHTML = `
            <img src="${e.target.result}" alt="Logo entreprise" style="max-width: 200px;">
        `;
        localStorage.setItem('companyLogo', e.target.result);
    };
    reader.readAsDataURL(file);
}

// Gestion des données
function setupDataManagement() {
    // Export des données
    document.getElementById('export-data').addEventListener('click', exportData);
    
    // Import des données
    document.getElementById('import-data').addEventListener('click', importData);
    
    // Effacement des données
    document.getElementById('clear-data').addEventListener('click', clearData);
}

// Export des données
function exportData() {
    const data = {
        preferences: JSON.parse(localStorage.getItem('userPreferences')),
        modules: {}
    };
    
    // Récupérer les données de tous les modules
    for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key.startsWith('module_')) {
            data.modules[key] = JSON.parse(localStorage.getItem(key));
        }
    }
    
    // Créer et télécharger le fichier
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'chauffage-expert-data.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// Import des données
function importData() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    
    input.onchange = (e) => {
        const file = e.target.files[0];
        const reader = new FileReader();
        
        reader.onload = (e) => {
            try {
                const data = JSON.parse(e.target.result);
                
                // Restaurer les préférences
                if (data.preferences) {
                    localStorage.setItem('userPreferences', JSON.stringify(data.preferences));
                }
                
                // Restaurer les données des modules
                if (data.modules) {
                    Object.entries(data.modules).forEach(([key, value]) => {
                        localStorage.setItem(key, JSON.stringify(value));
                    });
                }
                
                showNotification('Données importées avec succès', 'success');
                loadPreferences(); // Recharger les préférences
            } catch (error) {
                showNotification('Erreur lors de l\'import des données', 'error');
                console.error(error);
            }
        };
        
        reader.readAsText(file);
    };
    
    input.click();
}

// Effacement des données
function clearData() {
    if (confirm('Êtes-vous sûr de vouloir effacer toutes les données ? Cette action est irréversible.')) {
        localStorage.clear();
        showNotification('Toutes les données ont été effacées', 'success');
        loadPreferences(); // Recharger les préférences
    }
}

// Affichage des notifications
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
} 