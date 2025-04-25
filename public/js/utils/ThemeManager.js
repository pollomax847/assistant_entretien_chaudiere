/**
 * Gestionnaire de thèmes pour l'application
 * Permet de changer le thème et d'appliquer les préférences utilisateur
 */

export class ThemeManager {
    constructor() {
        this.currentTheme = localStorage.getItem('chauffage-expert-theme') || 'light';
        this.init();
    }
    
    /**
     * Initialise le gestionnaire de thèmes
     */
    init() {
        this.applyTheme(this.currentTheme);
        
        // Écouter les changements de thème
        document.addEventListener('themeChange', (e) => {
            this.setTheme(e.detail.theme);
        });
        
        // Vérifier si l'utilisateur a une préférence système pour le thème sombre
        const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)');
        if (prefersDarkScheme.matches && !localStorage.getItem('chauffage-expert-theme')) {
            this.setTheme('dark');
        }
        
        // Écouter les changements de préférences système
        prefersDarkScheme.addEventListener('change', (e) => {
            // Ne changer automatiquement que si l'utilisateur n'a pas explicitement choisi un thème
            if (!localStorage.getItem('chauffage-expert-theme')) {
                this.setTheme(e.matches ? 'dark' : 'light');
            }
        });
    }
    
    /**
     * Définit le thème actif
     * @param {string} theme - 'light' ou 'dark'
     */
    setTheme(theme) {
        if (theme !== 'light' && theme !== 'dark') {
            console.error('Thème invalide:', theme);
            return;
        }
        
        this.currentTheme = theme;
        localStorage.setItem('chauffage-expert-theme', theme);
        this.applyTheme(theme);
        
        // Émettre un événement indiquant le changement de thème
        const event = new CustomEvent('themeChanged', { detail: { theme } });
        document.dispatchEvent(event);
    }
    
    /**
     * Applique le thème spécifié
     * @param {string} theme - 'light' ou 'dark'
     */
    applyTheme(theme) {
        if (theme === 'dark') {
            document.body.classList.add('dark-theme');
        } else {
            document.body.classList.remove('dark-theme');
        }
        
        // Mettre à jour les méta-données pour le navigateur
        const metaThemeColor = document.querySelector('meta[name="theme-color"]');
        if (metaThemeColor) {
            metaThemeColor.setAttribute('content', theme === 'dark' ? '#121212' : '#f4f4f4');
        } else {
            const meta = document.createElement('meta');
            meta.name = 'theme-color';
            meta.content = theme === 'dark' ? '#121212' : '#f4f4f4';
            document.head.appendChild(meta);
        }
    }
    
    /**
     * Bascule entre les thèmes clair et sombre
     */
    toggleTheme() {
        const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
        this.setTheme(newTheme);
        return newTheme;
    }
    
    /**
     * Retourne le thème actuel
     * @returns {string} Le thème actuel ('light' ou 'dark')
     */
    getCurrentTheme() {
        return this.currentTheme;
    }
}
