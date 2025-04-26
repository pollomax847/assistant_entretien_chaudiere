// Configuration initiale
document.addEventListener('DOMContentLoaded', () => {
    const appContainer = document.querySelector('.app-container');
    
    // Initialize modules and UI
    initializeModules();
    initializeEventListeners();
    initializePreferences();
    
    // Check sidebar state
    if (localStorage.getItem('sidebarHidden') === 'true' && appContainer) {
        appContainer.classList.add('sidebar-hidden');
    }
    
    // Initialize other components
    updateOnlineStatus();
    loadFavorites();
});

// Configuration des modules
const modules = [
    {
        id: 'module-puissance-chauffage',
        title: 'Puissance Chauffage',
        icon: '/assets/icons/calculator.svg',
        description: 'Calcul de la puissance de chauffage nécessaire'
    },
    {
        id: 'module-vase-expansion',
        title: 'Vase d\'Expansion',
        icon: '/assets/icons/water.svg',
        description: 'Calcul et vérification du vase d\'expansion'
    },
    {
        id: 'module-equilibrage',
        title: 'Équilibrage Réseau',
        icon: '/assets/icons/balance.svg',
        description: 'Calculs d\'équilibrage du réseau de chauffage'
    },
    {
        id: 'module-radiateurs',
        title: 'Radiateurs',
        icon: '/assets/icons/radiator.svg',
        description: 'Calculs et vérifications des radiateurs'
    },
    {
        id: 'module-ecs',
        title: 'ECS Instantané',
        icon: '/assets/icons/water-drop.svg',
        description: 'Calculs pour l\'eau chaude sanitaire'
    },
    {
        id: 'module-top-gaz',
        title: 'Top Compteur Gaz',
        icon: '/assets/icons/gas.svg',
        description: 'Vérification des compteurs de gaz'
    },
    {
        id: 'module-vmc',
        title: 'VMC',
        icon: '/assets/icons/ventilation.svg',
        description: 'Calculs pour la ventilation mécanique'
    },
    {
        id: 'module-reglementation-gaz',
        title: 'Réglementation Gaz',
        icon: '/assets/icons/rules.svg',
        description: 'Vérifications réglementaires gaz'
    },
    {
        id: 'module-reglementaires-comp',
        title: 'Autres Vérifications',
        icon: '/assets/icons/compliance.svg',
        description: 'Vérifications réglementaires diverses'
    },
    {
        id: 'module-export-pdf',
        title: 'Export PDF',
        icon: '/assets/icons/pdf.svg',
        description: 'Génération de rapports PDF'
    },
    {
        id: 'module-preferences',
        title: 'Préférences',
        icon: '/assets/icons/settings.svg',
        description: 'Configuration de l\'application'
    }
];

// Initialisation de l'application
function initializeModules() {
    // Vérification de la connexion
    updateOnlineStatus();
    
    // Chargement des modules
    loadModule('module-puissance-chauffage');
    
    // Configuration de la recherche
    setupSearch();
}

// Gestionnaires d'événements
function initializeEventListeners() {
    // Navigation
    document.querySelectorAll('.sidebar-nav a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const moduleId = e.currentTarget.getAttribute('href').substring(1);
            loadModule(moduleId);
        });
    });
    
    // Déconnexion
    document.getElementById('logoutBtn').addEventListener('click', handleLogout);
    
    // Recherche
    document.getElementById('search-modules').addEventListener('input', handleSearch);

    // Gestion du basculement du menu
    const sidebarToggle = document.getElementById('sidebarToggle');
    const appContainer = document.querySelector('.app-container');

    sidebarToggle.addEventListener('click', () => {
        appContainer.classList.toggle('sidebar-hidden');
        
        // Sauvegarder l'état du menu dans le localStorage
        const isHidden = appContainer.classList.contains('sidebar-hidden');
        localStorage.setItem('sidebarHidden', isHidden);
    });
}

// Gestion de la connexion
function updateOnlineStatus() {
    const statusIndicator = document.getElementById('status-indicator');
    if (navigator.onLine) {
        statusIndicator.classList.add('status-online');
        statusIndicator.classList.remove('status-offline');
        statusIndicator.title = 'Connecté';
    } else {
        statusIndicator.classList.add('status-offline');
        statusIndicator.classList.remove('status-online');
        statusIndicator.title = 'Hors ligne';
    }
}

// Chargement des modules
function loadModule(moduleId) {
    const moduleContainer = document.getElementById('module-container');
    if (!moduleContainer) {
        console.error('Container de module non trouvé');
        return;
    }
    
    moduleContainer.innerHTML = ''; // Nettoyage du conteneur
    
    // Chargement dynamique du module avec chemin relatif
    fetch(`modules/${moduleId}.html`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.text();
        })
        .then(html => {
            moduleContainer.innerHTML = html;
            initializeModule(moduleId);
        })
        .catch(error => {
            console.error('Erreur lors du chargement du module:', error);
            moduleContainer.innerHTML = `<div class="error">Erreur lors du chargement du module: ${moduleId}</div>`;
        });
}

// Initialisation des modules
function initializeModule(moduleId) {
    switch (moduleId) {
        case 'module-puissance-chauffage':
            initializePuissanceChauffage();
            break;
        case 'module-vase-expansion':
            initializeVaseExpansion();
            break;
        // Ajouter les autres cas pour chaque module
    }
}

// Module Puissance Chauffage
function initializePuissanceChauffage() {
    const form = document.getElementById('puissance-chauffage-form');
    if (!form) return;
    
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        calculatePuissanceChauffage();
    });
}

function calculatePuissanceChauffage() {
    const surface = parseFloat(document.getElementById('surface').value);
    const hauteur = parseFloat(document.getElementById('hauteur').value);
    const tempInt = parseFloat(document.getElementById('temp-int').value);
    const tempExt = parseFloat(document.getElementById('temp-ext').value);
    const coefficientG = parseFloat(document.getElementById('coefficient-g').value);
    
    const volume = surface * hauteur;
    const deltaT = tempInt - tempExt;
    const puissance = (coefficientG * volume * deltaT) / 1000;
    
    displayResult('puissance-result', {
        volume: volume.toFixed(2),
        deltaT: deltaT.toFixed(1),
        puissance: puissance.toFixed(2)
    });
}

// Module Vase d'Expansion
function initializeVaseExpansion() {
    const form = document.getElementById('vase-expansion-form');
    if (!form) return;
    
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        calculateVaseExpansion();
    });
}

function calculateVaseExpansion() {
    const hauteur = parseFloat(document.getElementById('hauteur-batiment').value);
    const radiateurEloigne = document.getElementById('radiateur-eloigne').checked;
    
    const pressionTheorique = (hauteur / 10) + 0.3;
    const reglageTours = Math.round(pressionTheorique * 2) / 2;
    
    displayResult('vase-expansion-result', {
        pressionTheorique: pressionTheorique.toFixed(2),
        reglageTours: reglageTours.toFixed(1),
        radiateurEloigne: radiateurEloigne ? 'Oui' : 'Non'
    });
}

// Affichage des résultats
function displayResult(containerId, data) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    let html = '<div class="result">';
    for (const [key, value] of Object.entries(data)) {
        html += `<p><strong>${formatLabel(key)}:</strong> ${value}</p>`;
    }
    html += '</div>';
    
    container.innerHTML = html;
}

// Utilitaires
function formatLabel(key) {
    const labels = {
        'volume': 'Volume (m³)',
        'deltaT': 'ΔT (°C)',
        'puissance': 'Puissance (kW)',
        'pressionTheorique': 'Pression théorique (bar)',
        'reglageTours': 'Réglage (tours)',
        'radiateurEloigne': 'Radiateur le plus éloigné'
    };
    return labels[key] || key;
}

// Gestion des préférences
function initializePreferences() {
    const prefs = JSON.parse(localStorage.getItem('userPreferences')) || {};
    document.getElementById('technician-name').textContent = prefs.technicianName || 'Technicien';
}

// Gestion de la recherche
function setupSearch() {
    const searchInput = document.getElementById('search-modules');
    if (!searchInput) return;
    
    searchInput.addEventListener('input', handleSearch);
}

function handleSearch(e) {
    const searchTerm = e.target.value.toLowerCase();
    const links = document.querySelectorAll('.sidebar-nav a');
    
    links.forEach(link => {
        const text = link.textContent.toLowerCase();
        link.parentElement.style.display = text.includes(searchTerm) ? 'block' : 'none';
    });
}

// Gestion de la déconnexion
function handleLogout() {
    localStorage.removeItem('userPreferences');
    window.location.href = '/auth.html';
}

// Rendu des modules
function renderModules() {
    const modulesGrid = document.getElementById('modulesGrid');
    modulesGrid.innerHTML = '';

    modules.forEach(module => {
        const card = createModuleCard(module);
        modulesGrid.appendChild(card);
    });
}

// Création d'une carte de module
function createModuleCard(module) {
    const card = document.createElement('div');
    card.className = 'module-card';
    card.dataset.moduleId = module.id;

    const isFavorite = isModuleFavorite(module.id);
    if (isFavorite) {
        card.classList.add('favorite');
    }

    card.innerHTML = `
        <div class="module-card-header">
            <div class="module-card-icon">
                <img src="${module.icon}" alt="${module.title}">
            </div>
            <button class="module-card-favorite ${isFavorite ? 'active' : ''}" data-module-id="${module.id}">
                <img src="/assets/icons/star.svg" alt="Favoris">
            </button>
        </div>
        <h3 class="module-card-title">${module.title}</h3>
        <p class="module-card-description">${module.description}</p>
    `;

    // Gestionnaire de clic pour ouvrir le module
    card.addEventListener('click', (e) => {
        if (!e.target.closest('.module-card-favorite')) {
            loadModule(module.id);
        }
    });

    // Gestionnaire de clic pour les favoris
    const favoriteBtn = card.querySelector('.module-card-favorite');
    favoriteBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        toggleFavorite(module.id);
    });

    return card;
}

// Gestion des favoris
function toggleFavorite(moduleId) {
    const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
    const index = favorites.indexOf(moduleId);

    if (index === -1) {
        favorites.push(moduleId);
    } else {
        favorites.splice(index, 1);
    }

    localStorage.setItem('favorites', JSON.stringify(favorites));
    updateFavoriteUI(moduleId);
}

function isModuleFavorite(moduleId) {
    const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
    return favorites.includes(moduleId);
}

function updateFavoriteUI(moduleId) {
    const card = document.querySelector(`.module-card[data-module-id="${moduleId}"]`);
    const favoriteBtn = card.querySelector('.module-card-favorite');
    const isFavorite = isModuleFavorite(moduleId);

    card.classList.toggle('favorite', isFavorite);
    favoriteBtn.classList.toggle('active', isFavorite);
}

// Filtre des favoris
function setupFavoritesFilter() {
    const toggleFavoritesBtn = document.getElementById('toggleFavorites');
    const modulesGrid = document.getElementById('modulesGrid');
    let showFavorites = false;

    toggleFavoritesBtn.addEventListener('click', () => {
        showFavorites = !showFavorites;
        modulesGrid.classList.toggle('show-favorites', showFavorites);
        toggleFavoritesBtn.classList.toggle('active', showFavorites);
    });
} 