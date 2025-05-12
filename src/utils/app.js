// Import the constants from the loader
import { APP_CONFIG, MODULES, CONSTANTS } from '/src/config/constants-loader.js';

// Configuration initiale
document.addEventListener('DOMContentLoaded', () => {
    const appContainer = document.querySelector('.app-container');
    
    // Initialize modules and UI
    try {
        initializeModules();
    } catch (e) {
        console.log('Erreur lors de l\'initialisation des modules:', e);
    }
    
    try {
        initializeEventListeners();
    } catch (e) {
        console.log('Erreur lors de l\'initialisation des écouteurs d\'événements:', e);
    }
    
    // Check sidebar state
    if (localStorage.getItem('sidebarHidden') === 'true' && appContainer) {
        appContainer.classList.add('sidebar-hidden');
    }
    
    // Initialize other components
    try {
        updateOnlineStatus();
    } catch (e) {
        console.log('Erreur lors de la mise à jour du statut de connexion:', e);
    }

    try {
        loadFavorites();
    } catch (e) {
        console.log('Erreur lors du chargement des favoris:', e);
    }

    // Initialize general listeners
    try {
        initGeneralListeners();
    } catch (e) {
        console.log('Erreur lors de l\'initialisation des écouteurs généraux:', e);
    }

    // Log initialization pour débugger
    console.log('Chauffage Expert: Initialization complete');
});

// Configuration des modules - access from window object
const modules = window.MODULES || [];

// Initialisation de l'application
function initializeModules() {
    // Mise en place de la navigation
    modules.forEach(module => {
        try {
            const moduleLink = document.createElement('a');
            moduleLink.href = `#${module.id}`;
            moduleLink.innerHTML = `
                <img src="${module.icon}" alt="${module.title}" />
                <span>${module.title}</span>
            `;
            moduleLink.addEventListener('click', e => {
                e.preventDefault();
                loadModule(module.id);
            });

            const moduleItem = document.createElement('li');
            moduleItem.appendChild(moduleLink);
            
            const sidebar = document.querySelector('.sidebar-nav ul');
            if (sidebar) {
                sidebar.appendChild(moduleItem);
            } else {
                console.warn('Élément sidebar-nav non trouvé dans le DOM');
            }
        } catch (err) {
            console.error(`Erreur lors de la création du module ${module.id}:`, err);
        }
    });

    // Chargement du module par défaut
    const defaultModule = window.APP_CONFIG?.defaultModule || (modules.length > 0 ? modules[0].id : null);
    if (defaultModule) {
        loadModule(defaultModule);
    }
}

// Gestionnaires d'événements
function initializeEventListeners() {
    // Navigation
    const sidebarNavLinks = document.querySelectorAll('.sidebar-nav a');
    if (sidebarNavLinks.length > 0) {
        sidebarNavLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const moduleId = e.currentTarget.getAttribute('href')?.substring(1);
                if (moduleId) {
                    loadModule(moduleId);
                }
            });
        });
    } else {
        console.warn('Éléments sidebar-nav a non trouvés dans le DOM');
    }
    
    // Déconnexion
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    } else {
        console.warn('Élément logoutBtn non trouvé dans le DOM');
    }
    
    // Recherche
    const searchInput = document.getElementById('search-modules');
    if (searchInput) {
        searchInput.addEventListener('input', handleSearch);
    } else {
        console.warn('Élément search-modules non trouvé dans le DOM');
    }

    // Gestion du basculement du menu
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appContainer = document.querySelector('.app-container');

    if (sidebarToggle && appContainer) {
        sidebarToggle.addEventListener('click', () => {
            appContainer.classList.toggle('sidebar-hidden');
            
            // Sauvegarder l'état du menu dans le localStorage
            const isHidden = appContainer.classList.contains('sidebar-hidden');
            localStorage.setItem('sidebarHidden', isHidden);
        });
    } else {
        console.warn('Éléments sidebarToggle ou appContainer non trouvés dans le DOM');
    }
}

// Gestion de la connexion
function updateOnlineStatus() {
    const statusIndicator = document.getElementById('status-indicator');
    
    // Vérification si l'élément existe avant de l'utiliser
    if (statusIndicator) {
        if (navigator.onLine) {
            statusIndicator.classList.add('status-online');
            statusIndicator.classList.remove('status-offline');
            statusIndicator.title = 'Connecté';
        } else {
            statusIndicator.classList.add('status-offline');
            statusIndicator.classList.remove('status-online');
            statusIndicator.title = 'Hors ligne';
        }
    } else {
        console.warn("Élément 'status-indicator' non trouvé dans le DOM");
    }
    
    // Ajout d'événements pour mettre à jour le statut lorsque la connectivité change
    window.addEventListener('online', updateOnlineStatus);
    window.addEventListener('offline', updateOnlineStatus);
}

// Chargement des modules - Utiliser fetch avec l'URL relative (cela fonctionnera avec Vite)
function loadModule(moduleId) {
    console.log('Tentative de chargement du module:', moduleId);
    const contentContainer = document.getElementById('content');
    if (!contentContainer) {
        console.error("Conteneur de contenu non trouvé");
        return;
    }

    // Afficher un indicateur de chargement
    contentContainer.innerHTML = '<div class="loading">Chargement...</div>';

    // Trouver le chemin du module
    const moduleConfig = modules.find(m => m.id === moduleId);
    if (!moduleConfig) {
        contentContainer.innerHTML = '<div class="error">Module non trouvé</div>';
        console.error("Module non trouvé:", moduleId);
        return;
    }

    // Utiliser un chemin absolu par rapport à la racine du projet
    const modulePath = moduleId.includes('module-') 
        ? `/modules/${moduleId.replace('module-', '')}/index.html`
        : `/modules/${moduleId}/index.html`;

    // Utiliser fetch avec une gestion d'erreur robuste
    fetch(modulePath)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.text();
        })
        .then(html => {
            contentContainer.innerHTML = html;
            console.log(`Module ${moduleId} chargé avec succès`);
            
            // Initialiser les écouteurs d'événements spécifiques au module
            initializeModule(moduleId);
        })
        .catch(error => {
            console.error(`Erreur lors du chargement du module: ${moduleId}`, error);
            contentContainer.innerHTML = `
                <div class="error">
                    <h2>Erreur de chargement du module</h2>
                    <p>Impossible de charger le module "${moduleConfig.title}".</p>
                    <p>Détail de l'erreur: ${error.message}</p>
                    <button class="btn-retry" onclick="window.loadModule('${moduleId}')">Réessayer</button>
                </div>
            `;
        });
}

// Initialise les écouteurs d'événements généraux
function initGeneralListeners() {
    // Navigation fluide pour les ancres
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return; // Ignore empty anchors
            
            const target = document.querySelector(targetId);
            if (target) {
                e.preventDefault();
                window.scrollTo({
                    top: target.offsetTop - 100,
                    behavior: 'smooth'
                });
            }
        });
    });

    // Gestion du type d'émetteur (si présent)
    const radioEmetteurs = document.querySelectorAll('input[name="typeEmetteur"]');
    if (radioEmetteurs.length > 0) {
        radioEmetteurs.forEach(radio => {
            radio.addEventListener('change', function() {
                const radiateurParams = document.getElementById('radiateur-params');
                const plancherParams = document.getElementById('plancher-params');
                
                if (radiateurParams) {
                    radiateurParams.style.display = this.value === 'radiateur' ? 'block' : 'none';
                }
                
                if (plancherParams) {
                    plancherParams.style.display = this.value === 'plancher' ? 'block' : 'none';
                }
                
                // Appeler calcule si elle existe
                if (typeof calcule === 'function') {
                    calcule();
                }
            });
        });
    }

    // Gestion de l'affichage dark/light mode
    const themeToggler = document.getElementById('theme-toggle');
    if (themeToggler) {
        themeToggler.addEventListener('click', () => {
            document.body.classList.toggle('dark-mode');
            const isDark = document.body.classList.contains('dark-mode');
            localStorage.setItem('darkMode', isDark);
        });
        
        // Appliquer le thème stocké
        if (localStorage.getItem('darkMode') === 'true') {
            document.body.classList.add('dark-mode');
        }
    }
}

// Initialisation d'un module
function initializeModule(moduleId) {
    // Appeler les initialiseurs spécifiques en fonction de l'ID du module
    switch (moduleId) {
        case 'module-puissance-chauffage':
            if (typeof initializePuissanceChauffage === 'function') {
                initializePuissanceChauffage();
            }
            break;
        case 'module-vase-expansion':
            if (typeof initializeVaseExpansion === 'function') {
                initializeVaseExpansion();
            }
            break;
        case 'module-vmc':
            if (typeof initializeVMC === 'function') {
                initializeVMC();
            }
            break;
        // Ajoutez d'autres cas selon vos modules...
    }
    
    // Attacher des gestionnaires d'événements génériques aux éléments du module
    document.querySelectorAll('input, select').forEach(input => {
        if (input.type === 'checkbox') {
            input.addEventListener('change', event => {
                if (typeof calcule === 'function') {
                    calcule(event);
                }
            });
        } else {
            input.addEventListener('input', event => {
                if (typeof calcule === 'function') {
                    calcule(event);
                }
            });
        }
    });
}

// Gestion des favoris
function loadFavorites() {
    try {
        // Utiliser une variable pour stocker les favoris plutôt que de rappeler la fonction
        const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
        return favorites;
    } catch (error) {
        console.error('Erreur lors du chargement des favoris:', error);
        return [];
    }
}

// Fonction de déconnexion (définition de base)
function handleLogout() {
    console.log('Déconnexion demandée');
    // Implémentation à compléter selon les besoins
    localStorage.removeItem('user');
    window.location.href = './login.html';
}

// Fonction de recherche (définition de base)
function handleSearch(event) {
    const searchTerm = event.target.value.toLowerCase();
    const moduleElements = document.querySelectorAll('.sidebar-nav li a');
    
    moduleElements.forEach(item => {
        const text = item.textContent.toLowerCase();
        if (text.includes(searchTerm)) {
            item.parentElement.style.display = '';
        } else {
            item.parentElement.style.display = 'none';
        }
    });
}

/**
 * Vérifie la cohérence de la puissance calculée pour les radiateurs
 * @param {number} puissance - Puissance calculée en watts
 * @param {number} surface - Surface du radiateur en m²
 * @param {string} type - Type de radiateur
 * @returns {object} - Résultat de la vérification avec message si incohérence
 */
function verifierCohérencePuissance(puissance, surface, type) {
    // Vérification de la cohérence entre la puissance et la surface
    const puissanceParM2 = puissance / surface;
    
    // Valeurs de référence pour la puissance par m² selon le type d'émetteur
    const references = {
        'radiateur': { min: 50, max: 150 },
        'plancher': { min: 30, max: 100 }
    };
    
    const ref = references[type] || references.radiateur;
    
    if (puissanceParM2 < ref.min) {
        return {
            valide: false,
            message: `La puissance est trop faible (${Math.round(puissanceParM2)} W/m²). Minimum recommandé: ${ref.min} W/m²`
        };
    }
    
    if (puissanceParM2 > ref.max) {
        return {
            valide: false,
            message: `La puissance est trop élevée (${Math.round(puissanceParM2)} W/m²). Maximum recommandé: ${ref.max} W/m²`
        };
    }
    
    return {
        valide: true,
        message: `Puissance correcte (${Math.round(puissanceParM2)} W/m²)`
    };
}

/**
 * Calcule la puissance d'un radiateur en fonction de ses dimensions et de son type
 */
function calculPuissanceRadiateur() {
    // ...existing code...
    
    // Remplacer l'appel incorrect à verifierCohérencePuissance par verifierCoherencePuissance
    const verification = verifierCohérencePuissance(puissance, surface, type);
    
    // Afficher un avertissement si la puissance n'est pas cohérente
    if (!verification.coherent) {
        document.getElementById("resRadiateur").innerHTML +=
            `<p class="warning">${verification.message}</p>`;
    }
    
    // ...existing code...
}

/**
 * Vérifie la cohérence globale des calculs de radiateurs
 */
function verifierCoherenceGlobale() {
    // ...existing code...
    
    // Remplacer l'appel incorrect à verifierCohérencePuissance par verifierCoherencePuissance
    const verification = verifierCohérencePuissance(puissanceTotale, surfaceTotale, "mixed");
    
    // ...existing code...
}

// Expose necessary functions to window object for use in HTML
window.loadModule = loadModule;
window.handleLogout = handleLogout;
window.initializeModule = initializeModule;
window.verifierCohérencePuissance = verifierCohérencePuissance;
window.calcule = function() {
    console.log("Fonction calcule appelée mais pas encore implémentée");
};