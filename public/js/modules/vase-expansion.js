/**
 * Module Vase d'Expansion - Calculs et visualisations
 */

/**
 * Calcule la pression du vase d'expansion en fonction de la hauteur du bâtiment
 * et de la position du radiateur le plus éloigné
 */
export function calculerVaseExpansion() {
    const hauteur = parseFloat(document.getElementById('hauteurBatiment').value);
    const plusLoin = document.getElementById('radiateurPlusLoin').value;

    if (!isNaN(hauteur)) {
        const pression = (hauteur / 10 + 0.3).toFixed(1);
        let tours = plusLoin === 'oui' ? 'Réglage de base : 1,5 tours' : 'Réglage à adapter en fonction du réseau';

        document.getElementById('resVase').innerHTML =
            `💧 Pression de gonflage recommandée : <strong>${pression} bar</strong><br>` +
            `🔧 ${tours}`;
    } else {
        document.getElementById('resVase').innerHTML = '⚠️ Veuillez renseigner la hauteur du bâtiment.';
    }
}

/**
 * Gonfle visuellement le vase d'expansion (animation)
 */
export function gonflerVase() {
  const vaseImage = document.getElementById('vaseImage');
  const pressionVase = document.getElementById('pressionVase');
  
  if (vaseImage && pressionVase) {
    vaseImage.style.transform = 'scale(1.1)';
    pressionVase.innerText = "1,5 bar";
  }
}

/**
 * Dégonfle visuellement le vase d'expansion (animation)
 */
export function degonflerVase() {
  const vaseImage = document.getElementById('vaseImage');
  const pressionVase = document.getElementById('pressionVase');
  
  if (vaseImage && pressionVase) {
    vaseImage.style.transform = 'scale(1)';
    pressionVase.innerText = "1,0 bar";
  }
}

/**
 * Initialisation du module Vase d'Expansion
 */
export function initVaseExpansion() {
    document.addEventListener('DOMContentLoaded', () => {
        // Initialiser la calculatrice de vase d'expansion
        const calculerButton = document.getElementById('calculerVase');
        if (calculerButton && !calculerButton.hasListener) {
            calculerButton.addEventListener('click', calculerVaseExpansion);
            calculerButton.hasListener = true;
        }
        
        // Initialiser le vase interactif
        const vaseContainer = document.getElementById('vaseContainer');
        if (vaseContainer) {
            vaseContainer.addEventListener('mouseover', gonflerVase);
            vaseContainer.addEventListener('mouseout', degonflerVase);
        }
    });
}

// Auto-initialisation
initVaseExpansion();
