import { MODULES } from '../config/modules.js';

export class ModuleManager {
    constructor() {
        this.modules = new Map();
        this.currentModule = null;
    }

    async loadModule(name) {
        try {
            if (this.modules.has(name)) {
                return this.modules.get(name);
            }

            const module = await import(`../modules/${name}/index.js`);
            this.modules.set(name, module);
            return module;
        } catch (error) {
            console.error(`Erreur lors du chargement du module ${name}:`, error);
            throw error;
        }
    }

    async renderModule(name, container) {
        try {
            const module = await this.loadModule(name);
            container.innerHTML = '';
            await module.render(container);
            this.currentModule = name;
        } catch (error) {
            container.innerHTML = `
                <div class="error-message">
                    <h2>Erreur</h2>
                    <p>Impossible de charger le module ${name}.</p>
                </div>
            `;
        }
    }

    getCurrentModule() {
        return this.currentModule;
    }

    getAllModules() {
        return MODULES;
    }

    getModuleInfo(name) {
        return MODULES[name];
    }
} 