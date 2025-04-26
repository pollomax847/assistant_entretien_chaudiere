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

    const form = document.getElementById('maintenance-form');
    const resultContainer = document.getElementById('result-container');
    const pdfContainer = document.getElementById('pdf-container');
    const generatePdfBtn = document.getElementById('generate-pdf');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Collect form data
            const formData = {
                clientName: document.getElementById('client-name').value,
                clientAddress: document.getElementById('client-address').value,
                clientPhone: document.getElementById('client-phone').value,
                clientEmail: document.getElementById('client-email').value,
                boilerType: document.getElementById('boiler-type').value,
                maintenanceDate: document.getElementById('maintenance-date').value,
                technician: document.getElementById('technician-name').value,
                notes: document.getElementById('notes').value
            };
            
            // Display results
            displayResults(formData);
            
            // Show result container
            resultContainer.style.display = 'block';
        });
    }
    
    // Generate PDF when button is clicked
    if (generatePdfBtn) {
        generatePdfBtn.addEventListener('click', function() {
            // Clone the result content for PDF
            pdfContainer.innerHTML = document.getElementById('result-content').innerHTML;
            
            // Add company header for the PDF
            const companyHeader = document.createElement('div');
            companyHeader.innerHTML = '<h2>Rapport d\'entretien de chaudière</h2><p>Service professionnel d\'entretien de chaudières</p>';
            pdfContainer.prepend(companyHeader);
            
            // Generate PDF
            html2pdf()
                .from(pdfContainer)
                .save('rapport-entretien-chaudiere.pdf');
        });
    }
    
    // Function to display results
    function displayResults(data) {
        const resultContent = document.getElementById('result-content');
        
        if (!resultContent) return;
        
        const currentDate = new Date().toLocaleDateString();
        
        resultContent.innerHTML = `
            <h2>Rapport d'Entretien de Chaudière</h2>
            <p><strong>Date du rapport:</strong> ${currentDate}</p>
            <p><strong>Client:</strong> ${data.clientName}</p>
            <p><strong>Adresse:</strong> ${data.clientAddress}</p>
            <p><strong>Téléphone:</strong> ${data.clientPhone}</p>
            <p><strong>Email:</strong> ${data.clientEmail}</p>
            <p><strong>Type de chaudière:</strong> ${data.boilerType}</p>
            <p><strong>Date d'entretien:</strong> ${data.maintenanceDate}</p>
            <p><strong>Technicien:</strong> ${data.technician}</p>
            <h3>Observations:</h3>
            <p>${data.notes}</p>
            <h3>Recommandations:</h3>
            <p>Il est recommandé d'effectuer un entretien annuel de votre chaudière pour en optimiser la performance et la durée de vie.</p>
        `;
    }
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