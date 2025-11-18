/**
 * Application d'entretien de chaudière - Point d'entrée
 */
document.addEventListener('DOMContentLoaded', async () => {
    console.log('Initialisation de l\'application...');
    
    // Définir les modules disponibles
    window.MODULES = [
        {
            id: 'topgaz',
            name: 'TopGaz',
            description: 'Gestion des données TopGaz',
            icon: 'fa-fire',
            color: '#e74c3c'
        },
        {
            id: 'clients',
            name: 'Clients',
            description: 'Gestion des clients',
            icon: 'fa-users',
            color: '#3498db'
        },
        {
            id: 'interventions',
            name: 'Interventions',
            description: 'Suivi des interventions',
            icon: 'fa-tools',
            color: '#2ecc71'
        },
        {
            id: 'rapports',
            name: 'Rapports',
            description: 'Génération de rapports',
            icon: 'fa-file-alt',
            color: '#f39c12'
        },
        {
            id: 'reglementation-gaz',
            name: 'Réglementation Gaz',
            description: 'Vérification conformité selon l\'arrêté du 23 février 2018',
            icon: 'fa-clipboard-check',
            color: '#e67e22'
        }
    ];
    
    try {
        // Initialiser le gestionnaire de modules avec le conteneur principal
        const moduleManager = new ModuleManager('app-container');
        
        // Charger la page d'accueil
        await moduleManager.initHomePage();
        
        console.log('Application initialisée avec succès!');
    } catch (error) {
        console.error('Erreur lors de l\'initialisation de l\'application:', error);
    }
});
