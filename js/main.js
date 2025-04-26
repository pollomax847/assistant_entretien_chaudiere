function verifierVMC() {
  // Récupération des valeurs
  const typeVMC = document.getElementById('typeVMC').value;
  const nbBouches = parseInt(document.getElementById('nbBouches').value);
  const debitMesure = parseFloat(document.getElementById('debitMesure').value);
  const debitMS = parseFloat(document.getElementById('debitMS').value);
  const modulesFenetre = document.getElementById('modulesFenetre').value;
  const etalonnagePortes = document.getElementById('etalonnagePortes').value;

  // Validation des champs obligatoires
  if (!nbBouches || !debitMesure || !debitMS) {
    afficherResultat('Veuillez remplir tous les champs numériques', false);
    return;
  }

  // Vérification des critères de conformité
  let messages = [];
  let estConforme = true;

  // Vérification du débit par bouche
  const debitParBouche = debitMesure / nbBouches;
  if (debitParBouche < 15 || debitParBouche > 30) {
    messages.push(`Le débit par bouche (${debitParBouche.toFixed(2)} m³/h) n'est pas conforme. Il doit être compris entre 15 et 30 m³/h.`);
    estConforme = false;
  }

  // Vérification du débit en m/s
  if (debitMS < 0.5 || debitMS > 2) {
    messages.push(`Le débit en m/s (${debitMS}) n'est pas conforme. Il doit être compris entre 0.5 et 2 m/s.`);
    estConforme = false;
  }

  // Vérification des modules fenêtres
  if (modulesFenetre === 'Non') {
    messages.push('Les modules aux fenêtres ne sont pas conformes.');
    estConforme = false;
  }

  // Vérification de l'étalonnage des portes
  if (etalonnagePortes === 'Non') {
    messages.push("L'étalonnage des portes n'a pas été vérifié.");
    estConforme = false;
  }

  // Affichage du résultat
  if (estConforme) {
    afficherResultat('La VMC est conforme aux normes.', true);
  } else {
    afficherResultat(messages.join('<br>'), false);
  }
}

function afficherResultat(message, estConforme) {
  const resultDiv = document.getElementById('resVMC');
  resultDiv.innerHTML = message;
  resultDiv.className = 'result ' + (estConforme ? 'success' : 'error');
} 