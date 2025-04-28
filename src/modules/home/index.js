/**
 * Module d'accueil - Affiche les cartes des modules disponibles
 */
(function() {
    // Déclarer le module
    if (!window.modules) window.modules = {};
    
    const modulePath = '/home';
    
    // Configuration du module
    const homeModule = {
        /**
         * Récupère la liste des modules disponibles
         * @returns {Array} Liste des modules
         */
        getModulesList: function() {
            // Si une liste de modules est définie globalement, l'utiliser
            if (window.MODULES && Array.isArray(window.MODULES)) {
                return window.MODULES;
            }
            
            // Sinon, renvoyer une liste par défaut
            return [
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
                }
            ];
        },
        
        /**
         * Crée une carte pour un module
         * @param {Object} module Informations sur le module
         * @returns {HTMLElement} Élément de carte
         */
        createModuleCard: function(module) {
            const card = document.createElement('div');
            card.className = 'module-card';
            card.dataset.moduleId = module.id;
            
            // Appliquer la couleur de fond si spécifiée
            if (module.color) {
                card.style.borderColor = module.color;
            }
            
            // Créer le contenu de la carte
            card.innerHTML = `
                <div class="card-icon" style="background-color: ${module.color || '#607d8b'}">
                    <i class="fas ${module.icon || 'fa-cube'}"></i>
                </div>
                <div class="card-content">
                    <h3>${module.name || 'Module sans nom'}</h3>
                    <p>${module.description || 'Aucune description disponible'}</p>
                </div>
                <div class="card-action">
                    <button>Accéder</button>
                </div>
            `;
            
            // Ajouter un gestionnaire d'événement pour le clic
            card.addEventListener('click', () => {
                this.loadModule(module.id);
            });
            
            return card;
        },
        
        /**
         * Charge un module sélectionné
         * @param {string} moduleId Identifiant du module à charger
         */
        loadModule: function(moduleId) {
            // Vérifier que le ModuleManager est disponible
            if (!window.moduleManager) {
                console.error('ModuleManager non disponible');
                alert('Impossible de charger le module: gestionnaire de modules non disponible');
                return;
            }
            
            // Afficher un effet de chargement sur la carte
            const card = document.querySelector(`.module-card[data-module-id="${moduleId}"]`);
            if (card) {
                card.classList.add('loading');
            }
            
            // Charger le module
            window.moduleManager.renderModule(moduleId)
                .catch(error => {
                    console.error(`Erreur lors du chargement du module ${moduleId}:`, error);
                    alert(`Erreur lors du chargement du module ${moduleId}`);
                    
                    // Retirer l'effet de chargement
                    if (card) {
                        card.classList.remove('loading');
                    }
                });
        },
        
        /**
         * Affiche le module dans le conteneur
         * @param {HTMLElement} container Élément conteneur
         * @returns {Promise<void>}
         */
        render: async function(container) {
            // Charger le style du module
            await this.loadStyle();
            
            // Créer la structure de base
            container.innerHTML = `
                <div class="home-container">
                    <header class="home-header">
                        <h1>Assistant d'entretien de chaudière</h1>
                        <p>Sélectionnez un module pour commencer</p>
                    </header>
                    <div class="modules-grid" id="modules-grid">
                        <!-- Les cartes des modules seront ajoutées ici -->
                    </div>
                </div>
            `;
            
            // Récupérer la liste des modules et créer les cartes
            const modulesList = this.getModulesList();
            const modulesGrid = container.querySelector('#modules-grid');
            
            if (modulesList && modulesList.length > 0) {
                modulesList.forEach(module => {
                    const card = this.createModuleCard(module);
                    modulesGrid.appendChild(card);
                });
            } else {
                modulesGrid.innerHTML = `
                    <div class="no-modules">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p>Aucun module disponible</p>
                    </div>
                `;
            }
        },
        
        /**
         * Charge le style du module
         * @returns {Promise<void>}
         */
        loadStyle: async function() {
            return new Promise((resolve, reject) => {
                // Vérifier si le style est déjà chargé
                if (document.getElementById('home-module-style')) {
                    resolve();
                    return;
                }
                
                // Créer l'élément style
                const style = document.createElement('style');
                style.id = 'home-module-style';
                style.textContent = `
                    .home-container {
                        padding: 20px;
                        max-width: 1200px;
                        margin: 0 auto;
                    }
                    
                    .home-header {
                        text-align: center;
                        margin-bottom: 40px;
                    }
                    
                    .home-header h1 {
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }
                    
                    .home-header p {
                        color: #7f8c8d;
                    }
                    
                    .modules-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                        gap: 20px;
                    }
                    
                    .module-card {
                        background-color: #fff;
                        border-radius: 8px;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                        transition: transform 0.3s, box-shadow 0.3s;
                        border-top: 4px solid #ddd;
                        cursor: pointer;
                    }
                    
                    .module-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                    }
                    
                    .card-icon {
                        padding: 20px;
                        text-align: center;
                        font-size: 3rem;
                        color: white;
                    }
                    
                    .card-content {
                        padding: 20px;
                    }
                    
                    .card-content h3 {
                        margin-top: 0;
                        margin-bottom: 10px;
                        color: #34495e;
                    }
                    
                    .card-content p {
                        color: #7f8c8d;
                        margin-bottom: 0;
                    }
                    
                    .card-action {
                        padding: 15px 20px;
                        background-color: #f9f9f9;
                        text-align: right;
                        border-top: 1px solid #eee;
                    }
                    
                    .card-action button {
                        background-color: #3498db;
                        color: white;
                        border: none;
                        padding: 8px 15px;
                        border-radius: 4px;
                        cursor: pointer;
                        transition: background-color 0.2s;
                    }
                    
                    .card-action button:hover {
                        background-color: #2980b9;
                    }
                    
                    .module-card.loading {
                        opacity: 0.7;
                        pointer-events: none;
                    }
                    
                    .no-modules {
                        grid-column: 1 / -1;
                        text-align: center;
                        padding: 40px;
                        color: #7f8c8d;
                    }
                    
                    .no-modules i {
                        font-size: 3rem;
                        margin-bottom: 15px;
                    }
                    
                    @media (max-width: 768px) {
                        .modules-grid {
                            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                        }
                    }
                `;
                
                // Ajouter le style au document
                document.head.appendChild(style);
                resolve();
            });
        }
    };
    
    // Exporter le module
    window.modules[modulePath] = homeModule;
})();
