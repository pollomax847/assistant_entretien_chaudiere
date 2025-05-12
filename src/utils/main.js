/**
 * Fichier principal de l'application
 * Initialise les composants et les modules
 */

// Attendre que le DOM soit chargé
document.addEventListener('DOMContentLoaded', () => {
    console.log('Application Chauffage Expert chargée avec succès');
    
    // Initialisation des modules disponibles dans app.js
    if (typeof initializeModules === 'function') {
        initializeModules();
    }
    
    // Initialisation des écouteurs d'événements
    if (typeof initializeEventListeners === 'function') {
        initializeEventListeners();
    }
    
    // Initialisation des préférences
    if (typeof initializePreferences === 'function') {
        initializePreferences();
    }
    
    // Vérification de la version du navigateur et compatibilité
    checkBrowserCompatibility();
});

/**
 * Vérifie la compatibilité du navigateur
 */
function checkBrowserCompatibility() {
    // Liste des fonctionnalités requises
    const requiredFeatures = [
        !!window.localStorage,
        !!window.fetch,
        !!window.Promise,
        !!document.querySelector
    ];
    
    // Vérification de la compatibilité
    const isCompatible = requiredFeatures.every(feature => feature);
    
    if (!isCompatible) {
        console.warn('Votre navigateur pourrait ne pas prendre en charge toutes les fonctionnalités de cette application.');
        
        // Afficher un message à l'utilisateur si nécessaire
        const appContainer = document.querySelector('.app-container');
        if (appContainer) {
            const compatWarning = document.createElement('div');
            compatWarning.className = 'compatibility-warning';
            compatWarning.textContent = 'Votre navigateur pourrait ne pas être compatible avec toutes les fonctionnalités. Veuillez mettre à jour votre navigateur.';
            appContainer.prepend(compatWarning);
        }
    }
}

/**
 * Fonction auxiliaire pour charger dynamiquement des scripts
 * @param {string} url - URL du script à charger
 * @returns {Promise} Promise résolue quand le script est chargé
 */
function loadScript(url) {
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = url;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
}