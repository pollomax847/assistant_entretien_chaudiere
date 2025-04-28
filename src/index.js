import { ModuleManager } from './utils/ModuleManager.js';
import { MODULES, loadFavorites } from './config/constants.js';

// Attendre que le DOM soit chargé
document.addEventListener('DOMContentLoaded', () => {
    // Initialiser le gestionnaire de modules
    const moduleManager = new ModuleManager('module-container');
    
    // Charger les favoris
    window.loadFavorites = loadFavorites;
    
    // Exposer le gestionnaire de modules dans la fenêtre pour le débogage
    window.moduleManager = moduleManager;
    
    // Initialiser la navigation
    initializeNavigation(moduleManager);
    
    // Charger le module par défaut ou à partir de l'URL
    const initialModule = getModuleFromUrl() || '/vmc';
    moduleManager.renderModule(initialModule);
});

// Fonction pour initialiser la navigation
function initializeNavigation(moduleManager) {
    const navigationContainer = document.getElementById('navigation');
    if (!navigationContainer) {
        console.warn('Conteneur de navigation non trouvé.');
        return;
    }
    
    // Générer les liens de navigation
    let navHtml = '<ul class="nav-links">';
    MODULES.forEach(module => {
        navHtml += `<li><a href="#${module.path}" class="nav-link" data-path="${module.path}">${module.title}</a></li>`;
    });
    navHtml += '</ul>';
    
    navigationContainer.innerHTML = navHtml;
    
    // Ajouter les écouteurs d'événements pour la navigation
    const links = navigationContainer.querySelectorAll('.nav-link');
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const path = link.getAttribute('data-path');
            
            // Mettre à jour l'URL pour correspondre au module sélectionné
            window.history.pushState({}, '', `#${path}`);
            
            // Charger le module
            moduleManager.renderModule(path);
            
            // Mettre à jour la navigation active
            setActiveNavLink(path);
        });
    });
    
    // Écouter les changements d'URL
    window.addEventListener('popstate', () => {
        const modulePath = getModuleFromUrl();
        if (modulePath) {
            moduleManager.renderModule(modulePath);
            setActiveNavLink(modulePath);
        }
    });
}

// Mettre à jour le lien de navigation actif
function setActiveNavLink(path) {
    const links = document.querySelectorAll('.nav-link');
    links.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('data-path') === path) {
            link.classList.add('active');
        }
    });
}

// Obtenir le module à partir de l'URL
function getModuleFromUrl() {
    const hash = window.location.hash;
    if (hash && hash.length > 1) {
        const path = hash.substring(1);
        const moduleExists = MODULES.some(m => m.path === path);
        if (moduleExists) {
            return path;
        }
    }
    return null;
}
