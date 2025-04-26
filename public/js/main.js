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

  // Set the current date as the default for the maintenance date input
  const datePicker = document.getElementById('maintenance-date');
  
  if (datePicker) {
    const today = new Date();
    const year = today.getFullYear();
    let month = today.getMonth() + 1;
    let day = today.getDate();
    
    // Add leading zero if needed
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;
    
    const formattedDate = `${year}-${month}-${day}`;
    datePicker.value = formattedDate;
  }

  // Add smooth scrolling for all links
  const links = document.querySelectorAll('a[href^="#"]');
  
  for (const link of links) {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      
      const targetId = this.getAttribute('href');
      if (targetId === '#') return;
      
      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        window.scrollTo({
          top: targetElement.offsetTop - 50,
          behavior: 'smooth'
        });
      }
    });
  }

  // Add validation for phone number input
  const phoneInput = document.getElementById('client-phone');
  if (phoneInput) {
    phoneInput.addEventListener('input', function(e) {
      // Remove any non-digit characters
      this.value = this.value.replace(/[^\d]/g, '');
      
      // Format the phone number (French format)
      if (this.value.length > 0) {
        let formatted = '';
        for (let i = 0; i < this.value.length && i < 10; i++) {
          if (i % 2 === 0 && i > 0) formatted += ' ';
          formatted += this.value[i];
        }
        this.value = formatted;
      }
    });
  }
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