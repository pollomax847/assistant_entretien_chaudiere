/**
 * Module VMC - Gestion et vérification de la VMC
 */

// Configuration des normes VMC
const normesVMC = {
    simple_flux: {
        debitMin: 15,
        debitMax: 30
    },
    sanitaire: {
        debitMin: 20,
        debitMax: 40
    },
    sekoia: {
        debitMin: 25,
        debitMax: 45
    },
    vti: {
        debitMin: 30,
        debitMax: 50
    }
};

/**
 * Vérification de la conformité d'une installation VMC
 */
export function verifierVMC() {
    const typeVMC = document.getElementById('typeVMC')?.value;
    const nbBouches = parseInt(document.getElementById('nbBouches')?.value || "0");
    const debitMesure = parseFloat(document.getElementById('debitMesure')?.value || "0");
    const debitMS = parseFloat(document.getElementById('debitMS')?.value || "0");
    const modulesFenetre = document.getElementById('modulesFenetre')?.value;
    const etalonnagePortes = document.getElementById('etalonnagePortes')?.value;
    
    const res = document.getElementById('resVMC');
    if (!res) return;

    let conforme = true;
    let messages = [];

    // Vérification des champs obligatoires
    if (isNaN(nbBouches) || isNaN(debitMesure) || isNaN(debitMS)) {
        messages.push("⚠️ Veuillez remplir toutes les valeurs numériques.");
        conforme = false;
    } else {
        // Vérification selon les normes du type d'installation
        const norme = normesVMC[typeVMC] || normesVMC.simple_flux;
        const debitParBouche = debitMesure / nbBouches;
        
        // Débit par bouche
        if (debitParBouche < norme.debitMin) {
            messages.push(`❌ Débit par bouche trop faible: ${debitParBouche.toFixed(2)} m³/h (min: ${norme.debitMin} m³/h)`);
            conforme = false;
        } else if (debitParBouche > norme.debitMax) {
            messages.push(`❌ Débit par bouche trop élevé: ${debitParBouche.toFixed(2)} m³/h (max: ${norme.debitMax} m³/h)`);
            conforme = false;
        } else {
            messages.push(`✅ Débit par bouche conforme: ${debitParBouche.toFixed(2)} m³/h`);
        }
        
        // Débit en m/s
        if (debitMS < 0.8 || debitMS > 2.5) {
            messages.push("❌ Débit en m/s hors plage recommandée (0.8 - 2.5 m/s)");
            conforme = false;
        } else {
            messages.push("✅ Débit en m/s conforme");
        }
    }

    // Modules aux fenêtres
    if (modulesFenetre === "Non" || modulesFenetre === "false") {
        messages.push("❌ Modules aux fenêtres non conformes");
        conforme = false;
    } else {
        messages.push("✅ Modules aux fenêtres conformes");
    }

    // Étalonnage des portes
    if (etalonnagePortes === "Non" || etalonnagePortes === "false") {
        messages.push("❌ Vérifiez l'étanchéité/étalonnage des portes");
        conforme = false;
    } else {
        messages.push("✅ Étalonnage des portes vérifié");
    }

    // Affichage des résultats
    res.innerHTML = `<strong>${conforme ? '✅ Conforme' : '❌ Non conforme'} :</strong><br>${messages.join('<br>')}`;
    res.className = conforme ? 'result success' : 'result error';
    
    return { conforme, messages };
}

/**
 * Calcul du débit d'air nécessaire selon le volume et le renouvellement
 */
export function calculerDebitVMC(volume, renouvellement) {
    return volume * renouvellement;
}

/**
 * Initialisation du module VMC
 */
export function initVMC() {
    document.addEventListener('DOMContentLoaded', () => {
        const verifierButton = document.getElementById('verifierVMC');
        if (verifierButton && !verifierButton.hasListener) {
            verifierButton.addEventListener('click', verifierVMC);
            verifierButton.hasListener = true;
        }
    });
}

// Auto-initialisation
initVMC();
