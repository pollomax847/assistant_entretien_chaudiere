/**
 * Point d'entrée principal de l'application
 * Initialise les modules et configure les écouteurs d'événements
 */

import { calculerEcsInstantane } from './modules/ecs.js';
import { calculerPuissanceChauffage, calculerPuissanceRadiateur, calculerVaseExpansion } from './modules/chauffage.js';
import { calculerDebitGaz, calculerTopGaz, verifierConformiteGaz, verifierVentilation, verifierEvacuation } from './modules/gaz.js';
import { formatResult, formatDetails } from './utils/formatters.js';
import { isValidNumber, validateRequiredFields, showFormValidationErrors, resetFormValidation } from './utils/validation.js';

/**
 * Initialise l'application
 */
function initApp() {
    // Initialise la navigation
    initNavigation();
    
    // Initialise les calculs ECS
    initEcsCalculations();
    
    // Initialise les calculs chauffage
    initChauffageCalculations();
    
    // Initialise les vérifications gaz
    initGazVerifications();
    
    // Initialise les événements UI génériques
    initUIEvents();
    
    console.log('Application initialisée avec succès');
}

/**
 * Initialise la navigation et la barre de progression
 */
function initNavigation() {
    // Navigation fluide
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                window.scrollTo({
                    top: target.offsetTop - 100,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Mise à jour de la barre de progression
    function updateProgress() {
        const progressBar = document.getElementById('progressBar');
        if (!progressBar) return;
        
        const windowHeight = window.innerHeight;
        const documentHeight = document.documentElement.scrollHeight - windowHeight;
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        // Mise à jour de la barre de progression
        const progress = (scrollTop / documentHeight) * 100;
        progressBar.style.width = progress + '%';
        
        // Mise en évidence du lien actif
        const sections = document.querySelectorAll('section');
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 120;
            const sectionBottom = sectionTop + section.offsetHeight;
            const link = document.querySelector(`a[href="#${section.id}"]`);
            
            if (link && scrollTop >= sectionTop && scrollTop < sectionBottom) {
                link.classList.add('active');
            } else if (link) {
                link.classList.remove('active');
            }
        });
    }
    
    window.addEventListener('scroll', updateProgress);
    window.addEventListener('load', updateProgress);
}

/**
 * Initialise les calculs ECS
 */
function initEcsCalculations() {
    const form = document.getElementById('formEcs');
    if (!form) return;
    
    ['tempEfs', 'tempEcs', 'debitEcs', 'puissanceChaudiere'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', () => {
                const tempEfs = parseFloat(document.getElementById('tempEfs').value);
                const tempEcs = parseFloat(document.getElementById('tempEcs').value);
                const debit = parseFloat(document.getElementById('debitEcs').value);
                const puissanceChaudiere = parseFloat(document.getElementById('puissanceChaudiere').value);
                
                const result = calculerEcsInstantane(tempEfs, tempEcs, debit, puissanceChaudiere);
                
                if (result.success) {
                    document.getElementById('deltaTEcs').value = result.deltaT;
                }
                
                let resultHTML = '';
                if (result.success) {
                    resultHTML += `<p>🌡️ ΔT : <strong>${result.deltaT} °C</strong></p>`;
                    resultHTML += `<p>🚿 Débit : <strong>${result.debit} L/min</strong></p>`;
                    resultHTML += `<p>⚡ Puissance restituée : <strong>${result.puissanceRestituee} kW</strong></p>`;
                    
                    if (result.coherence) {
                        const colorClass = result.coherence === 'bonne' ? 'success' : 
                                        (result.coherence === 'faible' ? 'error' : 'warning');
                        resultHTML += `<p class="${colorClass}">${result.coherence === 'bonne' ? '✅' : '⚠️'} ${result.messageCoherence}</p>`;
                    }
                }
                
                document.getElementById('resEcsInstantane').innerHTML = resultHTML;
            });
        }
    });
}

/**
 * Initialise les calculs chauffage
 */
function initChauffageCalculations() {
    // Calcul de puissance chauffage
    const form = document.getElementById('formChauffage');
    if (!form) return;

    ['volChauff', 'coefG', 'tempExt'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', () => {
                resetFormValidation(form);
                
                if (!form.checkValidity()) {
                    showFormValidationErrors(form);
                    return;
                }
                
                const volume = parseFloat(document.getElementById('volChauff').value);
                const coefG = parseFloat(document.getElementById('coefG').value);
                const tempExt = parseFloat(document.getElementById('tempExt').value);
                
                const result = calculerPuissanceChauffage(volume, coefG, tempExt);
                
                document.getElementById('resChauffage').innerHTML = formatResult(
                    result.success, 
                    result.message,
                    { type: result.success ? 'success' : 'error' }
                );
            });
        }
    });

    // Calcul de puissance radiateur
    ['typeRadiateur', 'hauteurRad', 'longueurRad', 'typePanneau'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', () => {
                const type = document.getElementById('typeRadiateur').value;
                const hauteur = parseInt(document.getElementById('hauteurRad').value);
                const longueur = parseInt(document.getElementById('longueurRad').value);
                const panneau = type === 'Panneaux' ? document.getElementById('typePanneau').value : null;
                
                const result = calculerPuissanceRadiateur(type, hauteur, longueur, panneau);
                
                document.getElementById('resRadiateur').innerHTML = formatResult(
                    result.success, 
                    result.message,
                    { type: result.success ? 'success' : 'error' }
                );
            });
        }
    });
    
    // Gestion du type de radiateur
    const typeRadiateurSelect = document.getElementById('typeRadiateur');
    if (typeRadiateurSelect) {
        typeRadiateurSelect.addEventListener('change', function() {
            const panneauOptions = document.getElementById('optionPanneaux');
            panneauOptions.style.display = this.value === 'Panneaux' ? 'block' : 'none';
            afficherVisuelRadiateur();
        });
    }

    // Calcul vase d'expansion
    ['hauteurBatiment', 'radiateurPlusLoin'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', () => {
                const hauteur = parseFloat(document.getElementById('hauteurBatiment').value);
                const radiateurLoin = document.getElementById('radiateurPlusLoin').value === 'oui';
                
                const result = calculerVaseExpansion(hauteur, radiateurLoin);
                
                document.getElementById('resVase').innerHTML = formatResult(
                    result.success, 
                    result.message,
                    { type: result.success ? 'success' : 'error' }
                );
            });
        }
    });
}

/**
 * Initialise les vérifications gaz
 */
function initGazVerifications() {
    // Vérification conformité gaz
    ['regletteVaso', 'roai', 'distances'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('change', () => {
                const regletteVaso = document.getElementById('regletteVaso').checked;
                const roai = document.getElementById('roai').checked;
                const distances = document.getElementById('distances').checked;
                
                const result = verifierConformiteGaz({
                    regletteVaso,
                    roai,
                    distances
                });
                
                let resultHTML = formatResult(
                    result.success, 
                    result.message,
                    { type: result.conforme ? 'success' : 'error' }
                );
                
                if (result.details && result.details.length > 0) {
                    resultHTML += formatDetails(result.details);
                }
                
                document.getElementById('resConformiteGaz').innerHTML = resultHTML;
            });
        }
    });
    
    // Vérification ventilation
    ['typeHotte', 'typeAppareil', 'volumePiece', 'clapet', 'asservissement'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener(input.type === 'checkbox' ? 'change' : 'input', () => {
                const typeHotte = document.getElementById('typeHotte').value;
                const typeAppareil = document.getElementById('typeAppareil').value;
                const volumePiece = parseFloat(document.getElementById('volumePiece').value);
                const clapet = document.getElementById('clapet').checked;
                const asservissement = document.getElementById('asservissement').checked;
                
                const result = verifierVentilation(typeHotte, typeAppareil, volumePiece, clapet, asservissement);
                
                let resultHTML = formatResult(
                    result.success, 
                    result.message,
                    { type: result.conforme ? 'success' : 'error' }
                );
                
                if (result.details && result.details.length > 0) {
                    resultHTML += formatDetails(result.details);
                }
                
                document.getElementById('resVentilation').innerHTML = resultHTML;
            });
        }
    });

    // Calcul Top Gaz - déjà automatique
    ['digit1', 'digit2', 'digit3', 'dureeTop', 'typeGaz', 'puissChaudiereGaz'].forEach(id => {
        const input = document.getElementById(id);
        if (input) {
            input.addEventListener('input', () => {
                const digit1 = parseInt(document.getElementById('digit1').value) || 0;
                const digit2 = parseInt(document.getElementById('digit2').value) || 0;
                const digit3 = parseInt(document.getElementById('digit3').value) || 0;
                const duree = parseInt(document.getElementById('dureeTop').value);
                const pcs = parseFloat(document.getElementById('typeGaz').value);
                const puissChaudiere = parseFloat(document.getElementById('puissChaudiereGaz').value);
                
                const result = calculerTopGaz(digit1, digit2, digit3, duree, pcs, puissChaudiere);
                
                let resultHTML = '';
                if (result.success) {
                    resultHTML += `<p>📊 Volume mesuré : <strong>${result.volume} L</strong></p>`;
                    resultHTML += `<p>⏱️ Durée du test : <strong>${result.duree} secondes</strong></p>`;
                    resultHTML += `<p>💨 Débit horaire : <strong>${result.debitHoraire} m³/h</strong></p>`;
                    resultHTML += `<p>⚡ Puissance mesurée : <strong>${result.puissance} kW</strong></p>`;
                    
                    if (result.ecart) {
                        const colorClass = result.coherence === 'oui' ? 'success' : 'warning';
                        resultHTML += `<p class="${colorClass}">${result.coherence === 'oui' ? '✅' : '⚠️'} ${result.messageCoherence}</p>`;
                    }
                }
                
                document.getElementById('resTopGaz').innerHTML = resultHTML;
            });
        }
    });
}

/**
 * Initialise les événements UI génériques
 */
function initUIEvents() {
    // Gestion de l'affichage visuel du radiateur
    function afficherVisuelRadiateur() {
        const type = document.getElementById("typeRadiateur")?.value;
        const visuel = document.getElementById("visuelRadiateur");
        const panneauOptions = document.getElementById("optionPanneaux");
        
        if (!type || !visuel) return;
        
        let fichier = "";
        
        if (type === "Panneaux") {
            if (panneauOptions) panneauOptions.style.display = "block";
            const typePanneau = document.getElementById("typePanneau")?.value;
            fichier = `images/radiateurs/${typePanneau}.png`;
        } else {
            if (panneauOptions) panneauOptions.style.display = "none";
            fichier = `images/radiateurs/${type.toLowerCase()}.png`;
        }
        
        if (fichier) {
            visuel.innerHTML = `<img src="${fichier}" alt="${type}" style="max-width:100%; border:1px solid #ccc; border-radius:4px;">`;
        } else {
            visuel.innerHTML = "";
        }
    }
    
    // Exécuter l'affichage au chargement et à la modification
    if (document.getElementById("typeRadiateur")) {
        document.getElementById("typeRadiateur").addEventListener("change", afficherVisuelRadiateur);
        if (document.getElementById("typePanneau")) {
            document.getElementById("typePanneau").addEventListener("change", afficherVisuelRadiateur);
        }
        afficherVisuelRadiateur();
    }
    
    // Gestion de l'exportation PDF
    const btnExport = document.querySelector('.btn-export');
    if (btnExport) {
        btnExport.addEventListener('click', function() {
            alert("Fonctionnalité d'export PDF à implémenter");
            // TODO: Implémenter l'export PDF avec jsPDF ou une autre bibliothèque
        });
    }
}

// Initialisation de l'application au chargement de la page
document.addEventListener('DOMContentLoaded', initApp);