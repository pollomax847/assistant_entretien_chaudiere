function verifierVMC() {
  const typeVMC = document.getElementById("typeVMC").value;
  const nbBouches = parseInt(document.getElementById("nbBouches").value, 10);
  const debitMesure = parseFloat(document.getElementById("debitMesure").value);
  const debitMS = parseFloat(document.getElementById("debitMS").value);
  const modulesFenetre = document.getElementById("modulesFenetre").value;
  const etalonnagePortes = document.getElementById("etalonnagePortes").value;

  let result = "";

  // Vérification des données
  if (isNaN(nbBouches) || isNaN(debitMesure) || isNaN(debitMS)) {
    result = "Veuillez remplir tous les champs numériques correctement.";
  } else {
    result += `Type d'installation : ${typeVMC}\n`;
    result += `Nombre de bouches : ${nbBouches}\n`;
    result += `Débit total mesuré : ${debitMesure} m³/h\n`;
    result += `Débit en m/s : ${debitMS} m/s\n`;
    result += `Modules aux fenêtres conformes : ${modulesFenetre}\n`;
    result += `Étalonnage des portes vérifié : ${etalonnagePortes}\n`;

    // Exemple de logique pour vérifier la conformité
    if (modulesFenetre === "Non" || etalonnagePortes === "Non") {
      result += "\nAttention : Certains critères de conformité ne sont pas respectés.";
    } else {
      result += "\nL'installation semble conforme.";
    }
  }

  // Affichage du résultat
  document.getElementById("resVMC").innerText = result;
}