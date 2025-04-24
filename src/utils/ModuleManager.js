import { MODULES } from '../config/constants.js';

export class ModuleManager {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.modules = new Map();
        this.currentModule = null;
    }

    async loadModule(path) {
        try {
            // Vérifier si le module est déjà chargé
            if (this.modules.has(path)) {
                return this.modules.get(path);
            }

            // Charger le module dynamiquement
            const module = await import(`../modules${path}/index.js`);
            this.modules.set(path, module);
            return module;
        } catch (error) {
            console.error(`Erreur lors du chargement du module ${path}:`, error);
            throw error;
        }
    }

    async renderModule(path) {
        try {
            const module = await this.loadModule(path);
            this.container.innerHTML = '';
            await module.render(this.container);
            this.currentModule = path;
        } catch (error) {
            this.container.innerHTML = `
                <div class="error-message">
                    <h2>Erreur</h2>
                    <p>Impossible de charger le module demandé.</p>
                </div>
            `;
        }
    }

    getCurrentModule() {
        return this.currentModule;
    }
} 