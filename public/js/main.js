/**
 * Fichier principal pour charger les modules partagés
 */

// Importation des modules nécessaires
import { verifierVMC, initVMC } from './modules/vmc.js';
import { calculerVaseExpansion, initVaseExpansion } from './modules/vase-expansion.js';

// Initialisation globale
document.addEventListener('DOMContentLoaded', () => {
  console.log("Application initialisée");
  
  // Initialisation des modules
  initModules();
});

/**
 * Initialise tous les modules nécessaires
 */
function initModules() {
  // Détection des modules présents sur la page
  const modules = {
    vmc: document.getElementById('verifierVMC'),
    vase: document.getElementById('calculerVase'),
    // Ajouter ici d'autres modules au besoin
  };
  
  // Initialiser les modules détectés
  if (modules.vmc) initVMC();
  if (modules.vase) initVaseExpansion();
  
  console.log('Modules initialisés');
}