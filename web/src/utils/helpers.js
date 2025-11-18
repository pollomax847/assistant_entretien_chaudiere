/**
 * Fonctions d'aide pour l'application
 */

/**
 * Formatte un nombre avec séparateur de milliers
 * @param {number} number - Nombre à formatter
 * @returns {string} Nombre formatté
 */
function formatNumber(number) {
    return new Intl.NumberFormat('fr-FR').format(number);
}

/**
 * Récupère un paramètre de l'URL
 * @param {string} param Le nom du paramètre
 * @returns {string|null} La valeur du paramètre ou null
 */
function getUrlParam(param) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(param);
}

/**
 * Récupère le fragment de l'URL (après le #)
 * @returns {string} Le fragment d'URL
 */
function getUrlHash() {
  return window.location.hash.substring(1);
}

/**
 * Définit le fragment de l'URL
 * @param {string} hash Le fragment à définir
 */
function setUrlHash(hash) {
  if (hash.startsWith('/')) {
    window.location.hash = hash;
  } else {
    window.location.hash = '/' + hash;
  }
}

/**
 * Crée un élément DOM avec des attributs et du contenu
 * @param {string} tag - Tag HTML de l'élément
 * @param {object} attributes - Attributs de l'élément
 * @param {string|HTMLElement|Array} content - Contenu de l'élément
 * @returns {HTMLElement} Élément créé
 */
function createElement(tag, attributes = {}, content = '') {
    const element = document.createElement(tag);
    
    // Ajouter les attributs
    Object.entries(attributes).forEach(([key, value]) => {
        if (key === 'class') {
            element.className = value;
        } else if (key === 'dataset') {
            Object.entries(value).forEach(([dataKey, dataValue]) => {
                element.dataset[dataKey] = dataValue;
            });
        } else {
            element.setAttribute(key, value);
        }
    });
    
    // Ajouter le contenu
    if (content) {
        if (typeof content === 'string') {
            element.innerHTML = content;
        } else if (content instanceof HTMLElement) {
            element.appendChild(content);
        } else if (Array.isArray(content)) {
            content.forEach(item => {
                if (typeof item === 'string') {
                    element.innerHTML += item;
                } else if (item instanceof HTMLElement) {
                    element.appendChild(item);
                }
            });
        }
    }
    
    return element;
}

/**
 * Charge dynamiquement un script JavaScript
 * @param {string} url - URL du script à charger
 * @returns {Promise} Promise résolue quand le script est chargé
 */
function loadScript(url) {
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = url;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
}

/**
 * Affiche un message de débogage en console si le mode débogage est activé
 */
function debug(...args) {
  if (APP_CONFIG.debugMode) {
    console.log('[DEBUG]', ...args);
  }
}

// Exporter les fonctions pour les utiliser dans d'autres modules
window.helpers = {
    loadScript,
    formatNumber,
    createElement
};
