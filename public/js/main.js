/**
 * Fichier principal pour les fonctionnalités de l'application
 */

// Initialisation globale
document.addEventListener('DOMContentLoaded', () => {
  console.log("Application initialisée");
  
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
  
  // Initialize form handling
  const form = document.getElementById('maintenance-form');
  if (form) {
    form.addEventListener('submit', handleFormSubmit);
  }
});

/**
 * Handle form submission and generate report
 */
function handleFormSubmit(e) {
  e.preventDefault();
  
  // Collect form data
  const formData = {
    clientName: document.getElementById('client-name')?.value || '',
    clientAddress: document.getElementById('client-address')?.value || '',
    clientPhone: document.getElementById('client-phone')?.value || '',
    clientEmail: document.getElementById('client-email')?.value || '',
    boilerType: document.getElementById('boiler-type')?.value || '',
    maintenanceDate: document.getElementById('maintenance-date')?.value || '',
    technician: document.getElementById('technician-name')?.value || '',
    notes: document.getElementById('notes')?.value || ''
  };
  
  // Display results
  const resultContainer = document.getElementById('result-container');
  const resultContent = document.getElementById('result-content');
  
  if (resultContainer && resultContent) {
    const currentDate = new Date().toLocaleDateString();
    
    resultContent.innerHTML = `
      <h2>Rapport d'Entretien de Chaudière</h2>
      <p><strong>Date du rapport:</strong> ${currentDate}</p>
      <p><strong>Client:</strong> ${formData.clientName}</p>
      <p><strong>Adresse:</strong> ${formData.clientAddress}</p>
      <p><strong>Téléphone:</strong> ${formData.clientPhone}</p>
      <p><strong>Email:</strong> ${formData.clientEmail}</p>
      <p><strong>Type de chaudière:</strong> ${formData.boilerType}</p>
      <p><strong>Date d'entretien:</strong> ${formData.maintenanceDate}</p>
      <p><strong>Technicien:</strong> ${formData.technician}</p>
      <h3>Observations:</h3>
      <p>${formData.notes}</p>
      <h3>Recommandations:</h3>
      <p>Il est recommandé d'effectuer un entretien annuel de votre chaudière pour en optimiser la performance et la durée de vie.</p>
    `;
    
    resultContainer.style.display = 'block';
  }
}

/**
 * Generate PDF from report content
 */
function generatePDF() {
  const resultContent = document.getElementById('result-content');
  const pdfContainer = document.getElementById('pdf-container');
  
  if (resultContent && pdfContainer) {
    // Clone the result content for PDF
    pdfContainer.innerHTML = resultContent.innerHTML;
    
    // Add company header for the PDF
    const companyHeader = document.createElement('div');
    companyHeader.innerHTML = '<h2>Rapport d\'entretien de chaudière</h2><p>Service professionnel d\'entretien de chaudières</p>';
    pdfContainer.prepend(companyHeader);
    
    // Generate PDF using html2pdf library
    if (typeof html2pdf === 'function') {
      html2pdf()
        .from(pdfContainer)
        .save('rapport-entretien-chaudiere.pdf');
    } else {
      console.error('html2pdf library not loaded');
    }
  }
}

// Add event listener for PDF generation button
document.addEventListener('DOMContentLoaded', () => {
  const generatePdfBtn = document.getElementById('generate-pdf');
  if (generatePdfBtn) {
    generatePdfBtn.addEventListener('click', generatePDF);
  }
});