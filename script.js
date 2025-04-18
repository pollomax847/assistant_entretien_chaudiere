function calcule() {
  const vol = parseFloat(document.getElementById('volChauff').value);
  const G = parseFloat(document.getElementById('coefG').value);
  const Text = parseFloat(document.getElementById('tempExt').value);
  const P = (G * vol * (19 - Text) / 1000).toFixed(2);
  document.getElementById('resChauffage').textContent = `Puissance : ${P} kW`;

  const etage = parseInt(document.getElementById('etages').value);
  const pression = etage === 0 ? 0.5 : etage === 1 ? 0.75 : etage === 2 ? 1 : 1.25;
  const volVase = etage === 0 ? 1.5 : etage === 1 ? 3.5 : etage === 2 ? 5 : 6.5;
  document.getElementById('resVase').textContent = `Pression gonflage : ${pression} bar | Volume mini vase : ${volVase} L`;

  const deb = parseFloat(document.getElementById('indexDebut').value);
  const fin = parseFloat(document.getElementById('indexFin').value);
  const duree = parseFloat(document.getElementById('duree').value);
  const pci = parseFloat(document.getElementById('pci').value);
  if (!isNaN(deb) && !isNaN(fin) && !isNaN(duree)) {
    const volume = fin - deb;
    const m3h = (volume * 3600 / duree).toFixed(2);
    const Pgaz = (m3h * pci).toFixed(2);
    document.getElementById('resGaz').textContent = `Débit : ${m3h} m³/h | Puissance : ${Pgaz} kW`;
  }

  const volEcs = parseFloat(document.getElementById('volEcs').value);
  const dureeEcs = parseFloat(document.getElementById('dureeEcs').value);
  if (!isNaN(volEcs) && !isNaN(dureeEcs) && dureeEcs > 0) {
    const debit = ((volEcs / dureeEcs) * 60).toFixed(1);
    let conforme = debit >= 7 ? '✔ Conforme' : '⚠️ Insuffisant';
    document.getElementById('resEcs').textContent = `Débit : ${debit} L/min — ${conforme}`;
  }
}
document.querySelectorAll('input').forEach(input => input.addEventListener('input', calcule));
window.onload = calcule;