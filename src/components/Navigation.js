import { MODULES } from '../config/constants.js';

export class Navigation {
    constructor(containerId) {
        this.container = document.getElementById(containerId);
        this.currentModule = null;
    }

    render() {
        const nav = document.createElement('nav');
        nav.className = 'navigation';

        Object.values(MODULES).forEach(module => {
            const link = document.createElement('a');
            link.href = module.path;
            link.className = 'nav-link';
            link.innerHTML = `
                <i class="icon-${module.icon}"></i>
                <span>${module.name}</span>
            `;
            link.addEventListener('click', (e) => {
                e.preventDefault();
                this.navigateTo(module.path);
            });
            nav.appendChild(link);
        });

        this.container.appendChild(nav);
    }

    navigateTo(path) {
        // Émettre un événement personnalisé pour le routage
        const event = new CustomEvent('navigate', { 
            detail: { path },
            bubbles: true
        });
        document.dispatchEvent(event);
    }

    setActiveModule(path) {
        const links = this.container.querySelectorAll('.nav-link');
        links.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === path) {
                link.classList.add('active');
            }
        });
    }
} 