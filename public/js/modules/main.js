function verifierVMC() {
  const nbBouches = parseInt(document.getElementById('nbBouches').value);
  const debitMesure = parseFloat(document.getElementById('debitMesure').value);
  const debitMS = parseFloat(document.getElementById('debitMS').value);
  const modulesFenetre = document.getElementById('modulesFenetre').value;
  const etalonnagePortes = document.getElementById('etalonnagePortes').value;

  let conforme = true;
  let messages = [];

  if (isNaN(nbBouches) || isNaN(debitMesure) || isNaN(debitMS)) {
    messages.push("⚠️ Veuillez remplir toutes les valeurs numériques.");
    conforme = false;
  } else {
    if (debitMesure < nbBouches * 15) {
      messages.push("❌ Débit trop faible.");
      conforme = false;
    } else {
      messages.push("✅ Débit total conforme.");
    }

    if (debitMS < 0.8 || debitMS > 2.5) {
      messages.push("⚠️ Débit en m/s hors norme.");
      conforme = false;
    } else {
      messages.push("✅ Débit en m/s conforme.");
    }
  }

  if (modulesFenetre === "Non") {
    messages.push("⚠️ Modules aux fenêtres non conformes.");
    conforme = false;
  }

  if (etalonnagePortes === "Non") {
    messages.push("⚠️ Étalonnage des portes non effectué.");
    conforme = false;
  }

  const res = document.getElementById('resVMC');
  res.innerHTML = `<strong>${conforme ? '✅ Installation conforme' : '❌ Non conforme'} :</strong><br>${messages.join('<br>')}`;
  res.style.color = conforme ? 'green' : 'red';
}
