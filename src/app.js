import { FIREBASE_CONFIG } from './config/constants.js';
import { ModuleManager } from './utils/ModuleManager.js';

// Initialisation de Firebase
const app = firebase.initializeApp(FIREBASE_CONFIG);
const analytics = firebase.analytics();
const auth = firebase.auth();
const db = firebase.firestore();

// Gestion de l'authentification
auth.onAuthStateChanged((user) => {
    const userInfo = document.getElementById('userInfo');
    const userName = document.getElementById('userName');
    const logoutBtn = document.getElementById('logoutBtn');

    if (user) {
        userName.textContent = user.email;
        userInfo.style.display = 'block';
        logoutBtn.addEventListener('click', () => auth.signOut());
    } else {
        window.location.href = '/auth.html';
    }
});

// Initialisation de l'application
document.addEventListener('DOMContentLoaded', () => {
    console.log('Application initialisée');
    
    // S'assurer que les modules sont initialisés
    window.modules = window.modules || {};
    
    // Initialiser le gestionnaire de modules
    const moduleManager = new window.ModuleManager('module-container');
    
    // Initialiser la navigation
    initializeNavigation(moduleManager);
    
    // Charger le module par défaut ou à partir de l'URL
    const initialModule = getModuleFromUrl() || (window.APP_CONFIG ? window.APP_CONFIG.defaultModule : '/vmc');
    moduleManager.renderModule(initialModule);
});

// Fonction pour initialiser la navigation
function initializeNavigation(moduleManager) {
    const navigationContainer = document.getElementById('navigation');
    if (!navigationContainer) {
        console.warn('Conteneur de navigation non trouvé.');
        return;
    }
    
    // Récupérer les modules disponibles
    const modules = window.MODULES || [];
    
    // Générer les liens de navigation
    let navHtml = '<ul class="nav-links">';
    modules.forEach(module => {
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
            window.location.hash = path;
            
            // Charger le module
            moduleManager.renderModule(path);
            
            // Mettre à jour la navigation active
            setActiveNavLink(path);
        });
    });
    
    // Écouter les changements d'URL
    window.addEventListener('hashchange', () => {
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
        return hash.substring(1);
    }
    return null;
}