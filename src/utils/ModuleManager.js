/**
 * Gestionnaire de modules pour l'application d'entretien de chaudière
 */
class ModuleManager {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.modules = new Map();
        this.currentModule = null;
        this.loadingModule = false;
        
        // S'assurer que le conteneur existe
        if (!this.container) {
            console.error(`Conteneur avec ID '${containerId}' non trouvé dans le DOM.`);
            this.container = document.createElement('div');
            this.container.id = containerId;
            document.body.appendChild(this.container);
            console.warn(`Un conteneur de substitution a été créé avec l'ID '${containerId}'.`);
        }
    }

    /**
     * Charge un module à partir de son chemin
     * @param {string} path - Le chemin du module
     * @returns {Promise<Object>} - Le module chargé
     */
    async loadModule(path) {
        try {
            // Normaliser le chemin pour la cohérence
            if (!path.startsWith('/')) {
                path = `/${path}`;
            }
            
            // Vérifier si le module est déjà chargé
            if (this.modules.has(path)) {
                console.log(`Module ${path} déjà chargé, réutilisation.`);
                return this.modules.get(path);
            }

            console.log(`Chargement du module: ${path}`);
            
            // Tenter de charger le module
            try {
                const modulePath = `./src/modules${path}/index.js`;
                
                // Utiliser loadScript pour charger le module
                if (window.helpers && typeof window.helpers.loadScript === 'function') {
                    await window.helpers.loadScript(modulePath);
                } else {
                    throw new Error("window.helpers ou la méthode loadScript n'est pas définie.");
                }
                    console.log(`Script chargé avec succès: ${modulePath}`);
                } catch (scriptError) {
                    console.error(`Erreur lors du chargement du script ${modulePath}:`, scriptError);
                    throw scriptError;
                }

                // Si le chargement a réussi, le module devrait être disponible dans window.modules[path]
                if (window.modules && window.modules[path]) {
                    const module = window.modules[path];
                    
                    // Vérifier que le module a une méthode render
                    if (!module.render || typeof module.render !== 'function') {
                        throw new Error(`Le module ${path} n'a pas de méthode render valide.`);
                    }
                    
                    this.modules.set(path, module);
                    return module;
                } else {
                    throw new Error(`Le module ${path} n'a pas été correctement enregistré.`);
                }
            } catch (importError) {
                console.warn(`Impossible de charger le module ${path}, création d'un module de secours.`);
                
                // Créer un module d'erreur
                const errorModule = this.createErrorModule(path, importError);
                this.modules.set(path, errorModule);
                return errorModule;
            }
        } catch (error) {
            console.error(`Erreur lors du chargement du module ${path}:`, error);
            throw error;
        }
    }

    /**
     * Affiche un module dans le conteneur
     * @param {string} path - Le chemin du module à afficher
     */
    async renderModule(path) {
        try {
            // Vérifier si nous sommes déjà en train de charger un module
            if (this.loadingModule) {
                console.warn('Chargement de module déjà en cours, veuillez patienter...');
                return;
            }

            this.loadingModule = true;
            
            // Mémoriser le module précédent pour pouvoir y revenir si nécessaire
            const previousModule = this.currentModule;
            
            // Indiquer que le chargement est en cours
            this.showLoadingIndicator();
            
            const module = await this.loadModule(path);
            
            // Nettoyer le conteneur et préparer pour le nouveau module
            this.container.innerHTML = '';
            
            // Appliquer une classe au conteneur pour le style spécifique au module
            const moduleClass = path.replace(/[^a-zA-Z0-9]/g, '-').replace(/^-|-$/g, '');
            this.container.className = `module-container module-${moduleClass}`;
            
            // Rendre le module avec gestion des erreurs
            try {
                await module.render(this.container);
                this.currentModule = path;
                
                // Vérifier l'initialisation des champs de saisie (particulièrement important pour TopGaz)
                if (path.includes('topgaz')) {
                    this.verifyInputFieldsInitialization();
                }
                
                // Déclencher un événement pour signaler que le module est chargé
                const event = new CustomEvent('moduleLoaded', { 
                    detail: { path, module } 
                });
                window.dispatchEvent(event);
                
            } catch (renderError) {
                console.error(`Erreur lors du rendu du module ${path}:`, renderError);
                this.showRenderErrorUI(path, renderError, previousModule);
            }
        } catch (error) {
            console.error(`Erreur générale lors du rendu du module ${path}:`, error);
            this.showModuleErrorUI(path, error);
        } finally {
            this.loadingModule = false;
        }
    }

    /**
     * Affiche un indicateur de chargement
     */
    showLoadingIndicator() {
        this.container.innerHTML = `
            <div class="loading-indicator">
                <div class="spinner"></div>
                <p>Chargement du module en cours...</p>
            </div>
        `;
    }

    /**
     * Affiche une interface d'erreur de rendu
     */
    showRenderErrorUI(path, error, previousModule) {
        this.container.innerHTML = `
            <div class="error-message">
                <h2>Erreur de rendu</h2>
                <p>Une erreur s'est produite lors du rendu du module "${path}".</p>
                <div class="error-details">
                    <p><strong>Détails:</strong> ${error.message}</p>
                </div>
                <div class="error-actions">
                    <button id="retry-render-btn">Réessayer</button>
                    ${previousModule ? `<button id="go-back-btn">Revenir au module précédent</button>` : ''}
                </div>
            </div>
        `;
        
        // Configurer les boutons d'action
        setTimeout(() => {
            const retryBtn = this.container.querySelector('#retry-render-btn');
            if (retryBtn) {
                retryBtn.addEventListener('click', () => {
                    this.modules.delete(path); // Forcer le rechargement
                    this.renderModule(path);
                });
            }
            
            const backBtn = this.container.querySelector('#go-back-btn');
            if (backBtn && previousModule) {
                backBtn.addEventListener('click', () => {
                    this.renderModule(previousModule);
                });
            }
        }, 0);
    }

    /**
     * Affiche une interface d'erreur de module
     */
    showModuleErrorUI(path, error) {
        this.container.innerHTML = `
            <div class="error-message">
                <h2>Erreur</h2>
                <p>Impossible de charger le module demandé.</p>
                <div class="error-details">
                    <p><strong>Détails:</strong> ${error.message}</p>
                </div>
                <div class="error-actions">
                    <button id="retry-module-load-btn">Réessayer</button>
                </div>
            </div>
        `;
        
        // Configurer le bouton pour réessayer
        setTimeout(() => {
            const retryBtn = this.container.querySelector('#retry-module-load-btn');
            if (retryBtn) {
                retryBtn.addEventListener('click', () => {
                    this.renderModule(path);
                });
            }
        }, 0);
    }

    /**
     * Crée un module d'erreur
     */
    createErrorModule(path, error) {
        return {
            render: async (container) => {
                container.innerHTML = `
                    <div class="error-module">
                        <h2>Module non disponible</h2>
                        <p>Le module que vous essayez de charger (${path}) n'est pas disponible.</p>
                        <div class="error-details">
                            <p><strong>Erreur:</strong> ${error.message}</p>
                        </div>
                        <button id="refresh-module-btn" class="btn-primary">Réessayer</button>
                    </div>
                `;
                
                const refreshBtn = container.querySelector('#refresh-module-btn');
                if (refreshBtn) {
                    refreshBtn.addEventListener('click', () => {
                        this.modules.delete(path);
                        this.renderModule(path);
                    });
                }
            }
        };
    }

    /**
     * Vérifie l'initialisation des champs de saisie
     */
    verifyInputFieldsInitialization() {
        console.log("Vérification des champs de saisie...");
        
        // Sélectionner tous les champs de saisie dans le conteneur
        const inputFields = this.container.querySelectorAll('input, textarea, select');
        
        if (inputFields.length === 0) {
            console.warn("Aucun champ de saisie trouvé dans le module.");
            return;
        }
        
        console.log(`${inputFields.length} champs de saisie trouvés. Vérification des listeners...`);
        
        // Pour les modules TopGaz, appliquer une correction spécifique
        if (this.currentModule && this.currentModule.includes('topgaz')) {
            this.fixTopGazInputFields(inputFields);
        }
        
        // Ajouter des vérificateurs de focus pour le débogage
        inputFields.forEach((field, index) => {
            const originalFocus = field.onfocus;
            field.onfocus = function(e) {
                console.log(`Champ ${index} a reçu le focus`, e.target);
                if (originalFocus) originalFocus.call(this, e);
            };
            
            // Vérifier si le champ est désactivé ou en lecture seule
            if (field.disabled) {
                console.warn(`Champ ${index} (${field.name || field.id || 'sans nom'}) est désactivé`);
            }
            
            if (field.readOnly) {
                console.warn(`Champ ${index} (${field.name || field.id || 'sans nom'}) est en lecture seule`);
            }
        });
    }
    
    /**
     * Correction spécifique pour les champs de saisie TopGaz
     */
    fixTopGazInputFields(inputFields) {
        console.log("Application de correctifs pour les champs de saisie TopGaz...");
        
        inputFields.forEach((field) => {
            // Réinitialiser les états qui pourraient bloquer la saisie
            field.disabled = false;
            field.readOnly = false;
            
            // S'assurer que les événements sont correctement liés
            field.addEventListener('click', (e) => {
                e.stopPropagation(); // Empêcher la propagation qui pourrait interférer
            });
            
            // Forcer une mise à jour du modèle pour les frameworks réactifs
            field.addEventListener('input', (e) => {
                console.log(`Saisie détectée dans ${e.target.name || e.target.id || 'champ sans nom'}:`, e.target.value);
                
                // Déclencher un événement personnalisé que le module peut écouter
                const inputEvent = new CustomEvent('topgazInput', {
                    bubbles: true,
                    detail: { field: e.target, value: e.target.value }
                });
                e.target.dispatchEvent(inputEvent);
            });
        });
        
        console.log("Correctifs appliqués aux champs de saisie TopGaz.");
    }

    /**
     * Retourne le module actuellement affiché
     */
    getCurrentModule() {
        return this.currentModule;
    }

    /**
     * Liste tous les modules disponibles
     */
    getAvailableModules() {
        return window.MODULES || [];
    }
}

// Exporter le gestionnaire de modules
window.ModuleManager = ModuleManager;