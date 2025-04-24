import html2pdf from 'html2pdf.js';
import { PreferencesManager } from './PreferencesManager.js';

export class PDFExporter {
    constructor() {
        this.prefsManager = new PreferencesManager();
    }

    async generatePDF(moduleData, clientInfo) {
        try {
            const content = this.generateHTMLContent(moduleData, clientInfo);
            
            const options = {
                margin: 10,
                filename: `rapport_${clientInfo.nom}_${new Date().toISOString().split('T')[0]}.pdf`,
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            await html2pdf().set(options).from(content).save();
            
            return {
                success: true,
                message: 'PDF généré avec succès'
            };
        } catch (error) {
            console.error('Erreur lors de la génération du PDF:', error);
            return {
                success: false,
                message: 'Erreur lors de la génération du PDF'
            };
        }
    }

    generateHTMLContent(moduleData, clientInfo) {
        const technicien = this.prefsManager.getPreference('technicien');
        const logo = this.prefsManager.getPreference('logo');
        
        return `
            <div class="pdf-container">
                <header>
                    ${logo ? `<img src="${logo}" class="logo" alt="Logo entreprise">` : ''}
                    <h1>Rapport d'intervention</h1>
                    <div class="client-info">
                        <p><strong>Client:</strong> ${clientInfo.nom}</p>
                        <p><strong>Adresse:</strong> ${clientInfo.adresse}</p>
                        <p><strong>Date:</strong> ${new Date().toLocaleDateString()}</p>
                        <p><strong>Technicien:</strong> ${technicien}</p>
                    </div>
                </header>
                
                <main>
                    ${this.generateModuleContent(moduleData)}
                </main>
                
                <footer>
                    <p>Rapport généré par Chauffage Expert</p>
                    <p>© ${new Date().getFullYear()}</p>
                </footer>
            </div>
        `;
    }

    generateModuleContent(moduleData) {
        let content = '';
        
        for (const [moduleName, data] of Object.entries(moduleData)) {
            content += `
                <section class="module-section">
                    <h2>${moduleName}</h2>
                    <div class="module-content">
                        ${this.formatModuleData(data)}
                    </div>
                </section>
            `;
        }
        
        return content;
    }

    formatModuleData(data) {
        if (typeof data === 'object') {
            return Object.entries(data)
                .map(([key, value]) => `<p><strong>${key}:</strong> ${value}</p>`)
                .join('');
        }
        return `<p>${data}</p>`;
    }
} 