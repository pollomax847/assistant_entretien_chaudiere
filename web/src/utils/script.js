// Ajouter les écouteurs d'événements pour tous les champs de saisie
document.addEventListener('DOMContentLoaded', function() {
    // Attacher les écouteurs aux champs de saisie
    document.querySelectorAll('input, select').forEach(input => {
        input.addEventListener(input.type === 'checkbox' ? 'change' : 'input', calcule);
    });

    // Lancer un premier calcul au chargement
    try {
        calcule();
    } catch (e) {
        console.log('Fonction calcule non disponible ou erreur:', e);
    }
    
    // Ne plus gérer directement la vérification VMC ici
    // Le module VMC s'en charge maintenant
    
    // Initialiser autres écouteurs généraux
    initGeneralListeners();
});

function calcule() {
    // Implémentation de la fonction de calcul
    console.log('Fonction calcule exécutée');
    
    // Vérifier s'il y a des calculs spécifiques à exécuter
    calculeEmetteur();
}

/**
 * Initialise les écouteurs d'événements généraux
 */
function initGeneralListeners() {
    // Gestion du type d'émetteur
    document.querySelectorAll('input[name="typeEmetteur"]').forEach(radio => {
        radio.addEventListener('change', function () {
            document.getElementById('radiateur-params').style.display =
                this.value === 'radiateur' ? 'block' : 'none';
            document.getElementById('plancher-params').style.display =
                this.value === 'plancher' ? 'block' : 'none';
            calcule();
        });
    });
    
    // Navigation fluide pour les ancres
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                window.scrollTo({
                    top: target.offsetTop - 100,
                    behavior: 'smooth'
                });
            }
        });
    });
}

/**
 * Calcul pour les émetteurs
 */
function calculeEmetteur() {
    const type = document.querySelector('input[name="typeEmetteur"]:checked')?.value;
    if (!type) return;
    
    if (type === 'radiateur') {
        // Calculs spécifiques pour les radiateurs
        const puissance = parseFloat(document.getElementById('puissanceRad')?.value || 0);
        const tempDepart = parseFloat(document.getElementById('tempDepartRad')?.value || 0);
        const tempRetour = parseFloat(document.getElementById('tempRetourRad')?.value || 0);
        
        if (puissance > 0 && tempDepart > 0 && tempRetour > 0) {
            const deltaT = tempDepart - tempRetour;
            const debit = deltaT > 0 ? (puissance / (deltaT * 1.16)).toFixed(2) : 0;
            
            const resultat = document.getElementById('resEmetteur');
            if (resultat) {
                resultat.textContent = `Débit nécessaire : ${debit} L/h`;
            }
        }
    } else if (type === 'plancher') {
        // Calculs spécifiques pour les planchers chauffants
        const puissance = parseFloat(document.getElementById('puissancePlancher')?.value || 0);
        const tempDepart = parseFloat(document.getElementById('tempDepartPlancher')?.value || 0);
        const tempRetour = parseFloat(document.getElementById('tempRetourPlancher')?.value || 0);
        const surfacePlancher = parseFloat(document.getElementById('surfacePlancher')?.value || 0);
        
        if (puissance > 0 && tempDepart > 0 && tempRetour > 0 && surfacePlancher > 0) {
            // Calcul du débit d'eau dans le plancher chauffant
            const deltaT = tempDepart - tempRetour;
            const debit = deltaT > 0 ? (puissance / (deltaT * 1.16)).toFixed(2) : 0;
            
            // Calcul de la puissance par m²
            const puissanceParM2 = (puissance / surfacePlancher).toFixed(2);
            
            // Calcul de l'écartement des tubes recommandé (en cm)
            // Formule approximative basée sur la puissance par m²
            let ecartementTubes = 0;
            if (puissanceParM2 < 60) {
                ecartementTubes = 20; // Écartement plus large pour basse puissance
            } else if (puissanceParM2 < 90) {
                ecartementTubes = 15; // Écartement moyen
            } else {
                ecartementTubes = 10; // Écartement plus serré pour haute puissance
            }
            
            const resultat = document.getElementById('resEmetteur');
            if (resultat) {
                resultat.innerHTML = `
                    <p><strong>Débit nécessaire:</strong> ${debit} L/h</p>
                    <p><strong>Puissance/m²:</strong> ${puissanceParM2} W/m²</p>
                    <p><strong>Écartement recommandé:</strong> ${ecartementTubes} cm</p>
                `;
            }
        }
    }
}

/**
 * Script contenant les fonctions utilitaires pour l'application
 */

// Fonctions génériques de calcul
/**
 * Convertit une température entre Celsius et Fahrenheit
 * @param {number} value - Valeur de température à convertir
 * @param {string} from - Unité d'origine ('celsius' ou 'fahrenheit')
 * @returns {number} Température convertie
 */
function convertTemperature(value, from = 'celsius') {
    if (from.toLowerCase() === 'celsius') {
        return (value * 9/5) + 32; // °C vers °F
    } else {
        return (value - 32) * 5/9; // °F vers °C
    }
}

/**
 * Calcule la puissance nécessaire pour le chauffage
 * @param {number} surface - Surface du local en m²
 * @param {number} hauteur - Hauteur sous plafond en m
 * @param {number} coefG - Coefficient G d'isolation
 * @param {number} tempInt - Température intérieure souhaitée en °C
 * @param {number} tempExt - Température extérieure de base en °C
 * @returns {number} Puissance en kW
 */
function calculerPuissanceChauffage(surface, hauteur, coefG, tempInt, tempExt) {
    const volume = surface * hauteur;
    const deltaT = tempInt - tempExt;
    return (coefG * volume * deltaT) / 1000;
}

/**
 * Calcule la pression théorique pour un vase d'expansion
 * @param {number} hauteur - Hauteur du bâtiment en m
 * @param {boolean} radiateurEloigne - Si le radiateur le plus éloigné est au dernier étage
 * @returns {number} Pression théorique en bar
 */
function calculerPressionVase(hauteur, radiateurEloigne) {
    let pression = (hauteur / 10) + 0.3;
    if (radiateurEloigne) {
        pression += 0.2;
    }
    return pression;
}

// Fonctions pour la VMC
/**
 * Vérifie la conformité d'une installation VMC
 * @param {string} typeVMC - Type de VMC
 * @param {number} nbBouches - Nombre de bouches
 * @param {number} debitMesure - Débit total mesuré en m³/h
 * @param {number} debitMS - Débit en m/s
 * @param {boolean} modulesFenetre - Conformité des modules aux fenêtres
 * @param {boolean} etalonnagePortes - Vérification de l'étalonnage des portes
 * @returns {object} Résultat de la vérification
 */
function verifierConformiteVMC(typeVMC, nbBouches, debitMesure, debitMS, modulesFenetre, etalonnagePortes) {
    // Normes VMC
    const normesVMC = {
        simple_flux: { debitMin: 15, debitMax: 30 },
        sanitaire: { debitMin: 20, debitMax: 40 },
        sekoia: { debitMin: 25, debitMax: 45 },
        vti: { debitMin: 30, debitMax: 50 }
    };
    
    let messages = [];
    let estConforme = true;
    
    // Vérification du débit
    const norme = normesVMC[typeVMC];
    const debitParBouche = debitMesure / nbBouches;
    
    if (debitParBouche < norme.debitMin) {
        messages.push(`Le débit par bouche (${debitParBouche.toFixed(2)} m³/h) est inférieur au minimum requis (${norme.debitMin} m³/h).`);
        estConforme = false;
    }
    
    if (debitParBouche > norme.debitMax) {
        messages.push(`Le débit par bouche (${debitParBouche.toFixed(2)} m³/h) est supérieur au maximum autorisé (${norme.debitMax} m³/h).`);
        estConforme = false;
    }
    
    // Vérification du débit en m/s
    if (debitMS < 0.8 || debitMS > 2.5) {
        messages.push(`Le débit en m/s (${debitMS.toFixed(1)}) est hors plage recommandée (0.8 - 2.5 m/s)`);
        estConforme = false;
    }
    
    // Vérification des modules aux fenêtres
    if (!modulesFenetre) {
        messages.push('Les modules aux fenêtres ne sont pas conformes');
        estConforme = false;
    }
    
    // Vérification de l'étalonnage des portes
    if (!etalonnagePortes) {
        messages.push("L'étalonnage des portes n'a pas été vérifié");
        estConforme = false;
    }
    
    return {
        estConforme,
        messages,
        details: {
            debitTotal: debitMesure,
            debitParBouche: debitParBouche.toFixed(2),
            debitMS: debitMS.toFixed(1)
        }
    };
}

// Exportation des fonctions pour les modules ES
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        convertTemperature,
        calculerPuissanceChauffage,
        calculerPressionVase,
        verifierConformiteVMC
    };
}