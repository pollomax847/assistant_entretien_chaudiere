/**
 * Script de débogage amélioré pour l'application Chauffage Expert
 * Aide à identifier et résoudre les problèmes d'accès aux modules et les erreurs CORS
 * Version 2.0 - Correction automatique des problèmes courants
 */

// Activer uniquement en développement
const DEBUG = true;

if (DEBUG) {
    // Initialiser le système de débogage dès le début
    console.log('Système de débogage initialisé...');
    
    // Créer un espace de noms pour nos utilitaires de débogage
    window.AppDebug = {
        initialized: false,
        errors: [],
        fixedPaths: {},
        moduleStatus: {},
        config: {
            autoFix: true,
            logLevel: 'info', // 'error', 'warn', 'info', 'debug'
            useLocalServer: false,
            localServerPort: 8000
        }
    };
    
    // Enregistrer les erreurs existantes
    window.addEventListener('error', function(event) {
        // Stocker l'erreur pour analyse
        window.AppDebug.errors.push({
            message: event.message,
            filename: event.filename,
            lineno: event.lineno,
            colno: event.colno,
            timestamp: new Date(),
            stack: event.error ? event.error.stack : null
        });

        // Afficher l'erreur dans la console avec des informations supplémentaires
        console.error('Erreur capturée:', event.message, 
            '\nDans:', event.filename, 
            '\nLigne:', event.lineno, 
            '\nColonne:', event.colno,
            '\nTimestamp:', new Date().toISOString());
        
        // Afficher une notification d'erreur en haut de la page
        const errorNotif = document.createElement('div');
        errorNotif.className = 'debug-error-notification';
        errorNotif.textContent = `Erreur: ${event.message} (${event.filename.split('/').pop()})`;
        errorNotif.style.cssText = 'position: fixed; top: 0; left: 0; right: 0; background: #ff5252; color: white; padding: 10px; z-index: 9999; text-align: center;';
        
        // Ajouter un bouton pour corriger automatiquement les erreurs courantes
        const fixBtn = document.createElement('button');
        fixBtn.textContent = 'Réparer';
        fixBtn.style.cssText = 'margin-left: 15px; padding: 2px 8px; background: #fff; color: #ff5252; border: none; border-radius: 4px; cursor: pointer;';
        fixBtn.onclick = function() {
            window.AppDebug.autoFix();
            // Ne pas supprimer la notification pour montrer que la réparation est en cours
            errorNotif.textContent = `Tentative de réparation en cours... Actualisez la page dans quelques secondes.`;
            setTimeout(() => {
                if (document.body.contains(errorNotif)) {
                    document.body.removeChild(errorNotif);
                }
            }, 3000);
        };
        errorNotif.appendChild(fixBtn);
        
        // Ajouter un bouton pour fermer la notification
        const closeBtn = document.createElement('button');
        closeBtn.textContent = '×';
        closeBtn.style.cssText = 'float: right; background: transparent; border: none; color: white; font-size: 20px; cursor: pointer;';
        closeBtn.onclick = function() { 
            if (document.body.contains(errorNotif)) {
                document.body.removeChild(errorNotif); 
            }
        };
        errorNotif.appendChild(closeBtn);
        
        document.body.appendChild(errorNotif);

        // Suggestions automatiques basées sur l'erreur
        if (event.message.includes("loadFavorites is not defined")) {
            console.info("Suggestion: La fonction loadFavorites manque. Une version de secours a été créée. Voir window.loadFavorites");
            window.loadFavorites = window.AppDebug.loadFavorites;
        }
        
        if (event.message.includes("NetworkError") || event.message.includes("CORS")) {
            console.info("Suggestion: Erreur CORS détectée. Utilisez startLocalServer() ou fixFilePaths()");
        }
    });

    /**
     * Système de journalisation amélioré
     */
    window.AppDebug.log = function(level, ...args) {
        const levels = ['error', 'warn', 'info', 'debug'];
        const configLevel = levels.indexOf(this.config.logLevel);
        const messageLevel = levels.indexOf(level);
        
        if (messageLevel <= configLevel) {
            const prefix = `[AppDebug:${level.toUpperCase()}]`;
            switch (level) {
                case 'error': console.error(prefix, ...args); break;
                case 'warn': console.warn(prefix, ...args); break;
                case 'info': console.info(prefix, ...args); break;
                case 'debug': console.debug(prefix, ...args); break;
                default: console.log(prefix, ...args);
            }
        }
    };

    /**
     * Détecte l'environnement d'exécution (file://, http://, etc.)
     */
    window.AppDebug.detectEnvironment = function() {
        const protocol = window.location.protocol;
        const isLocalFile = protocol === 'file:';
        const isHttp = protocol === 'http:' || protocol === 'https:';
        
        this.log('info', `Environnement détecté: ${protocol}//${window.location.host}`);
        
        return {
            isLocalFile,
            isHttp,
            protocol,
            host: window.location.host,
            pathname: window.location.pathname,
            baseUrl: window.location.origin || (isLocalFile ? 'file://' : '')
        };
    };

    /**
     * Corrige automatiquement les problèmes détectés
     */
    window.AppDebug.autoFix = function() {
        this.log('info', 'Lancement des réparations automatiques...');
        
        // Fixer les chemins de fichiers
        this.fixFilePaths();
        
        // Implémenter les fonctions manquantes
        this.implementMissingFunctions();
        
        // Créer des polyfills si nécessaire
        this.createPolyfills();
        
        // Configurer le contournement CORS
        this.setupCORSBypass();
        
        this.log('info', 'Réparations automatiques terminées.');
        
        // Essayer de recharger les modules
        setTimeout(() => {
            this.log('info', 'Tentative de rechargement des modules...');
            if (typeof initializeModules === 'function') {
                try {
                    initializeModules();
                    this.log('info', 'Modules réinitialisés avec succès.');
                } catch (e) {
                    this.log('error', 'Échec de la réinitialisation des modules:', e);
                }
            }
        }, 1000);
    };

    /**
     * Corrige les chemins de fichiers
     */
    window.AppDebug.fixFilePaths = function() {
        this.log('info', 'Correction des chemins de fichiers...');
        
        // Obtenir le chemin de base du projet
        const env = this.detectEnvironment();
        
        // Récupérer tous les éléments avec des attributs src ou href
        document.querySelectorAll('script[src], link[href], img[src], iframe[src], a[href]').forEach(elem => {
            const attr = elem.hasAttribute('src') ? 'src' : 'href';
            const originalValue = elem.getAttribute(attr);
            
            if (!originalValue) return;
            
            let newValue = originalValue;
            
            // Corriger les chemins commençant par file:///
            if (originalValue.startsWith('file:///')) {
                // Extraire le chemin relatif après le dernier répertoire connu dans le chemin file:///
                const projectPath = 'assistant ve/assitant_entreiten_chaudiere/';
                const projectIndex = originalValue.indexOf(projectPath);
                
                if (projectIndex > -1) {
                    // Le chemin contient le nom du projet, extraire le chemin relatif
                    const pathAfterProject = originalValue.substring(projectIndex + projectPath.length);
                    newValue = './' + pathAfterProject;
                } else {
                    // Fallback - utiliser un remplacement général
                    newValue = originalValue.replace(/^file:\/\/\/.*?\/([^\/]+\/)*/, './');
                }
            }
            
            // Gérer les chemins qui commencent par /
            if (originalValue.startsWith('/') && env.isLocalFile) {
                newValue = '.' + originalValue;
            }
            
            // Si le chemin a été modifié, l'appliquer
            if (newValue !== originalValue) {
                this.log('info', `Correction du chemin: ${originalValue} -> ${newValue}`);
                elem.setAttribute(attr, newValue);
                this.fixedPaths[originalValue] = newValue;
            }
        });
        
        this.log('info', `${Object.keys(this.fixedPaths).length} chemins corrigés.`);
    };

    /**
     * Implémente les fonctions manquantes
     */
    window.AppDebug.implementMissingFunctions = function() {
        // Fonction loadFavorites manquante
        if (typeof window.loadFavorites !== 'function') {
            this.log('info', 'Implémentation de la fonction loadFavorites manquante');
            window.loadFavorites = function() {
                window.AppDebug.log('info', 'Fonction loadFavorites (de secours) exécutée');
                try {
                    const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
                    window.AppDebug.log('info', `Favoris chargés: ${favorites.length} modules`);
                    return favorites;
                } catch (error) {
                    window.AppDebug.log('error', 'Erreur lors du chargement des favoris:', error);
                    return [];
                }
            };
        }

        // Fonction loadModule améliorée
        if (typeof window.loadModuleSafe !== 'function') {
            this.log('info', 'Implémentation de la fonction loadModuleSafe');
            window.loadModuleSafe = function(moduleId) {
                const moduleContainer = document.getElementById('module-container');
                if (!moduleContainer) {
                    window.AppDebug.log('error', 'Container de module non trouvé');
                    return;
                }
                
                moduleContainer.innerHTML = '<div class="loading-module">Chargement du module...</div>';
                
                // Construire l'URL avec un chemin relatif correct
                const url = `./modules/${moduleId}.html`;
                window.AppDebug.log('info', `Chargement du module: ${moduleId}, URL: ${url}`);
                
                // Utiliser XHR au lieu de fetch pour mieux gérer les erreurs et contourner certaines restrictions CORS
                const xhr = new XMLHttpRequest();
                xhr.open('GET', url, true);
                
                xhr.onload = function() {
                    if (xhr.status >= 200 && xhr.status < 300) {
                        moduleContainer.innerHTML = xhr.responseText;
                        window.AppDebug.log('info', `Module ${moduleId} chargé avec succès`);
                        
                        // Initialiser le module si la fonction existe
                        if (typeof initializeModule === 'function') {
                            try {
                                initializeModule(moduleId);
                                window.AppDebug.log('info', `Module ${moduleId} initialisé`);
                            } catch (e) {
                                window.AppDebug.log('error', `Erreur lors de l'initialisation du module ${moduleId}:`, e);
                            }
                        }
                        
                        // Mettre à jour le statut du module
                        window.AppDebug.moduleStatus[moduleId] = {
                            loaded: true,
                            timestamp: new Date(),
                            status: xhr.status
                        };
                    } else {
                        window.AppDebug.log('error', `Erreur lors du chargement du module ${moduleId}: ${xhr.status}`);
                        moduleContainer.innerHTML = `
                            <div class="error">
                                <h3>Erreur lors du chargement du module: ${moduleId}</h3>
                                <p>Statut HTTP: ${xhr.status}</p>
                                <button onclick="window.AppDebug.retryLoadModule('${moduleId}')">Réessayer</button>
                                <button onclick="window.AppDebug.createModuleTemplate('${moduleId}')">Créer un modèle</button>
                            </div>
                        `;
                        
                        // Mettre à jour le statut du module
                        window.AppDebug.moduleStatus[moduleId] = {
                            loaded: false,
                            timestamp: new Date(),
                            status: xhr.status,
                            error: `HTTP Status: ${xhr.status}`
                        };
                    }
                };
                
                xhr.onerror = function() {
                    window.AppDebug.log('error', `Erreur réseau lors du chargement du module ${moduleId}`);
                    moduleContainer.innerHTML = `
                        <div class="error">
                            <h3>Erreur réseau lors du chargement du module: ${moduleId}</h3>
                            <p>Vérifiez votre connexion ou les restrictions CORS.</p>
                            <button onclick="window.AppDebug.retryLoadModule('${moduleId}')">Réessayer</button>
                            <button onclick="window.AppDebug.createModuleTemplate('${moduleId}')">Créer un modèle</button>
                            <button onclick="window.AppDebug.startLocalServer()">Démarrer un serveur local</button>
                        </div>
                    `;
                    
                    // Mettre à jour le statut du module
                    window.AppDebug.moduleStatus[moduleId] = {
                        loaded: false,
                        timestamp: new Date(),
                        error: 'Erreur réseau'
                    };
                };
                
                xhr.send();
            };
        }
        
        // Autres fonctions potentiellement manquantes
        this.implementCommonHelpers();
    };
    
    /**
     * Implémente des helpers couramment utilisés
     */
    window.AppDebug.implementCommonHelpers = function() {
        // Helper pour des requêtes sécurisées
        window.safeRequest = function(url, options = {}) {
            const defaultOptions = {
                method: 'GET',
                credentials: 'same-origin',
                headers: {
                    'Content-Type': 'application/json'
                }
            };
            
            const requestOptions = { ...defaultOptions, ...options };
            
            // Corriger l'URL si nécessaire
            if (url.startsWith('file:///') || (url.startsWith('/') && window.AppDebug.detectEnvironment().isLocalFile)) {
                url = url.replace(/^file:\/\/\/.*?\/([^\/]+\/)*/, './').replace(/^\//, './');
                window.AppDebug.log('info', `URL corrigée pour la requête: ${url}`);
            }
            
            return fetch(url, requestOptions)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response;
                })
                .catch(error => {
                    window.AppDebug.log('error', `Erreur de requête: ${error.message}`);
                    throw error;
                });
        };
    };

    /**
     * Crée des polyfills pour les fonctions manquantes du navigateur
     */
    window.AppDebug.createPolyfills = function() {
        // Polyfill pour URL.canParse si nécessaire
        if (!URL.hasOwnProperty('canParse')) {
            URL.canParse = function(url) {
                try {
                    new URL(url);
                    return true;
                } catch (e) {
                    return false;
                }
            };
            this.log('info', 'Polyfill créé pour URL.canParse');
        }
    };

    /**
     * Configure un système pour contourner les restrictions CORS
     */
    window.AppDebug.setupCORSBypass = function() {
        // Dans un environnement local, il n'y a pas de solution simple
        // autre que d'utiliser un serveur local
        this.log('info', 'Configuration du contournement CORS...');
        
        // Créer un proxy pour fetch qui tente de contourner CORS
        const originalFetch = window.fetch;
        window.fetch = function(url, options) {
            // Si l'URL contient 'file://' ou commence par '/' dans un contexte de fichier local
            const env = window.AppDebug.detectEnvironment();
            
            if ((typeof url === 'string' && (url.startsWith('file:///') || 
                (url.startsWith('/') && env.isLocalFile)))) {
                
                // Corriger l'URL
                const fixedUrl = url.replace(/^file:\/\/\/.*?\/([^\/]+\/)*/, './').replace(/^\//, './');
                window.AppDebug.log('info', `URL fetch corrigée: ${url} -> ${fixedUrl}`);
                url = fixedUrl;
            }
            
            return originalFetch(url, options);
        };
        
        this.log('info', 'Contournement CORS configuré');
    };

    /**
     * Tente de recharger un module
     */
    window.AppDebug.retryLoadModule = function(moduleId) {
        this.log('info', `Tentative de rechargement du module: ${moduleId}`);
        if (typeof window.loadModuleSafe === 'function') {
            window.loadModuleSafe(moduleId);
        } else if (typeof window.loadModule === 'function') {
            window.loadModule(moduleId);
        } else {
            this.log('error', 'Aucune fonction de chargement de module disponible');
        }
    };

    /**
     * Crée un modèle de module
     */
    window.AppDebug.createModuleTemplate = function(moduleId) {
        this.log('info', `Création d'un modèle pour le module: ${moduleId}`);
        
        // Créer un modèle de base pour le module
        const template = `
        <!-- Module: ${moduleId} -->
        <div class="module-container">
            <h2>${moduleId.replace(/module-|-/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}</h2>
            
            <div class="module-content">
                <p>Contenu du module ${moduleId}. Ce modèle a été généré automatiquement.</p>
                
                <div class="form-group">
                    <label for="example-input">Exemple de champ:</label>
                    <input type="text" id="example-input" class="form-control" placeholder="Entrez des données...">
                </div>
                
                <div class="form-group">
                    <button id="calculate-btn" class="btn btn-primary">Calculer</button>
                    <button id="reset-btn" class="btn btn-secondary">Réinitialiser</button>
                </div>
                
                <div class="results" id="results">
                    <h3>Résultats</h3>
                    <div id="results-content">Les résultats s'afficheront ici...</div>
                </div>
            </div>
        </div>
        
        <script>
            // Code JavaScript spécifique pour ${moduleId}
            document.getElementById('calculate-btn').addEventListener('click', function() {
                const input = document.getElementById('example-input').value;
                document.getElementById('results-content').textContent = 'Vous avez saisi: ' + input;
            });
            
            document.getElementById('reset-btn').addEventListener('click', function() {
                document.getElementById('example-input').value = '';
                document.getElementById('results-content').textContent = 'Les résultats s'afficheront ici...';
            });
        </script>
        `;
        
        // Afficher le modèle
        const moduleContainer = document.getElementById('module-container');
        if (moduleContainer) {
            moduleContainer.innerHTML = template;
            this.log('info', `Modèle pour ${moduleId} créé et affiché`);
        } else {
            this.log('error', 'Container de module non trouvé');
        }
        
        // Offrir de télécharger le modèle
        const blob = new Blob([template], { type: 'text/html' });
        const url = URL.createObjectURL(blob);
        
        const downloadLink = document.createElement('a');
        downloadLink.href = url;
        downloadLink.download = `${moduleId}.html`;
        downloadLink.textContent = 'Télécharger ce modèle';
        downloadLink.style.cssText = 'display: block; margin: 20px auto; text-align: center;';
        
        if (moduleContainer) {
            moduleContainer.appendChild(downloadLink);
        }
    };
    
    /**
     * Affiche des instructions pour démarrer un serveur local
     */
    window.AppDebug.startLocalServer = function() {
        const moduleContainer = document.getElementById('module-container');
        if (moduleContainer) {
            moduleContainer.innerHTML = `
            <div class="local-server-instructions">
                <h2>Instructions pour démarrer un serveur local</h2>
                
                <p>Pour éviter les erreurs CORS, lancez un serveur HTTP local:</p>
                
                <ol>
                    <li>Ouvrez un terminal</li>
                    <li>Naviguez vers le répertoire du projet:<br>
                        <code>cd "${window.location.pathname.split('/').slice(0, -1).join('/')}"</code>
                    </li>
                    <li>Lancez un serveur Python:<br>
                        <code>python3 -m http.server 8000</code>
                    </li>
                    <li>Accédez à l'application via:<br>
                        <code>http://localhost:8000</code>
                    </li>
                </ol>
                
                <p>Autres options de serveurs locaux:</p>
                <ul>
                    <li>Node.js: <code>npx serve</code></li>
                    <li>PHP: <code>php -S localhost:8000</code></li>
                </ul>
                
                <button onclick="window.location.href='http://localhost:8000'">Essayer localhost:8000</button>
            </div>
            `;
        }
        
        this.log('info', `
        Pour éviter les erreurs CORS, lancez un serveur HTTP local:
        
        1. Ouvrez un terminal
        2. Naviguez vers le répertoire du projet: 
           cd "${window.location.pathname.split('/').slice(0, -1).join('/')}"
        3. Lancez un serveur Python:
           python3 -m http.server 8000
        4. Accédez à l'application via:
           http://localhost:8000
        `);
    };

    // Fonction pour tester l'accès aux modules avec des options supplémentaires
    window.testModuleAccess = function(moduleId, options = {}) {
        options = {
            useRelativePath: true,
            verifyCORS: true,
            ...options
        };
        
        window.AppDebug.log('info', `Test d'accès au module: ${moduleId}`);
        
        // Ici, nous utilisons toujours un chemin relatif pour éviter les problèmes CORS
        const url = `./modules/${moduleId}.html`;
        window.AppDebug.log('info', `URL: ${url}`);
        
        // Tester si le module existe en utilisant XHR pour plus de détails sur les erreurs
        const xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        
        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 300) {
                window.AppDebug.log('info', `Statut HTTP: ${xhr.status}`);
                window.AppDebug.log('info', `Contenu du module (premiers 100 caractères): ${xhr.responseText.substring(0, 100)}...`);
                
                // Mettre à jour le statut du module
                window.AppDebug.moduleStatus[moduleId] = {
                    exists: true,
                    status: xhr.status,
                    timestamp: new Date(),
                    contentPreview: xhr.responseText.substring(0, 100)
                };
            } else {
                window.AppDebug.log('error', `Erreur HTTP: ${xhr.status}`);
                
                // Mettre à jour le statut du module
                window.AppDebug.moduleStatus[moduleId] = {
                    exists: false,
                    status: xhr.status,
                    timestamp: new Date(),
                    error: `HTTP Status: ${xhr.status}`
                };
            }
        };
        
        xhr.onerror = function() {
            window.AppDebug.log('error', `Erreur d'accès au module: Erreur réseau ou CORS`);
            window.AppDebug.log('info', "Essayez d'utiliser un serveur local pour éviter les erreurs CORS.");
            window.AppDebug.log('info', "Exemple: python3 -m http.server 8000 dans le répertoire du projet");
            
            // Mettre à jour le statut du module
            window.AppDebug.moduleStatus[moduleId] = {
                exists: false,
                timestamp: new Date(),
                error: 'Erreur réseau ou CORS'
            };
            
            // Proposer des solutions
            window.AppDebug.log('info', "Solutions possibles:");
            window.AppDebug.log('info', "1. Exécutez window.AppDebug.startLocalServer()");
            window.AppDebug.log('info', "2. Exécutez window.AppDebug.createModuleTemplate('" + moduleId + "')");
        };
        
        xhr.send();
        
        // Si l'option verifyCORS est activée, tester également avec une iframe invisible
        if (options.verifyCORS) {
            window.AppDebug.log('info', "Tentative d'accès via createElement (contournement CORS)");
            
            const iframe = document.createElement('iframe');
            iframe.style.display = 'none';
            iframe.onload = function() {
                window.AppDebug.log('info', `Module ${moduleId} chargé avec succès via iframe`);
                document.body.removeChild(iframe);
            };
            iframe.onerror = function() {
                window.AppDebug.log('error', `Erreur de chargement du module ${moduleId} via iframe`);
                document.body.removeChild(iframe);
            };
            iframe.src = url;
            document.body.appendChild(iframe);
        }
    };

    // Fonction pour lister tous les modules disponibles
    window.listAvailableModules = function() {
        window.AppDebug.log('info', "Listing des modules...");
        
        if (typeof modules !== 'undefined') {
            window.AppDebug.log('info', `${modules.length} modules trouvés:`);
            console.table(modules.map(m => ({id: m.id, title: m.title})));
        } else {
            window.AppDebug.log('error', "La variable 'modules' n'est pas définie");
            window.AppDebug.log('info', "Définition d'une variable modules de secours");
            
            // Créer une variable modules de secours
            window.modules = [
                { id: 'module-puissance-chauffage', title: 'Puissance Chauffage' },
                { id: 'module-vase-expansion', title: 'Vase d\'Expansion' },
                { id: 'module-equilibrage', title: 'Équilibrage Réseau' },
                { id: 'module-radiateurs', title: 'Radiateurs' },
                { id: 'module-ecs', title: 'ECS Instantané' },
                { id: 'module-top-gaz', title: 'Top Compteur Gaz' },
                { id: 'module-vmc', title: 'VMC' },
                { id: 'module-reglementation-gaz', title: 'Réglementation Gaz' }
            ];
            
            window.AppDebug.log('info', `${window.modules.length} modules définis par défaut:`);
            console.table(window.modules.map(m => ({id: m.id, title: m.title})));
        }
    };
    
    // Ajouter un outil de diagnostic dans la console
    console.log(`
    ========================================
    🛠️ OUTILS DE DIAGNOSTIC AMÉLIORÉS 🛠️
    ========================================
    Pour tester l'accès à un module:
      testModuleAccess('module-puissance-chauffage')
      
    Pour lister tous les modules disponibles:
      listAvailableModules()
      
    Pour corriger les problèmes automatiquement:
      window.AppDebug.autoFix()
      
    Pour corriger les chemins de fichiers:
      window.AppDebug.fixFilePaths()
      
    Pour démarrer un serveur local (instructions):
      window.AppDebug.startLocalServer()
    
    Pour charger un module en mode sécurisé:
      window.loadModuleSafe('module-puissance-chauffage')
    ========================================
    `);

    // Exécuter automatiquement certaines corrections lors du chargement
    document.addEventListener('DOMContentLoaded', function() {
        window.AppDebug.log('info', 'Initialisation des outils de diagnostic...');
        
        // Appliquer les correctifs automatiques après un court délai
        setTimeout(() => {
            if (window.AppDebug.config.autoFix) {
                window.AppDebug.log('info', 'Application des correctifs automatiques...');
                window.AppDebug.autoFix();
            }
            
            // Marquer comme initialisé
            window.AppDebug.initialized = true;
            window.AppDebug.log('info', 'Outils de diagnostic initialisés et prêts.');
        }, 500);
    });
    
    // Si le DOM est déjà chargé, initialiser immédiatement
    if (document.readyState === 'interactive' || document.readyState === 'complete') {
        window.AppDebug.log('info', 'DOM déjà chargé, initialisation immédiate...');
        window.AppDebug.autoFix();
        window.AppDebug.initialized = true;
    }
}
