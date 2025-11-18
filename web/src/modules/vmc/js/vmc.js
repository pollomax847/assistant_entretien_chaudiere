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

// Fonction de vérification de conformité
function verifierConformite() {
    const typeVMC = document.getElementById('typeVMC').value;
    const nbBouches = parseInt(document.getElementById('nbBouches').value);
    const debitMesure = parseFloat(document.getElementById('debitMesure').value);
    const debitMS = parseFloat(document.getElementById('debitMS').value);
    const modulesFenetre = document.getElementById('modulesFenetre').value === 'true';
    const etalonnagePortes = document.getElementById('etalonnagePortes').value === 'true';

    const resultat = document.getElementById('resVMC');
    resultat.innerHTML = '';

    // Vérification des champs obligatoires
    if (!nbBouches || !debitMesure || !debitMS) {
        resultat.className = 'result error';
        resultat.innerHTML = 'Veuillez remplir tous les champs obligatoires.';
        return;
    }

    // Vérification du débit
    const norme = normesVMC[typeVMC];
    const debitParBouche = debitMesure / nbBouches;
    let messages = [];

    if (debitParBouche < norme.debitMin) {
        messages.push(`Le débit par bouche (${debitParBouche.toFixed(2)} m³/h) est inférieur au minimum requis (${norme.debitMin} m³/h).`);
    }
    if (debitParBouche > norme.debitMax) {
        messages.push(`Le débit par bouche (${debitParBouche.toFixed(2)} m³/h) est supérieur au maximum autorisé (${norme.debitMax} m³/h).`);
    }

    // Vérification des modules aux fenêtres
    if (!modulesFenetre) {
        messages.push('Les modules aux fenêtres ne sont pas conformes.');
    }

    // Vérification de l'étalonnage des portes
    if (!etalonnagePortes) {
        messages.push("L'étalonnage des portes n'a pas été vérifié.");
    }

    // Affichage des résultats
    if (messages.length === 0) {
        resultat.className = 'result success';
        resultat.innerHTML = 'L\'installation est conforme aux normes.';
    } else {
        resultat.className = 'result warning';
        resultat.innerHTML = messages.join('<br>');
    }
}

// Initialisation
document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('verifierVMC').addEventListener('click', verifierConformite);
}); 