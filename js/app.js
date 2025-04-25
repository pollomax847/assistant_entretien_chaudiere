// Configuration initiale
document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
    setupEventListeners();
    loadUserPreferences();
});

// Initialisation de l'application
function initializeApp() {
    // Vérification de la connexion
    updateConnectionStatus();
    
    // Chargement des modules
    loadModule('module-puissance-chauffage');
    
    // Configuration de la recherche
    setupSearch();
}

// Gestionnaires d'événements
function setupEventListeners() {
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
}

// Gestion de la connexion
function updateConnectionStatus() {
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
    moduleContainer.innerHTML = ''; // Nettoyage du conteneur
    
    // Chargement dynamique du module
    fetch(`/modules/${moduleId}.html`)
        .then(response => response.text())
        .then(html => {
            moduleContainer.innerHTML = html;
            initializeModule(moduleId);
        })
        .catch(error => {
            console.error('Erreur lors du chargement du module:', error);
            moduleContainer.innerHTML = '<div class="error">Erreur lors du chargement du module</div>';
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
function loadUserPreferences() {
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