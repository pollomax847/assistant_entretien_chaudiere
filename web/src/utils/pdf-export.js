// Initialisation de la signature électronique
let signaturePad = null;

document.addEventListener('DOMContentLoaded', () => {
    initializeSignaturePad();
    setupPDFExport();
});

function initializeSignaturePad() {
    const canvas = document.getElementById('signature-pad');
    if (!canvas) return;

    signaturePad = new SignaturePad(canvas, {
        backgroundColor: 'rgba(255, 255, 255, 0)',
        penColor: 'rgb(0, 0, 0)'
    });

    // Gestion du redimensionnement
    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();

    // Effacer la signature
    document.getElementById('clear-signature').addEventListener('click', () => {
        signaturePad.clear();
    });
}

function resizeCanvas() {
    const canvas = document.getElementById('signature-pad');
    const ratio = Math.max(window.devicePixelRatio || 1, 1);
    canvas.width = canvas.offsetWidth * ratio;
    canvas.height = canvas.offsetHeight * ratio;
    canvas.getContext("2d").scale(ratio, ratio);
    signaturePad.clear(); // Efface la signature après le redimensionnement
}

function setupPDFExport() {
    const form = document.getElementById('export-pdf-form');
    if (!form) return;

    // Prévisualisation
    document.getElementById('preview-pdf').addEventListener('click', generatePDFPreview);
    
    // Génération du PDF
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        generatePDF();
    });
}

function generatePDFPreview() {
    const previewFrame = document.getElementById('preview-frame');
    const pdfPreview = document.getElementById('pdf-preview');
    
    // Afficher la prévisualisation
    pdfPreview.classList.remove('hidden');
    
    // Générer le contenu HTML pour la prévisualisation
    const content = generatePDFContent();
    previewFrame.srcdoc = content;
}

function generatePDF() {
    const content = generatePDFContent();
    
    // Options de génération PDF
    const options = {
        margin: 10,
        filename: 'rapport-intervention.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    // Générer le PDF
    html2pdf().set(options).from(content).save();
}

function generatePDFContent() {
    const form = document.getElementById('export-pdf-form');
    const selectedModules = Array.from(form.querySelectorAll('input[name="modules"]:checked'))
        .map(checkbox => checkbox.value);
    
    // Récupérer les données du formulaire
    const clientName = document.getElementById('client-name').value;
    const clientAddress = document.getElementById('client-address').value;
    const interventionDate = document.getElementById('intervention-date').value;
    const interventionType = document.getElementById('intervention-type').value;
    const observations = document.getElementById('observations').value;
    
    // Récupérer le logo de l'entreprise
    const companyLogo = localStorage.getItem('companyLogo');
    
    // Générer le HTML pour le PDF
    let html = `
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .header { text-align: center; margin-bottom: 30px; }
                .logo { max-width: 200px; margin-bottom: 20px; }
                .section { margin-bottom: 20px; }
                .signature { margin-top: 50px; }
                table { width: 100%; border-collapse: collapse; }
                th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                th { background-color: #f2f2f2; }
            </style>
        </head>
        <body>
            <div class="header">
                ${companyLogo ? `<img src="${companyLogo}" class="logo" alt="Logo entreprise">` : ''}
                <h1>Rapport d'Intervention</h1>
            </div>
            
            <div class="section">
                <h2>Informations Client</h2>
                <p><strong>Nom :</strong> ${clientName}</p>
                <p><strong>Adresse :</strong> ${clientAddress}</p>
                <p><strong>Date :</strong> ${interventionDate}</p>
                <p><strong>Type d'intervention :</strong> ${interventionType}</p>
            </div>
    `;
    
    // Ajouter les modules sélectionnés
    selectedModules.forEach(module => {
        const moduleData = getModuleData(module);
        if (moduleData) {
            html += `
                <div class="section">
                    <h2>${moduleData.title}</h2>
                    ${moduleData.content}
                </div>
            `;
        }
    });
    
    // Ajouter les observations et la signature
    html += `
            <div class="section">
                <h2>Observations</h2>
                <p>${observations}</p>
            </div>
            
            <div class="signature">
                <h2>Signature du technicien</h2>
                ${signaturePad ? `<img src="${signaturePad.toDataURL()}" alt="Signature" style="max-width: 200px;">` : ''}
                <p>Date : ${new Date().toLocaleDateString()}</p>
            </div>
        </body>
        </html>
    `;
    
    return html;
}

function getModuleData(moduleId) {
    // Récupérer les données du module depuis le localStorage
    const moduleData = localStorage.getItem(`module_${moduleId}`);
    if (!moduleData) return null;
    
    return JSON.parse(moduleData);
}

// Sauvegarder les données du module
function saveModuleData(moduleId, data) {
    localStorage.setItem(`module_${moduleId}`, JSON.stringify(data));
}

// Charger les données du module
function loadModuleData(moduleId) {
    const data = localStorage.getItem(`module_${moduleId}`);
    return data ? JSON.parse(data) : null;
} 