/**
 * Utilitaires de validation pour les entrées utilisateurs
 */

/**
 * Vérifie si une valeur est un nombre valide
 * @param {any} value - Valeur à vérifier
 * @returns {boolean} True si c'est un nombre valide, false sinon
 */
export function isValidNumber(value) {
    if (value === null || value === undefined || value === '') return false;
    return !isNaN(parseFloat(value)) && isFinite(value);
}

/**
 * Vérifie si une valeur est dans une plage définie
 * @param {number} value - Valeur à vérifier
 * @param {number} min - Valeur minimale autorisée
 * @param {number} max - Valeur maximale autorisée
 * @returns {boolean} True si la valeur est dans la plage, false sinon
 */
export function isInRange(value, min, max) {
    if (!isValidNumber(value)) return false;
    const numValue = parseFloat(value);
    return numValue >= min && numValue <= max;
}

/**
 * Valide un ensemble de champs requis
 * @param {Object} fields - Objet contenant les valeurs des champs {name: value}
 * @returns {Object} Résultat de validation {valid: boolean, invalidFields: string[]}
 */
export function validateRequiredFields(fields) {
    const invalidFields = [];
    
    for (const [fieldName, value] of Object.entries(fields)) {
        if (!isValidNumber(value)) {
            invalidFields.push(fieldName);
        }
    }
    
    return {
        valid: invalidFields.length === 0,
        invalidFields
    };
}

/**
 * Vérifie si un formulaire a des erreurs de validation
 * @param {HTMLFormElement} form - Élément form à vérifier
 * @returns {boolean} True si le formulaire est valide, false sinon
 */
export function isFormValid(form) {
    return form.checkValidity();
}

/**
 * Affiche les erreurs de validation sur un formulaire
 * @param {HTMLFormElement} form - Élément form à vérifier
 * @returns {void}
 */
export function showFormValidationErrors(form) {
    // Trouve tous les champs invalides
    const invalidInputs = form.querySelectorAll(':invalid');
    
    // Ajoute des messages d'erreur ou des styles pour chaque champ invalide
    invalidInputs.forEach(input => {
        input.classList.add('error');
        
        // Si un message d'erreur personnalisé existe pour ce champ
        if (input.dataset.errorMessage) {
            // Trouve ou crée un élément pour afficher le message d'erreur
            let errorEl = input.parentNode.querySelector('.error-message');
            if (!errorEl) {
                errorEl = document.createElement('div');
                errorEl.className = 'error-message';
                input.parentNode.appendChild(errorEl);
            }
            errorEl.textContent = input.dataset.errorMessage;
        }
    });
}

/**
 * Réinitialise les erreurs de validation sur un formulaire
 * @param {HTMLFormElement} form - Élément form à réinitialiser
 * @returns {void}
 */
export function resetFormValidation(form) {
    // Supprime la classe d'erreur de tous les inputs
    form.querySelectorAll('.error').forEach(el => el.classList.remove('error'));
    
    // Supprime tous les messages d'erreur
    form.querySelectorAll('.error-message').forEach(el => el.remove());
}