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
        // ...
    }
}