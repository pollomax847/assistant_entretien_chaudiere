export function verifierConformite() {
    const typeVMC = document.getElementById('typeVMC').value;
    const nbBouches = parseInt(document.getElementById('nbBouches').value);
    const debitMesure = parseFloat(document.getElementById('debitMesure').value);
    const debitMS = parseFloat(document.getElementById('debitMS').value);
    const modulesFenetre = document.getElementById('modulesFenetre').value === 'true';
    const etalonnagePortes = document.getElementById('etalonnagePortes').value === 'true';

    const resultat = document.getElementById('resVMC');
    let message = '';
    let estConforme = true;

    // Vérification du débit total
    const debitMinimum = nbBouches * 15; // 15 m³/h par bouche minimum
    if (debitMesure < debitMinimum) {
        message += `⚠️ Le débit total mesuré (${debitMesure} m³/h) est inférieur au minimum requis (${debitMinimum} m³/h).<br>`;
        estConforme = false;
    }

    // Vérification du débit en m/s
    if (debitMS < 0.5 || debitMS > 2) {
        message += `⚠️ Le débit en m/s (${debitMS}) n'est pas dans la plage acceptable (0.5 - 2 m/s).<br>`;
        estConforme = false;
    }

    // Vérification des modules aux fenêtres
    if (!modulesFenetre) {
        message += '⚠️ Les modules aux fenêtres ne sont pas conformes.<br>';
        estConforme = false;
    }

    // Vérification de l'étalonnage des portes
    if (!etalonnagePortes) {
        message += '⚠️ L\'étalonnage des portes n\'a pas été vérifié.<br>';
        estConforme = false;
    }

    // Message final
    if (estConforme) {
        message = '✅ L\'installation VMC est conforme aux normes.';
        resultat.className = 'result success';
    } else {
        message += '<br>❌ L\'installation VMC n\'est pas conforme. Veuillez corriger les points mentionnés ci-dessus.';
        resultat.className = 'result error';
    }

    resultat.innerHTML = message;
} 