/**
 * Chauffage Expert - Application principale
 * Contient toutes les fonctions de calcul et l'initialisation de l'application
 * 
 * @author Chauffage Expert
 * @version 1.0.0
 */

import { ThemeManager } from './utils/ThemeManager.js';

// Constantes globales pour les calculs
const CONFIG = {
    CHAUFFAGE: {
        TEMPERATURE_REFERENCE: 19, // Température de référence en °C
        COEF_SECURITE: 1.2, // Coefficient de sécurité pour la puissance
        TEMP_REFERENCE: 20, // Température de référence en °C
    },
    ECS: {
        TEMP_EFS_DEFAULT: 10, // Température eau froide par défaut (°C)
        TEMP_ECS_DEFAULT: 45, // Température eau chaude par défaut (°C)
        COEF_CONVERSION: 0.0143, // Coefficient pour conversion débit/puissance
        DEBIT_PAR_PERSONNE: 50, // L/jour par personne
        TEMP_ECS: 55, // Température ECS en °C
    },
    GAZ: {
        PCS_NATUREL: 9.6, // kWh/m³
        PCS_PROPANE: 12.8, // kWh/kg
        PRESSION_NOMINALE: 20, // Pression nominale en mbar
    },
    VMC: {
        NORMES_DEBIT: {
            SIMPLE_FLUX: { min: 15, max: 30 },
            HYGRO_A: { min: 10, max: 40 },
            HYGRO_B: { min: 5, max: 45 },
            DOUBLE_FLUX: { min: 20, max: 50 },
            GAZ: { min: 15, max: 30 }
        },
        DEBIT_PAR_PIECE: 15, // m³/h par pièce
        DEBIT_CUISINE: 30, // m³/h pour la cuisine
        DEBIT_SDB: 15, // m³/h pour la salle de bain
    },
    VASE_EXPANSION: {
        COEF_SECURITE: 1.1, // Coefficient de sécurité pour la pression
    }
};

// Préférences utilisateur
let preferences = {
    technicien: "",
    theme: "light",
    temperatureUnit: "C",
    logo: null
};

// Gestionnaire de thème
let themeManager;

// Configuration des images de radiateurs
const RADIATEUR_IMAGES = {
    'Acier': 'assets/images/radiateurs/acier.jpg',
    'Fonte': 'assets/images/radiateurs/fonte.jpg',
    'Aluminium': 'assets/images/radiateurs/aluminium.jpg',
    'FonteAlu': 'assets/images/radiateurs/fonte_alu.jpg',
    'Panneaux': {
        'T11': 'assets/images/radiateurs/panneau_t11.jpg',
        'T21': 'assets/images/radiateurs/panneau_t21.jpg',
        'T22': 'assets/images/radiateurs/panneau_t22.jpg',
        'T33': 'assets/images/radiateurs/panneau_t33.jpg'
    },
    'SecheServiette': 'assets/images/radiateurs/seche_serviette.jpg'
};

// Messages d'information pour les radiateurs sans image
const RADIATEUR_MESSAGES = {
    'Acier': 'Radiateur en acier - Image non disponible',
    'Aluminium': 'Radiateur en aluminium - Image non disponible',
    'FonteAlu': 'Radiateur en fonte d\'aluminium - Image non disponible'
};

/**
 * Initialise l'application au chargement de la page
 */
document.addEventListener('DOMContentLoaded', () => {
    // Initialiser le gestionnaire de thème
    themeManager = new ThemeManager();
    
    // Charger les préférences depuis le localStorage
    loadPreferences();
    
    // Appliquer les préférences (thème, etc.)
    applyPreferences();
    
    // Initialiser tous les modules
    initModules();
    
    // Configurer la navigation
    setupNavigation();
    
    console.log("Application Chauffage Expert initialisée");
});

/**
 * Initialise tous les modules de l'application
 */
function initModules() {
    // Module 1: Puissance Chauffage
    initChauffage();
    
    // Module 2: Vase d'Expansion
    initVaseExpansion();
    
    // Module 3: Équilibrage Réseau
    initEquilibrageReseau();
    
    // Module 4: Radiateurs
    initRadiateurs();
    
    // Module 5: ECS
    initEcs();
    
    // Module 6: Top Compteur Gaz
    initTopGaz();
    
    // Module 7: VMC
    initVmc();
    
    // Module 8: Réglementation Gaz
    initReglementationGaz();
    
    // Module 9: Réglementaires complémentaires
    initReglementairesComp();
    
    // Module 10: Export PDF
    initExportPDF();
    
    // Module 11: Préférences
    initPreferences();
}

/**
 * Configure la navigation et les actions de recherche
 */
function setupNavigation() {
    // Navigation fluide pour les liens d'ancrage
    document.querySelectorAll('.sidebar-nav a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 70,
                    behavior: 'smooth'
                });
                
                // Ajouter la classe active au lien
                document.querySelectorAll('.sidebar-nav a').forEach(a => a.classList.remove('active'));
                this.classList.add('active');
            }
        });
    });
    
    // Gestion de la recherche des modules
    const searchInput = document.getElementById('search-modules');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const modules = document.querySelectorAll('.module-section');
            
            modules.forEach(module => {
                const title = module.querySelector('h2').textContent.toLowerCase();
                const visible = title.includes(searchTerm);
                module.style.display = visible ? 'block' : 'none';
            });
        });
    }
    
    // Mise à jour de la classe active sur le scroll
    window.addEventListener('scroll', highlightCurrentSection);
}

/**
 * Met en surbrillance la section courante dans la navigation
 */
function highlightCurrentSection() {
    const scrollPosition = window.scrollY;
    
    // Obtenir toutes les sections
    const sections = document.querySelectorAll('.module-section');
    
    // Trouver la section actuellement visible
    sections.forEach(section => {
        const sectionTop = section.offsetTop - 100;
        const sectionHeight = section.offsetHeight;
        
        if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
            const id = section.getAttribute('id');
            
            // Enlever la classe active de tous les liens
            document.querySelectorAll('.sidebar-nav a').forEach(a => a.classList.remove('active'));
            
            // Ajouter la classe active au lien correspondant
            const activeLink = document.querySelector(`.sidebar-nav a[href="#${id}"]`);
            if (activeLink) activeLink.classList.add('active');
        }
    });
}

/**
 * Charge les préférences depuis le localStorage
 */
function loadPreferences() {
    const storedPreferences = localStorage.getItem('chauffage-expert-prefs');
    if (storedPreferences) {
        preferences = JSON.parse(storedPreferences);
        
        // S'assurer que le thème dans les préférences est synchronisé avec le gestionnaire de thème
        if (preferences.theme && themeManager) {
            themeManager.setTheme(preferences.theme);
        }
    }
}

/**
 * Applique les préférences de l'utilisateur
 */
function applyPreferences() {
    // Le thème est maintenant géré par le ThemeManager
    
    // Afficher le nom du technicien
    const technicianElement = document.getElementById('technician-name');
    if (technicianElement && preferences.technicien) {
        technicianElement.textContent = preferences.technicien;
    }
    
    // Mettre status en ligne
    const statusIndicator = document.getElementById('status-indicator');
    if (statusIndicator) {
        statusIndicator.classList.add('online');
    }
}

/**
 * Sauvegarde les préférences dans le localStorage
 */
function savePreferences() {
    // Si le thème a été changé via le gestionnaire de thème, mettre à jour les préférences
    if (themeManager) {
        preferences.theme = themeManager.getCurrentTheme();
    }
    
    localStorage.setItem('chauffage-expert-prefs', JSON.stringify(preferences));
    applyPreferences();
}

/**
 * Initialise le module de calcul de puissance chauffage
 */
function initChauffage() {
    const surface = document.getElementById('chauffage-surface');
    const hauteur = document.getElementById('chauffage-hauteur');
    const tempInt = document.getElementById('chauffage-temp-int');
    const tempExt = document.getElementById('chauffage-temp-ext');
    const coefG = document.getElementById('chauffage-coef-g');
    
    // Groupe d'éléments pour auto-calcul
    const elements = [surface, hauteur, tempInt, tempExt, coefG];
    
    // Configurer les écouteurs d'événements pour auto-calcul
    elements.forEach(el => {
        if (el) el.addEventListener('input', calculPuissanceChauffage);
    });
    
    // Calcul initial si toutes les données sont présentes
    if (elements.every(el => el && el.value)) {
        calculPuissanceChauffage();
    }
}

/**
 * Calcul de la puissance de chauffage
 */
function calculPuissanceChauffage() {
    const surface = parseFloat(document.getElementById('chauffage-surface').value);
    const hauteur = parseFloat(document.getElementById('chauffage-hauteur').value);
    const tempInt = parseFloat(document.getElementById('chauffage-temp-int').value);
    const tempExt = parseFloat(document.getElementById('chauffage-temp-ext').value);
    const coefG = parseFloat(document.getElementById('chauffage-coef-g').value);
    
    // Vérifier si toutes les valeurs sont valides
    if (!isNaN(surface) && !isNaN(hauteur) && !isNaN(tempInt) && !isNaN(tempExt) && !isNaN(coefG)) {
        // Calcul du volume
        const volume = surface * hauteur;
        
        // Calcul du delta T
        const deltaT = tempInt - tempExt;
        
        // Calcul de la puissance requise
        const puissance = (coefG * volume * deltaT / 1000) * CONFIG.CHAUFFAGE.COEF_SECURITE;
        
        // Afficher les résultats
        document.getElementById('chauffage-volume').textContent = volume.toFixed(1);
        document.getElementById('chauffage-delta-t').textContent = deltaT.toFixed(1);
        document.getElementById('chauffage-puissance').textContent = puissance.toFixed(2);
        
        // Après le calcul de la puissance
        verifierCohérenceGlobale();
    }
}

/**
 * Initialise le module de calcul vase d'expansion
 */
function initVaseExpansion() {
    const hauteur = document.getElementById('vase-hauteur');
    const radiateurLoin = document.getElementById('vase-radiateur-loin');
    
    // Configurer les écouteurs d'événements
    if (hauteur) hauteur.addEventListener('input', calculVaseExpansion);
    if (radiateurLoin) radiateurLoin.addEventListener('change', calculVaseExpansion);
}

/**
 * Calcul des paramètres du vase d'expansion
 */
function calculVaseExpansion() {
    const hauteur = parseFloat(document.getElementById('vase-hauteur').value);
    const radiateurLoin = document.getElementById('vase-radiateur-loin').value === 'oui';
    
    if (!isNaN(hauteur)) {
        // Calcul de la pression (hauteur en m / 10 + marge de sécurité)
        const pression = (hauteur / 10 + 0.3).toFixed(1);
        
        // Détermination du réglage
        let reglage = "1.5";
        if (radiateurLoin) {
            reglage = "2.5";
        }
        
        // Afficher les résultats
        document.getElementById('vase-pression').textContent = pression;
        document.getElementById('vase-reglage').textContent = reglage;
    }
    verifierCohérenceGlobale();
}

/**
 * Initialise le module d'équilibrage réseau
 */
function initEquilibrageReseau() {
    // Gestion des choix de méthode d'équilibrage
    const methodRadios = document.querySelectorAll('input[name="equilibrage-methode"]');
    methodRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            const puissanceInputs = document.getElementById('equilibrage-puissance-inputs');
            const deltaTInputs = document.getElementById('equilibrage-deltaT-inputs');
            
            if (this.value === 'puissance') {
                puissanceInputs.style.display = 'block';
                deltaTInputs.style.display = 'none';
            } else {
                puissanceInputs.style.display = 'none';
                deltaTInputs.style.display = 'block';
            }
        });
    });
    
    // Écouteurs pour les calculs
    const puissance = document.getElementById('equilibrage-puissance');
    const debit = document.getElementById('equilibrage-debit');
    
    if (puissance) puissance.addEventListener('input', calculEquilibrage);
    if (debit) debit.addEventListener('input', calculEquilibrage);
}

/**
 * Calcul de l'équilibrage du réseau
 */
function calculEquilibrage() {
    const puissance = parseFloat(document.getElementById('equilibrage-puissance').value);
    const debit = parseFloat(document.getElementById('equilibrage-debit').value);
    
    if (!isNaN(puissance) && !isNaN(debit) && debit > 0) {
        // Calcul du réglage (formule simplifiée)
        const debitNecessaire = puissance / 86; // Approximation W → L/h avec delta T = 20°C
        const pourcentageOuverture = (debitNecessaire / debit) * 100;
        
        // Conversion en tours de robinet (approximation)
        let tours;
        if (pourcentageOuverture <= 10) tours = 0.5;
        else if (pourcentageOuverture <= 20) tours = 1;
        else if (pourcentageOuverture <= 40) tours = 1.5;
        else if (pourcentageOuverture <= 60) tours = 2;
        else if (pourcentageOuverture <= 80) tours = 2.5;
        else tours = 3;
        
        // Arrondir à 0.5 près
        tours = Math.round(tours * 2) / 2;
        
        // Afficher le résultat
        document.getElementById('equilibrage-reglage').textContent = tours.toString();
    }
}

/**
 * Initialise le module radiateurs
 */
function initRadiateurs() {
    console.log('Initialisation du module radiateurs...');
    
    const hauteurSlider = document.getElementById('rad-hauteur');
    const longueurSlider = document.getElementById('rad-longueur');
    const hauteurValue = document.getElementById('rad-hauteur-value');
    const longueurValue = document.getElementById('rad-longueur-value');
    const typeSelect = document.getElementById('rad-type');
    const panelTypeGroup = document.getElementById('rad-panel-type-group');
    const panelTypeSelect = document.getElementById('rad-panel-type');
    const logementType = document.getElementById('logement-type');
    const radNombre = document.getElementById('rad-nombre');
    const radVisual = document.getElementById('rad-visual');
    const radImage = radVisual.querySelector('img');

    // Fonction pour mettre à jour l'image du radiateur
    function updateRadiateurImage() {
        console.log('Mise à jour de l\'image du radiateur...');
        const type = typeSelect.value;
        console.log('Type de radiateur sélectionné:', type);
        let imagePath = '';
        let message = '';

        if (type === 'Panneaux') {
            const panelType = panelTypeSelect.value;
            console.log('Type de panneau:', panelType);
            imagePath = RADIATEUR_IMAGES.Panneaux[panelType];
        } else {
            imagePath = RADIATEUR_IMAGES[type];
            message = RADIATEUR_MESSAGES[type];
        }

        console.log('Chemin de l\'image:', imagePath);

        if (imagePath) {
            // Vérifier si l'image existe
            const img = new Image();
            img.onload = function() {
                console.log('Image chargée avec succès:', imagePath);
                radImage.src = imagePath;
                radImage.style.display = 'block';
                if (radVisual.querySelector('.no-image-message')) {
                    radVisual.querySelector('.no-image-message').remove();
                }
            };
            img.onerror = function() {
                console.log('Erreur de chargement de l\'image:', imagePath);
                showNoImageMessage(message);
            };
            img.src = imagePath;
        } else {
            console.log('Aucun chemin d\'image trouvé pour le type:', type);
            showNoImageMessage(message);
        }
    }

    // Fonction pour afficher le message d'absence d'image
    function showNoImageMessage(message) {
        console.log('Affichage du message d\'absence d\'image:', message);
        radImage.style.display = 'none';
        let messageElement = radVisual.querySelector('.no-image-message');
        if (!messageElement) {
            messageElement = document.createElement('div');
            messageElement.className = 'no-image-message';
            radVisual.appendChild(messageElement);
        }
        messageElement.textContent = message || 'Image non disponible';
    }

    // Mise à jour des valeurs affichées
    function updateSliderValues() {
        console.log('Mise à jour des valeurs des sliders...');
        hauteurValue.textContent = `${hauteurSlider.value} mm`;
        longueurValue.textContent = `${longueurSlider.value} mm`;
        calculPuissanceRadiateur();
    }

    // Écouteurs pour les sliders
    hauteurSlider.addEventListener('input', updateSliderValues);
    longueurSlider.addEventListener('input', updateSliderValues);

    // Gestion du type de logement
    logementType.addEventListener('change', function() {
        console.log('Changement de type de logement:', this.value);
        const type = this.value;
        if (type) {
            // Définir le nombre de radiateurs recommandé selon le type de logement
            const radiateursRecommandes = {
                'T1': 1,
                'T2': 2,
                'T3': 3,
                'T4': 4,
                'T5': 5,
                'T6': 6
            };
            radNombre.value = radiateursRecommandes[type];
            console.log('Nombre de radiateurs recommandé:', radNombre.value);
            updateDimensionsRecommandees(type);
        }
    });

    // Gestion du nombre de radiateurs
    radNombre.addEventListener('change', function() {
        console.log('Changement du nombre de radiateurs:', this.value);
        const type = logementType.value;
        if (type) {
            updateDimensionsRecommandees(type);
        }
    });

    // Gestion du type de radiateur
    typeSelect.addEventListener('change', function() {
        console.log('Changement de type de radiateur:', this.value);
        panelTypeGroup.style.display = this.value === 'Panneaux' ? 'block' : 'none';
        updateRadiateurImage();
        calculPuissanceRadiateur();
    });

    // Gestion du type de panneau
    panelTypeSelect.addEventListener('change', function() {
        console.log('Changement de type de panneau:', this.value);
        updateRadiateurImage();
        calculPuissanceRadiateur();
    });

    // Calcul initial
    console.log('Calcul initial...');
    updateSliderValues();
    updateRadiateurImage();
}

/**
 * Calcul de la puissance d'un radiateur
 */
function calculPuissanceRadiateur() {
    const type = document.getElementById('rad-type').value;
    const hauteur = parseInt(document.getElementById('rad-hauteur').value);
    const longueur = parseInt(document.getElementById('rad-longueur').value);
    const panneauType = document.getElementById('rad-panel-type')?.value;
    const nombreRadiateurs = parseInt(document.getElementById('rad-nombre').value);

    if (isNaN(hauteur) || isNaN(longueur) || isNaN(nombreRadiateurs)) {
        document.getElementById('rad-puissance').textContent = '--';
        return;
    }

    // Coefficients selon le type de radiateur
    let coef = 0.06; // Valeur par défaut (acier)
    
    if (type === 'Panneaux') {
        if (panneauType === 'T11') coef = 0.08;
        else if (panneauType === 'T21') coef = 0.10;
        else if (panneauType === 'T22') coef = 0.12;
        else if (panneauType === 'T33') coef = 0.15;
    } else if (type === 'Fonte') coef = 0.09;
    else if (type === 'Aluminium') coef = 0.10;
    else if (type === 'FonteAlu') coef = 0.11;
    else if (type === 'SecheServiette') coef = 0.07;

    // Conversion en mètres et calcul de la surface
    const surface = (hauteur * longueur) / 1000000; // mm² → m²
    
    // Calcul de la puissance (W) pour un radiateur
    const puissanceUnitaire = surface * coef * 10000;
    
    // Calcul de la puissance totale pour tous les radiateurs
    const puissanceTotale = puissanceUnitaire * nombreRadiateurs;
    
    // Afficher les résultats
    document.getElementById('rad-puissance').textContent = `${Math.round(puissanceUnitaire)} W (unitaire) / ${Math.round(puissanceTotale)} W (totale)`;
    verifierCohérenceGlobale();
}

/**
 * Initialise le module ECS
 */
function initEcs() {
    const tempEfs = document.getElementById('ecs-temp-efs');
    const tempEcs = document.getElementById('ecs-temp-ecs');
    const debit = document.getElementById('ecs-debit');
    const puissanceChaudiere = document.getElementById('ecs-puissance-chaudiere');
    
    // Écouteurs pour le calcul
    [tempEfs, tempEcs, debit, puissanceChaudiere].forEach(el => {
        if (el) el.addEventListener('input', calculEcs);
    });
}

/**
 * Calcul de l'ECS instantané
 */
function calculEcs() {
    const tempEfs = parseFloat(document.getElementById('ecs-temp-efs').value);
    const tempEcs = parseFloat(document.getElementById('ecs-temp-ecs').value);
    const debit = parseFloat(document.getElementById('ecs-debit').value);
    const puissanceChaudiere = parseFloat(document.getElementById('ecs-puissance-chaudiere').value);
    
    if (!isNaN(tempEfs) && !isNaN(tempEcs) && !isNaN(debit)) {
        // Calcul du delta T
        const deltaT = tempEcs - tempEfs;
        
        // Calcul de la puissance restituée
        const puissanceRestituee = (debit * deltaT) / CONFIG.ECS.COEF_CONVERSION;
        
        // Afficher les résultats
        document.getElementById('ecs-delta-t').textContent = deltaT.toFixed(1);
        document.getElementById('ecs-puissance-restituee').textContent = puissanceRestituee.toFixed(1);
        
        // Vérifier la cohérence avec la puissance chaudière
        const coherenceElement = document.getElementById('ecs-coherence');
        
        if (!isNaN(puissanceChaudiere)) {
            coherenceElement.classList.remove('ok', 'warning');
            
            if (puissanceRestituee < puissanceChaudiere * 0.7) {
                coherenceElement.textContent = `⚠️ Puissance restituée trop faible par rapport à la chaudière (${puissanceChaudiere} kW)`;
                coherenceElement.classList.add('warning');
            } else if (puissanceRestituee > puissanceChaudiere * 1.3) {
                coherenceElement.textContent = `⚠️ Consommation trop élevée par rapport à la chaudière (${puissanceChaudiere} kW)`;
                coherenceElement.classList.add('warning');
            } else {
                coherenceElement.textContent = '✅ Puissance restituée cohérente avec la chaudière';
                coherenceElement.classList.add('ok');
            }
        } else {
            coherenceElement.textContent = '';
        }
    }
    verifierCohérenceGlobale();
}

/**
 * Initialise le module Top Compteur Gaz
 */
function initTopGaz() {
    const digit1 = document.getElementById('gaz-digit1');
    const digit2 = document.getElementById('gaz-digit2');
    const digit3 = document.getElementById('gaz-digit3');
    const dureeRadios = document.querySelectorAll('input[name="gaz-duree"]');
    const typeGaz = document.getElementById('gaz-type');
    const puissanceChaudiere = document.getElementById('gaz-puissance-chaudiere');
    
    // Écouteurs pour les chiffres
    [digit1, digit2, digit3].forEach(el => {
        if (el) {
            el.addEventListener('input', function() {
                // Limiter à un seul chiffre
                if (this.value.length > 1) {
                    this.value = this.value.slice(0, 1);
                }
                calculTopGaz();
            });
        }
    });
    
    // Écouteurs pour les autres éléments
    dureeRadios.forEach(el => {
        if (el) el.addEventListener('change', calculTopGaz);
    });
    
    if (typeGaz) typeGaz.addEventListener('change', calculTopGaz);
    if (puissanceChaudiere) puissanceChaudiere.addEventListener('input', calculTopGaz);
}

/**
 * Calcul du Top Compteur Gaz
 */
function calculTopGaz() {
    const digit1 = parseInt(document.getElementById('gaz-digit1').value) || 0;
    const digit2 = parseInt(document.getElementById('gaz-digit2').value) || 0;
    const digit3 = parseInt(document.getElementById('gaz-digit3').value) || 0;
    
    // Récupérer la durée sélectionnée
    const dureeRadio = document.querySelector('input[name="gaz-duree"]:checked');
    const duree = dureeRadio ? parseInt(dureeRadio.value) : 36;
    
    // Récupérer le type de gaz (PCS)
    const pcsValue = parseFloat(document.getElementById('gaz-type').value);
    
    // Récupérer la puissance chaudière si disponible
    const puissanceChaudiere = parseFloat(document.getElementById('gaz-puissance-chaudiere').value);
    
    // Calculer si les digits sont saisis
    if ((digit1 > 0 || digit2 > 0 || digit3 > 0) && !isNaN(pcsValue)) {
        // Volume en litres (3 digits)
        const volumeLitres = digit1 * 100 + digit2 * 10 + digit3;
        
        // Conversion en débit horaire (m³/h)
        const debitHoraire = (volumeLitres / duree) * 3600 / 1000;
        
        // Calcul de la puissance (kW)
        const puissance = debitHoraire * pcsValue;
        
        // Afficher les résultats
        document.getElementById('gaz-volume').textContent = volumeLitres;
        document.getElementById('gaz-debit').textContent = debitHoraire.toFixed(2);
        document.getElementById('gaz-puissance').textContent = puissance.toFixed(1);
        
        // Vérifier la cohérence avec la puissance chaudière
        const coherenceElement = document.getElementById('gaz-coherence');
        
        if (!isNaN(puissanceChaudiere)) {
            coherenceElement.classList.remove('ok', 'warning');
            
            const ecart = ((puissance - puissanceChaudiere) / puissanceChaudiere * 100).toFixed(1);
            const ecartAbsolu = Math.abs(parseFloat(ecart));
            
            if (ecartAbsolu > 10) {
                coherenceElement.textContent = `⚠️ Écart important avec la puissance chaudière (${ecart}%)`;
                coherenceElement.classList.add('warning');
            } else {
                coherenceElement.textContent = `✅ Puissance cohérente avec la chaudière (${ecart}%)`;
                coherenceElement.classList.add('ok');
            }
        } else {
            coherenceElement.textContent = '';
        }
    }
    verifierCohérenceGlobale();
}

/**
 * Initialise le module VMC
 */
function initVmc() {
    const typeVmc = document.getElementById('vmc-type');
    const nbBouches = document.getElementById('vmc-bouches');
    const debitMh = document.getElementById('vmc-debit-mh');
    const debitMs = document.getElementById('vmc-debit-ms');
    const modulesFenetres = document.getElementById('vmc-modules-fenetres');
    const etalonnagePortes = document.getElementById('vmc-etalonnage-portes');
    
    // Écouteurs pour le calcul
    [typeVmc, nbBouches, debitMh, debitMs, modulesFenetres, etalonnagePortes].forEach(el => {
        if (el) el.addEventListener('change', verifierVmc);
    });
    
    if (debitMh) debitMh.addEventListener('input', verifierVmc);
    if (debitMs) debitMs.addEventListener('input', verifierVmc);
}

/**
 * Vérification des paramètres VMC
 */
function verifierVmc() {
    const typeVmc = document.getElementById('vmc-type').value;
    const nbBouches = parseInt(document.getElementById('vmc-bouches').value);
    const debitMh = parseFloat(document.getElementById('vmc-debit-mh').value);
    const debitMs = parseFloat(document.getElementById('vmc-debit-ms').value);
    const modulesFenetres = document.getElementById('vmc-modules-fenetres').value === 'oui';
    const etalonnagePortes = document.getElementById('vmc-etalonnage-portes').value === 'oui';
    
    const resultElement = document.getElementById('result-vmc');
    
    if (!isNaN(nbBouches) && !isNaN(debitMh)) {
        // Déterminer les normes de débit selon le type de VMC
        let normesDebit = CONFIG.VMC.NORMES_DEBIT.SIMPLE_FLUX;
        
        if (typeVmc === 'simple-hygro-a') normesDebit = CONFIG.VMC.NORMES_DEBIT.HYGRO_A;
        else if (typeVmc === 'simple-hygro-b') normesDebit = CONFIG.VMC.NORMES_DEBIT.HYGRO_B;
        else if (typeVmc === 'double-flux') normesDebit = CONFIG.VMC.NORMES_DEBIT.DOUBLE_FLUX;
        else if (typeVmc === 'gaz') normesDebit = CONFIG.VMC.NORMES_DEBIT.GAZ;
        
        // Calculer le débit moyen par bouche
        const debitMoyen = debitMh / nbBouches;
        
        // Vérifier la conformité du débit
        const debitConforme = debitMoyen >= normesDebit.min && debitMoyen <= normesDebit.max;
        
        // Préparer les messages
        let messages = [];
        let isConforme = true;
        
        if (!debitConforme) {
            messages.push(`⚠️ Débit moyen par bouche: ${debitMoyen.toFixed(1)} m³/h (norme: ${normesDebit.min}-${normesDebit.max} m³/h)`);
            isConforme = false;
        } else {
            messages.push(`✅ Débit moyen par bouche: ${debitMoyen.toFixed(1)} m³/h (conforme)`);
        }
        
        if (!isNaN(debitMs)) {
            if (debitMs < 0.5 || debitMs > 2.5) {
                messages.push(`⚠️ Vitesse d'air bouche cuisine: ${debitMs.toFixed(1)} m/s (idéal: 0.5-2.5 m/s)`);
                isConforme = false;
            } else {
                messages.push(`✅ Vitesse d'air bouche cuisine: ${debitMs.toFixed(1)} m/s (conforme)`);
            }
        }
        
        if (!modulesFenetres) {
            messages.push(`⚠️ Entrées d'air aux fenêtres non conformes`);
            isConforme = false;
        } else {
            messages.push('✅ Entrées d\'air aux fenêtres conformes');
        }
        
        if (!etalonnagePortes) {
            messages.push('⚠️ Étalonnage des portes non vérifié');
            isConforme = false;
        } else {
            messages.push('✅ Étalonnage des portes conforme');
        }
        
        // Afficher le résultat
        resultElement.innerHTML = `
            <p class="${isConforme ? 'success' : 'error'}">
                <strong>${isConforme ? '✅ VMC CONFORME' : '⚠️ VMC NON CONFORME'}</strong>
            </p>
            <ul>
                ${messages.map(msg => `<li>${msg}</li>`).join('')}
            </ul>
        `;
        
        // Ajouter la classe appropriée
        resultElement.className = isConforme ? 'result-box success' : 'result-box error';
    } else {
        resultElement.innerHTML = '<p>Veuillez remplir correctement les champs requis</p>';
        resultElement.className = 'result-box';
    }
    verifierCohérenceGlobale();
}

/**
 * Initialise le module Réglementation Gaz
 */
function initReglementationGaz() {
    const typeAppareil = document.getElementById('gaz-reg-type-appareil');
    
    if (typeAppareil) {
        typeAppareil.addEventListener('change', function() {
            // Masquer tous les champs conditionnels
            document.querySelectorAll('.gaz-reg-conditional').forEach(el => {
                el.style.display = 'none';
            });
            
            // Afficher le champ correspondant au type sélectionné
            const selectedType = this.value;
            if (selectedType) {
                document.getElementById(`gaz-reg-fields-${selectedType}`).style.display = 'block';
            }
            
            // Vérifier la conformité
            checkGasRegulation();
        });
    }
    
    // Écouteurs sur les contrôles spécifiques pour chaque type
    const controls = document.querySelectorAll('#gaz-reg-fields-A input, #gaz-reg-fields-B input, #gaz-reg-fields-C input, #gaz-reg-fields-A select, #gaz-reg-fields-B select, #gaz-reg-fields-C select');
    controls.forEach(control => {
        control.addEventListener('change', checkGasRegulation);
        control.addEventListener('input', checkGasRegulation);
    });
}

/**
 * Vérification de la conformité réglementation gaz
 */
function checkGasRegulation() {
    const results = [];
    let isValid = true;

    // 1. Alimentation gaz et raccordements
    const tuyauterieMateriau = document.getElementById('gaz-tuyauterie-materiau').value;
    const tuyauterieDiametre = parseFloat(document.getElementById('gaz-tuyauterie-diametre').value);
    const roaiPresent = document.getElementById('gaz-roai-present').checked;
    const roaiDistance = parseFloat(document.getElementById('gaz-roai-distance').value);
    const flexibleNorme = document.getElementById('gaz-flexible-norme').value;
    const flexibleDate = new Date(document.getElementById('gaz-flexible-date').value);
    const vasoPresent = document.getElementById('gaz-vaso-present').checked;
    const fuiteMethode = document.getElementById('gaz-fuite-methode').value;
    const fuiteValeur = parseFloat(document.getElementById('gaz-fuite-valeur').value);

    // Vérifications tuyauterie
    if (tuyauterieMateriau === 'non-conforme') {
        results.push({ type: 'error', message: 'Matériau de tuyauterie non conforme' });
        isValid = false;
    }
    if (tuyauterieDiametre < 12) {
        results.push({ type: 'error', message: 'Diamètre de tuyauterie insuffisant (< 12mm)' });
        isValid = false;
    }

    // Vérifications ROAI
    if (!roaiPresent) {
        results.push({ type: 'error', message: 'ROAI absent ou non accessible' });
        isValid = false;
    }
    if (roaiDistance < 0.1) {
        results.push({ type: 'error', message: 'Distance ROAI/plaque cuisson insuffisante (< 0.1m)' });
        isValid = false;
    }

    // Vérifications flexible
    if (flexibleNorme === 'non-conforme') {
        results.push({ type: 'error', message: 'Flexible non conforme aux normes en vigueur' });
        isValid = false;
    }
    const today = new Date();
    const ageFlexible = (today - flexibleDate) / (1000 * 60 * 60 * 24 * 365);
    if (ageFlexible > 10) {
        results.push({ type: 'error', message: 'Flexible périmé (> 10 ans)' });
        isValid = false;
    }

    // Vérifications VASO
    if (!vasoPresent) {
        results.push({ type: 'error', message: 'Réglette VASO absente ou non conforme' });
        isValid = false;
    }

    // Vérifications fuite
    if (fuiteValeur > 0.4) {
        results.push({ type: 'error', message: 'Fuite gaz détectée (> 0.4 mbar)' });
        isValid = false;
    }

    // 2. Ventilation et aération
    const ventilationType = document.getElementById('gaz-ventilation-type').value;
    const puissance = parseFloat(document.getElementById('gaz-puissance').value);
    const grilleBasse = parseFloat(document.getElementById('gaz-grille-basse').value);
    const grilleHaute = parseFloat(document.getElementById('gaz-grille-haute').value);
    const placard = document.getElementById('gaz-placard').checked;
    const cuisine = document.getElementById('gaz-cuisine').checked;

    // Calcul sections minimales selon puissance
    const sectionMinBasse = Math.max(100, puissance * 5);
    const sectionMinHaute = Math.max(50, puissance * 2.5);

    if (grilleBasse < sectionMinBasse) {
        results.push({ type: 'error', message: `Section grille basse insuffisante (minimum ${sectionMinBasse} cm²)` });
        isValid = false;
    }
    if (grilleHaute < sectionMinHaute) {
        results.push({ type: 'error', message: `Section grille haute insuffisante (minimum ${sectionMinHaute} cm²)` });
        isValid = false;
    }

    // 3. Typologie de chaudière
    const typeChaudiere = document.getElementById('gaz-type-chaudiere').value;
    const b11Tirage = document.getElementById('gaz-b11-tirage').checked;
    const b11Refoulement = document.getElementById('gaz-b11-refoulement').checked;

    if (typeChaudiere === 'B11' && (!b11Tirage || !b11Refoulement)) {
        results.push({ type: 'error', message: 'Vérifications B11 incomplètes' });
        isValid = false;
    }

    // 4. Évacuation des produits de combustion
    const conduitMateriau = document.getElementById('gaz-conduit-materiau').value;
    const conduitTube = document.getElementById('gaz-conduit-tube').checked;
    const ventouseDistance = parseFloat(document.getElementById('gaz-ventouse-distance').value);
    const clapet = document.getElementById('gaz-clapet').checked;

    if (conduitMateriau === 'pvc') {
        results.push({ type: 'error', message: 'Conduit en PVC interdit' });
        isValid = false;
    }
    if (!conduitTube) {
        results.push({ type: 'error', message: 'Tubage non conforme NF DTU 24.1' });
        isValid = false;
    }
    if (ventouseDistance < 0.4) {
        results.push({ type: 'error', message: 'Distance ventouse/baie insuffisante (< 0.4m)' });
        isValid = false;
    }
    if (!clapet) {
        results.push({ type: 'error', message: 'Clapet antiretour absent' });
        isValid = false;
    }

    // 5. Sécurités
    const securiteFlamme = document.getElementById('gaz-securite-flamme').checked;
    const securiteTirage = document.getElementById('gaz-securite-tirage').checked;
    const securiteRefoulement = document.getElementById('gaz-securite-refoulement').checked;
    const securiteCag = document.getElementById('gaz-securite-cag').checked;
    const securiteCo = document.getElementById('gaz-securite-co').checked;

    if (!securiteFlamme) {
        results.push({ type: 'error', message: 'Contrôle de flamme défectueux' });
        isValid = false;
    }
    if (!securiteTirage) {
        results.push({ type: 'error', message: 'Contrôle de tirage défectueux' });
        isValid = false;
    }
    if (!securiteRefoulement) {
        results.push({ type: 'error', message: 'Sécurité contre le refoulement défectueuse' });
        isValid = false;
    }

    // 6. Entretien annuel
    const entretienCorps = document.getElementById('gaz-entretien-corps').checked;
    const entretienBrûleur = document.getElementById('gaz-entretien-brûleur').checked;
    const entretienVeilleuse = document.getElementById('gaz-entretien-veilleuse').checked;
    const debit = parseFloat(document.getElementById('gaz-debit').value);
    const coAmbiant = parseFloat(document.getElementById('gaz-co-ambiant').value);
    const rendement = parseFloat(document.getElementById('gaz-rendement').value);
    const condensation = document.getElementById('gaz-condensation').checked;
    const condensats = document.getElementById('gaz-condensats').checked;

    if (!entretienCorps || !entretienBrûleur) {
        results.push({ type: 'error', message: 'Nettoyage incomplet' });
        isValid = false;
    }
    if (coAmbiant > 30) {
        results.push({ type: 'error', message: 'CO ambiant trop élevé (> 30 ppm)' });
        isValid = false;
    }
    if (rendement < 70) {
        results.push({ type: 'error', message: 'Rendement insuffisant (< 70%)' });
        isValid = false;
    }
    if (condensation && !condensats) {
        results.push({ type: 'error', message: 'Contrôle condensats non effectué' });
        isValid = false;
    }

    // 7. Anomalies
    const anomalieType = document.getElementById('gaz-anomalie-type').value;
    const anomalieDescription = document.getElementById('gaz-anomalie-description').value;
    const anomalieFiche = document.getElementById('gaz-anomalie-fiche').checked;

    if (anomalieType === 'DGI') {
        results.push({ type: 'error', message: 'DANGER GRAVE IMMÉDIAT - Coupure immédiate requise' });
        isValid = false;
    }
    if (anomalieDescription && !anomalieFiche) {
        results.push({ type: 'error', message: 'Fiche d\'anomalie non remise au client' });
        isValid = false;
    }

    // 8. Documentation
    const docAttestation = document.getElementById('gaz-doc-attestation').checked;
    const docCopie = document.getElementById('gaz-doc-copie').checked;

    if (!docAttestation) {
        results.push({ type: 'error', message: 'Attestation d\'entretien non remise' });
        isValid = false;
    }
    if (!docCopie) {
        results.push({ type: 'error', message: 'Copie non conservée 2 ans' });
        isValid = false;
    }

    // Affichage des résultats
    const resultBox = document.getElementById('result-reglementation-gaz');
    resultBox.innerHTML = '';

    if (results.length === 0) {
        resultBox.innerHTML = '<div class="success">Toutes les vérifications sont conformes à la réglementation gaz 2025</div>';
    } else {
        results.forEach(result => {
            const div = document.createElement('div');
            div.className = result.type === 'error' ? 'error' : 'warning';
            div.textContent = result.message;
            resultBox.appendChild(div);
        });
    }

    return isValid;
}

// Gestion des champs conditionnels
document.getElementById('gaz-type-chaudiere').addEventListener('change', function() {
    const b11Group = document.getElementById('gaz-b11-group');
    const b11RefoulementGroup = document.getElementById('gaz-b11-refoulement-group');
    if (this.value === 'B11') {
        b11Group.style.display = 'block';
        b11RefoulementGroup.style.display = 'block';
    } else {
        b11Group.style.display = 'none';
        b11RefoulementGroup.style.display = 'none';
    }
});

document.getElementById('gaz-condensation').addEventListener('change', function() {
    const condensatsGroup = document.getElementById('gaz-condensats-group');
    condensatsGroup.style.display = this.checked ? 'block' : 'none';
});

/**
 * Initialise le module de vérifications réglementaires complémentaires
 */
function initReglementairesComp() {
    // Conformité installation gaz
    const regletteVaso = document.getElementById('comp-reglette-vaso');
    const roai = document.getElementById('comp-roai');
    const distances = document.getElementById('comp-distances');
    
    // Ventilation cuisine
    const hotteType = document.getElementById('comp-hotte-type');
    const asservissementGroup = document.getElementById('comp-asservissement-group');
    const asservissement = document.getElementById('comp-asservissement');
    
    // Évacuation fumées
    const materiauEvac = document.getElementById('comp-evac-materiau');
    const penteEvac = document.getElementById('comp-evac-pente');
    const longueurEvac = document.getElementById('comp-evac-longueur');
    const coudesEvac = document.getElementById('comp-evac-coudes');
    
    // VMC gaz
    const dsc = document.getElementById('comp-vmc-gaz-dsc');
    const testCo = document.getElementById('comp-vmc-gaz-test-co');
    
    // Écouteurs pour la conformité gaz
    [regletteVaso, roai, distances].forEach(el => {
        if (el) el.addEventListener('change', verifierConformiteGaz);
    });
    
    // Gestion de l'asservissement pour les hottes motorisées
    if (hotteType) {
        hotteType.addEventListener('change', function() {
            if (this.value === 'motorisee') {
                asservissementGroup.style.display = 'block';
            } else {
                asservissementGroup.style.display = 'none';
            }
            verifierVentilationCuisine();
        });
    }
    
    if (asservissement) {
        asservissement.addEventListener('change', verifierVentilationCuisine);
    }
    
    // Écouteurs pour l'évacuation des fumées
    [materiauEvac, penteEvac, longueurEvac, coudesEvac].forEach(el => {
        if (el) el.addEventListener('input', verifierEvacuationFumees);
    });
    
    // Écouteurs pour VMC gaz
    [dsc, testCo].forEach(el => {
        if (el) el.addEventListener('change', verifierVmcGaz);
    });
}

/**
 * Vérification de la conformité gaz
 */
function verifierConformiteGaz() {
    const regletteVaso = document.getElementById('comp-reglette-vaso').checked;
    const roai = document.getElementById('comp-roai').checked;
    const distances = document.getElementById('comp-distances').checked;
    const resultElement = document.getElementById('result-conformite-gaz-comp');
    
    const isConforme = regletteVaso && roai && distances;
    
    let messages = [];
    
    messages.push(regletteVaso ? '✅ Réglette VASO présente et conforme' : '⚠️ Réglette VASO non conforme');
    messages.push(roai ? '✅ Robinet ROAI présent et accessible' : '⚠️ Robinet ROAI non conforme');
    messages.push(distances ? '✅ Distances de sécurité respectées' : '⚠️ Distances de sécurité non respectées');
    
    // Afficher le résultat
    resultElement.innerHTML = `
        <p class="${isConforme ? 'success' : 'error'}">
            <strong>${isConforme ? '✅ INSTALLATION CONFORME' : '⚠️ INSTALLATION NON CONFORME'}</strong>
        </p>
        <ul>
            ${messages.map(msg => `<li>${msg}</li>`).join('')}
        </ul>
    `;
}

/**
 * Vérification de la ventilation cuisine
 */
function verifierVentilationCuisine() {
    const hotteType = document.getElementById('comp-hotte-type').value;
    const asservissement = document.getElementById('comp-asservissement')?.checked || false;
    const resultElement = document.getElementById('result-ventilation-cuisine');
    
    let isConforme = true;
    let messages = [];
    
    if (hotteType === 'motorisee') {
        if (!asservissement) {
            messages.push('⚠️ Hotte motorisée sans asservissement (risque avec appareil type B)');
            isConforme = false;
        } else {
            messages.push('✅ Hotte motorisée avec asservissement correct');
        }
    } else if (hotteType === 'passive') {
        messages.push('✅ Hotte passive (statique)');
    } else {
        messages.push('✅ Pas de hotte installée');
    }
    
    // Afficher le résultat
    resultElement.innerHTML = `
        <p class="${isConforme ? 'success' : 'error'}">
            <strong>${isConforme ? '✅ VENTILATION CUISINE CONFORME' : '⚠️ VENTILATION CUISINE NON CONFORME'}</strong>
        </p>
        <ul>
            ${messages.map(msg => `<li>${msg}</li>`).join('')}
        </ul>
    `;
}

/**
 * Vérification de l'évacuation des fumées
 */
function verifierEvacuationFumees() {
    const materiau = document.getElementById('comp-evac-materiau').value;
    const pente = parseFloat(document.getElementById('comp-evac-pente').value);
    const longueur = parseFloat(document.getElementById('comp-evac-longueur').value);
    const coudes = parseInt(document.getElementById('comp-evac-coudes').value);
    const resultElement = document.getElementById('result-evacuation-fumees');
    
    if (!materiau || isNaN(pente) || isNaN(longueur) || isNaN(coudes)) {
        resultElement.innerHTML = '<p>Veuillez remplir tous les champs</p>';
        return;
    }
    
    let isConforme = true;
    let messages = [];
    
    // Vérifier le matériau (PVC interdit pour type B)
    if (materiau.toLowerCase().includes('pvc')) {
        messages.push('⚠️ PVC interdit avec appareil type B');
        isConforme = false;
    } else {
        messages.push(`✅ Matériau ${materiau} conforme`);
    }
    
    // Vérifier la pente
    if (pente < 3) {
        messages.push('⚠️ Pente insuffisante (min. 3%)');
        isConforme = false;
    } else {
        messages.push(`✅ Pente ${pente}% suffisante`);
    }
    
    // Vérifier le nombre de coudes
    if (coudes > 3) {
        messages.push('⚠️ Trop de coudes (max. 3)');
        isConforme = false;
    } else {
        messages.push(`✅ Nombre de coudes (${coudes}) conforme`);
    }
    
    // Vérifier la longueur
    if (longueur > 10) {
        messages.push('⚠️ Longueur excessive (vérifier tirage)');
        isConforme = false;
    } else {
        messages.push(`✅ Longueur ${longueur}m conforme`);
    }
    
    // Afficher le résultat
    resultElement.innerHTML = `
        <p class="${isConforme ? 'success' : 'error'}">
            <strong>${isConforme ? '✅ ÉVACUATION FUMÉES CONFORME' : '⚠️ ÉVACUATION FUMÉES NON CONFORME'}</strong>
        </p>
        <ul>
            ${messages.map(msg => `<li>${msg}</li>`).join('')}
        </ul>
    `;
}

/**
 * Vérification de la VMC gaz
 */
function verifierVmcGaz() {
    const dsc = document.getElementById('comp-vmc-gaz-dsc').checked;
    const testCo = document.getElementById('comp-vmc-gaz-test-co').checked;
    const resultElement = document.getElementById('result-vmc-gaz');
    
    const isConforme = dsc && testCo;
    
    let messages = [];
    
    messages.push(dsc ? '✅ DSC présent et fonctionnel' : '⚠️ DSC absent ou non fonctionnel');
    messages.push(testCo ? '✅ Test CO ambiant conforme' : '⚠️ Test CO ambiant non conforme ou non effectué');
    
    // Afficher le résultat avec info sur anomalie 32c
    resultElement.innerHTML = `
        <p class="${isConforme ? 'success' : 'error'}">
            <strong>${isConforme ? '✅ VMC GAZ CONFORME' : '⚠️ VMC GAZ NON CONFORME'}</strong>
        </p>
        <ul>
            ${messages.map(msg => `<li>${msg}</li>`).join('')}
        </ul>
        ${!isConforme ? '<p class="error"><strong>Attention:</strong> Anomalie 32c - Risque CO grave et immédiat</p>' : ''}
    `;
}

/**
 * Initialise le module Export PDF
 */
function initExportPDF() {
    // Création dynamique des cases à cocher pour les modules
    const moduleSelection = document.getElementById('pdf-module-selection');
    const modules = document.querySelectorAll('.module-section');
    
    if (moduleSelection) {
        modules.forEach(module => {
            const id = module.id;
            const title = module.querySelector('h2').textContent;
            
            const checkbox = document.createElement('div');
            checkbox.className = 'checkbox';
            checkbox.innerHTML = `
                <input type="checkbox" id="pdf-include-${id}" checked>
                <label for="pdf-include-${id}">${title}</label>
            `;
            
            moduleSelection.appendChild(checkbox);
        });
    }
    
    // Bouton génération PDF
    const generateButton = document.getElementById('btn-generate-pdf');
    if (generateButton) {
        generateButton.addEventListener('click', generatePdf);
    }
}

/**
 * Génération du PDF
 */
function generatePdf() {
    const clientName = document.getElementById('pdf-client-name').value;
    const clientAddress = document.getElementById('pdf-client-address').value;
    const remarks = document.getElementById('pdf-remarks').value;
    
    // Vérifier que le nom client est renseigné
    if (!clientName) {
        alert('Veuillez saisir le nom du client');
        return;
    }
    
    // Créer un clone du contenu pour le PDF
    const pdfContent = document.createElement('div');
    pdfContent.className = 'pdf-content';
    
    // Ajouter l'en-tête
    const header = document.createElement('div');
    header.className = 'pdf-header';
    header.innerHTML = `
        <h1>Rapport d'intervention - Chauffage Expert</h1>
        <div class="client-info">
            <p><strong>Client:</strong> ${clientName}</p>
            <p><strong>Adresse:</strong> ${clientAddress || 'Non spécifiée'}</p>
            <p><strong>Date:</strong> ${new Date().toLocaleDateString()}</p>
            <p><strong>Technicien:</strong> ${preferences.technicien || 'Non spécifié'}</p>
        </div>
    `;
    
    pdfContent.appendChild(header);
    
    // Ajouter les remarques
    if (remarks) {
        const remarksSection = document.createElement('div');
        remarksSection.className = 'pdf-remarks';
        remarksSection.innerHTML = `
            <h2>Remarques / Travaux effectués</h2>
            <p>${remarks.replace(/\n/g, '<br>')}</p>
        `;
        pdfContent.appendChild(remarksSection);
    }
    
    // Ajouter les modules sélectionnés
    document.querySelectorAll('#pdf-module-selection input[type="checkbox"]:checked').forEach(checkbox => {
        const moduleId = checkbox.id.replace('pdf-include-', '');
        const moduleElement = document.getElementById(moduleId);
        
        if (moduleElement) {
            const moduleClone = moduleElement.cloneNode(true);
            
            // Nettoyer les éléments non nécessaires dans le PDF
            moduleClone.querySelectorAll('input, select, button').forEach(el => {
                el.style.display = 'none';
            });
            
            pdfContent.appendChild(moduleClone);
        }
    });
    
    // Ajouter le pied de page
    const footer = document.createElement('div');
    footer.className = 'pdf-footer';
    footer.innerHTML = `
        <p>Document généré par Chauffage Expert - ${new Date().toLocaleDateString()}</p>
    `;
    pdfContent.appendChild(footer);
    
    // Afficher l'aperçu
    const previewArea = document.getElementById('pdf-preview-area');
    previewArea.innerHTML = '';
    previewArea.appendChild(pdfContent.cloneNode(true));
    previewArea.style.display = 'block';
    
    // Générer le PDF avec html2pdf
    const opt = {
        margin: 10,
        filename: `rapport_intervention_${clientName.replace(/\s/g, '_')}.pdf`,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };
    
    // Création du PDF
    html2pdf().set(opt).from(pdfContent).save();
}

/**
 * Initialise le module Préférences
 */
function initPreferences() {
    // Prénom du technicien
    const technicianName = document.getElementById('pref-technician-name');
    if (technicianName) {
        technicianName.value = preferences.technicien || '';
    }
    
    // Thème
    const theme = document.getElementById('pref-theme');
    if (theme) {
        theme.value = themeManager ? themeManager.getCurrentTheme() : preferences.theme || 'light';
        
        theme.addEventListener('change', function() {
            const newTheme = this.value;
            if (themeManager) {
                themeManager.setTheme(newTheme);
            }
            preferences.theme = newTheme;
            savePreferences();
        });
    }
    
    // Unité de température
    const tempUnit = document.getElementById('pref-units-temp');
    if (tempUnit) {
        tempUnit.value = preferences.temperatureUnit || 'C';
    }
    
    // Logo preview
    const logoPreview = document.getElementById('pref-logo-preview');
    if (logoPreview && preferences.logo) {
        logoPreview.src = preferences.logo;
        logoPreview.style.display = 'block';
    }
    
    // Gestion du logo
    const logoInput = document.getElementById('pref-logo');
    if (logoInput) {
        logoInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    preferences.logo = e.target.result;
                    logoPreview.src = e.target.result;
                    logoPreview.style.display = 'block';
                };
                
                reader.readAsDataURL(this.files[0]);
            }
        });
    }
    
    // Bouton de sauvegarde
    const saveButton = document.getElementById('btn-save-prefs');
    if (saveButton) {
        saveButton.addEventListener('click', function() {
            preferences.technicien = technicianName ? technicianName.value : '';
            preferences.temperatureUnit = tempUnit ? tempUnit.value : 'C';
            savePreferences();
            alert('Préférences enregistrées !');
        });
    }
}

// Fonction pour calculer le nombre de pièces selon le type de logement
function getNombrePieces(typeLogement) {
    const piecesParType = {
        'T1': 1,
        'T2': 2,
        'T3': 3,
        'T4': 4,
        'T5': 5,
        'T6': 6
    };
    return piecesParType[typeLogement] || 1;
}

// Fonction pour calculer le nombre de personnes selon le type de logement
function getNombrePersonnes(typeLogement) {
    const personnesParType = {
        'T1': 1,
        'T2': 2,
        'T3': 3,
        'T4': 4,
        'T5': 5,
        'T6': 6
    };
    return personnesParType[typeLogement] || 1;
}

// Fonction pour mettre à jour tous les calculs liés au type de logement
function updateCalculsLogement(typeLogement) {
    if (!typeLogement) return;
    
    const nbPieces = getNombrePieces(typeLogement);
    const nbPersonnes = getNombrePersonnes(typeLogement);
    
    // Mise à jour du nombre de radiateurs
    const radNombre = document.getElementById('rad-nombre');
    radNombre.value = nbPieces;
    
    // Mise à jour des dimensions recommandées
    updateDimensionsRecommandees(typeLogement);
    
    // Mise à jour du débit VMC
    const debitVMC = calculDebitVMC(typeLogement);
    document.getElementById('vmc-debit-mh').value = debitVMC;
    
    // Mise à jour de la puissance de chauffage recommandée
    updatePuissanceChauffageRecommandee(typeLogement);
    
    // Mise à jour du débit ECS
    const debitECS = nbPersonnes * CONFIG.ECS.DEBIT_PAR_PERSONNE;
    document.getElementById('ecs-debit').value = debitECS;
    
    // Mise à jour de la pression du vase d'expansion
    updatePressionVaseExpansion();
    
    // Mise à jour de tous les calculs
    calculPuissanceChauffage();
    calculPuissanceRadiateur();
    verifierVmc();
    calculEcs();
    calculVaseExpansion();
}

// Fonction pour calculer la pression du vase d'expansion
function updatePressionVaseExpansion() {
    const hauteur = parseFloat(document.getElementById('vase-hauteur').value);
    if (isNaN(hauteur)) return;
    
    const pression = (hauteur / 10 + 0.3) * CONFIG.VASE_EXPANSION.COEF_SECURITE;
    document.getElementById('vase-pression').textContent = pression.toFixed(1);
}

// Fonction pour vérifier la cohérence entre tous les modules
function verifierCohérenceGlobale() {
    // Vérification puissance chaudière/radiateurs
    verifierCohérencePuissance();
    
    // Vérification ECS
    verifierCohérenceECS();
    
    // Vérification VMC
    verifierCohérenceVMC();
    
    // Vérification vase d'expansion
    verifierCohérenceVaseExpansion();
}

// Fonction pour vérifier la cohérence ECS
function verifierCohérenceECS() {
    const puissanceChaudiere = parseFloat(document.getElementById('chauffage-puissance').textContent);
    const puissanceECS = parseFloat(document.getElementById('ecs-puissance-restituee').textContent);
    
    if (isNaN(puissanceChaudiere) || isNaN(puissanceECS)) return;
    
    const resultElement = document.getElementById('result-ecs');
    const pourcentage = (puissanceECS / puissanceChaudiere) * 100;
    
    let message = '';
    if (pourcentage > 30) {
        message = `⚠️ Puissance ECS élevée par rapport à la chaudière (${Math.round(pourcentage)}%)`;
    } else {
        message = `✅ Puissance ECS cohérente avec la chaudière (${Math.round(pourcentage)}%)`;
    }
    
    resultElement.innerHTML += `<p class="coherence-message">${message}</p>`;
}

// Fonction pour vérifier la cohérence VMC
function verifierCohérenceVMC() {
    const typeLogement = document.getElementById('logement-type').value;
    const debitMesure = parseFloat(document.getElementById('vmc-debit-mh').value);
    const debitRecommandé = calculDebitVMC(typeLogement);
    
    if (isNaN(debitMesure)) return;
    
    const resultElement = document.getElementById('result-vmc');
    const pourcentage = (debitMesure / debitRecommandé) * 100;
    
    let message = '';
    if (pourcentage < 80) {
        message = `⚠️ Débit VMC insuffisant (${Math.round(pourcentage)}% du débit recommandé)`;
    } else if (pourcentage > 120) {
        message = `⚠️ Débit VMC excessif (${Math.round(pourcentage)}% du débit recommandé)`;
    } else {
        message = `✅ Débit VMC conforme (${Math.round(pourcentage)}% du débit recommandé)`;
    }
    
    resultElement.innerHTML += `<p class="coherence-message">${message}</p>`;
}

// Fonction pour vérifier la cohérence vase d'expansion
function verifierCohérenceVaseExpansion() {
    const hauteur = parseFloat(document.getElementById('vase-hauteur').value);
    const pression = parseFloat(document.getElementById('vase-pression').textContent);
    
    if (isNaN(hauteur) || isNaN(pression)) return;
    
    const resultElement = document.getElementById('result-vase-expansion');
    const pressionCalculée = (hauteur / 10 + 0.3) * CONFIG.VASE_EXPANSION.COEF_SECURITE;
    const difference = Math.abs(pression - pressionCalculée);
    
    let message = '';
    if (difference > 0.2) {
        message = `⚠️ Pression vase d'expansion non optimale (différence de ${difference.toFixed(1)} bar)`;
    } else {
        message = `✅ Pression vase d'expansion conforme`;
    }
    
    resultElement.innerHTML += `<p class="coherence-message">${message}</p>`;
}