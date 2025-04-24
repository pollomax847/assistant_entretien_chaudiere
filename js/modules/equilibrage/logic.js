import { formatNumber } from '../../utils/formatters.js';

export function calculerEquilibrage(methode, params) {
    try {
        let resultat;
        
        if (methode === 'puissance') {
            const { puissance, debit } = params;
            if (!puissance || !debit) {
                throw new Error('Veuillez remplir tous les champs');
            }
            
            // Calcul du réglage en tours (arrondi à 0.5)
            const reglage = Math.round((puissance / debit) * 2) / 2;
            resultat = {
                success: true,
                reglage: formatNumber(reglage, 1),
                message: `Réglage recommandé : ${formatNumber(reglage, 1)} tours`
            };
        } else if (methode === 'deltaT') {
            throw new Error('La méthode par ΔT n\'est pas encore disponible');
        } else {
            throw new Error('Méthode d\'équilibrage non reconnue');
        }
        
        return resultat;
    } catch (error) {
        return {
            success: false,
            message: error.message
        };
    }
} 