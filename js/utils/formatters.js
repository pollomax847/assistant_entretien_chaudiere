/**
 * Utilitaires de formatage pour les valeurs numériques et affichages
 */

/**
 * Formate un nombre avec un nombre spécifique de décimales
 * @param {number} value - Valeur à formater
 * @param {number} decimals - Nombre de décimales à afficher
 * @returns {string} Nombre formaté en chaîne de caractères
 */
export function formatNumber(value, decimals = 2) {
    if (isNaN(value)) return "N/A";
    
    // Arrondir à X décimales
    const rounded = Number(Math.round(parseFloat(value + 'e' + decimals)) + 'e-' + decimals);
    
    // Formater le nombre avec séparateur de milliers
    return new Intl.NumberFormat('fr-FR', { 
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
    }).format(rounded);
}

/**
 * Formate un résultat de calcul avec une classe CSS selon le statut
 * @param {boolean} success - Si le calcul est réussi
 * @param {string} message - Message à afficher
 * @param {object} [options] - Options additionnelles
 * @param {string} [options.type] - Type de résultat (success, warning, error)
 * @returns {string} HTML formaté pour l'affichage du résultat
 */
export function formatResult(success, message, options = {}) {
    const type = options.type || (success ? 'success' : 'error');
    
    const icons = {
        success: '✅',
        warning: '⚠️',
        error: '❌',
        info: 'ℹ️'
    };
    
    const icon = icons[type] || icons.info;
    
    return `<div class="result ${type}">${icon} ${message}</div>`;
}

/**
 * Formate une liste de détails en HTML
 * @param {Array<string>} details - Liste des détails à formatter
 * @returns {string} HTML formaté pour l'affichage des détails
 */
export function formatDetails(details) {
    if (!details || details.length === 0) return '';
    
    const detailsHtml = details.map(detail => `<li>${detail}</li>`).join('');
    return `<ul class="result-details">${detailsHtml}</ul>`;
}