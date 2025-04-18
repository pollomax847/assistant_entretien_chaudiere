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
    const pci = parseFloat(document.getElementById('typeGaz').value);
    const pressionGaz = parseFloat(document.getElementById('pression').value);

    if (!isNaN(deb) && !isNaN(fin) && !isNaN(duree)) {
        const volume = fin - deb;
        const m3h = (volume * 3600 / duree).toFixed(2);
        const Pgaz = (m3h * pci).toFixed(2);
        const pressionNormale = (pressionGaz / 20).toFixed(2);
        document.getElementById('resGaz').textContent =
            `Débit : ${m3h} m³/h | Puissance : ${Pgaz} kW | Pression : ${pressionGaz} mbar (${pressionNormale} × Pn)`;
    }

    const volEcs = parseFloat(document.getElementById('volEcs').value);
    const dureeEcs = parseFloat(document.getElementById('dureeEcs').value);
    const tempEfs = parseFloat(document.getElementById('tempEfs').value);
    const tempEcs = parseFloat(document.getElementById('tempEcs').value);

    if (!isNaN(volEcs) && !isNaN(dureeEcs) && dureeEcs > 0) {
        const debit = ((volEcs / dureeEcs) * 60).toFixed(1);
        const deltaT = tempEcs - tempEfs;
        const puissance = ((debit * deltaT) / 0.0143).toFixed(1);
        document.getElementById('resEcs').textContent = `Débit : ${debit} L/min | ΔT : ${deltaT}°C | Puissance : ${puissance} kW`;
    }

    // Module Top Gaz
    const digit1 = document.getElementById('digit1').value;
    const digit2 = document.getElementById('digit2').value;
    const digit3 = document.getElementById('digit3').value;
    const dureeGaz = document.querySelector('input[name="duree"]:checked').value;
    const pcs = parseFloat(document.getElementById('pcs').value);

    if (digit1 !== '' && digit2 !== '' && digit3 !== '') {
        const volumeLitres = parseInt(digit1 + digit2 + digit3);
        const volumeM3h = ((volumeLitres / dureeGaz) * 3600 / 1000).toFixed(2);
        const puissance = (volumeM3h * pcs).toFixed(2);
        document.getElementById('resGaz').textContent =
            `Débit horaire : ${volumeM3h} m³/h\nPuissance : ${puissance} kW`;
    }

    // Puissance Chauffage
    const surface = parseFloat(document.getElementById('surface').value);
    const hauteur = parseFloat(document.getElementById('hauteur').value);
    const coefG = parseFloat(document.getElementById('coefG').value);
    const tempInt = parseFloat(document.getElementById('tempInt').value);
    const tempExt = parseFloat(document.getElementById('tempExt').value);

    const volume = surface * hauteur;
    const deltaT = tempInt - tempExt;
    const puissanceChauffage = (coefG * volume * deltaT / 1000).toFixed(2);

    document.getElementById('resChauffage').textContent =
        `Volume : ${volume.toFixed(1)} m³ | ΔT : ${deltaT}°C | Puissance : ${puissanceChauffage} kW`;

    // Vase d'expansion
    const hauteurBatiment = parseFloat(document.getElementById('hauteurBatiment').value);
    const pressionVase = ((hauteurBatiment / 10) + 0.3).toFixed(1);
    document.getElementById('resVase').textContent = `Pression recommandée : ${pressionVase} bar`;

    calculeEmetteur();
    verifieReglementaire();
}

// Gestion du type d'émetteur
document.querySelectorAll('input[name="typeEmetteur"]').forEach(radio => {
    radio.addEventListener('change', function () {
        document.getElementById('radiateur-params').style.display =
            this.value === 'radiateur' ? 'block' : 'none';
        document.getElementById('plancher-params').style.display =
            this.value === 'plancher' ? 'block' : 'none';
        calcule();
    });
});

// Fonction d'export
document.getElementById('exportBtn').addEventListener('click', function () {
    const type = document.querySelector('input[name="typeEmetteur"]:checked').value;
    let data = [];

    if (type === 'radiateur') {
        data = [
            ['Type', 'Radiateur'],
            ['Puissance', document.getElementById('puissanceRad').value + ' W'],
            ['Température départ', document.getElementById('tempDepartRad').value + '°C'],
            ['Température retour', document.getElementById('tempRetourRad').value + '°C'],
            ['Débit nécessaire', document.getElementById('resEmetteur').textContent]
        ];
    } else {
        data = [
            ['Type', 'Plancher chauffant'],
            ['Longueur', document.getElementById('longueurPC').value + ' m'],
            ['Diamètre tube', document.getElementById('diametrePC').value + ' mm'],
            ['Type de tube', document.getElementById('typeTubePC').selectedOptions[0].text],
            ['Résultats', document.getElementById('resEmetteur').textContent]
        ];
    }

    const csv = data.map(row => row.join(',')).join('\n');
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'equilibrage-emetteurs.csv';
    a.click();
    window.URL.revokeObjectURL(url);
});

// Calcul pour les émetteurs
function calculeEmetteur() {
    const type = document.querySelector('input[name="typeEmetteur"]:checked').value;

    if (type === 'radiateur') {
        const puissance = parseFloat(document.getElementById('puissanceRad').value);
        const tempDepart = parseFloat(document.getElementById('tempDepartRad').value);
        const tempRetour = parseFloat(document.getElementById('tempRetourRad').value);

        if (!isNaN(puissance) && !isNaN(tempDepart) && !isNaN(tempRetour)) {
            const deltaT = tempDepart - tempRetour;
            const debit = (puissance / (1.163 * deltaT)).toFixed(1);
            document.getElementById('resEmetteur').textContent =
                `Débit nécessaire : ${debit} L/h`;
        }
    } else {
        const longueur = parseFloat(document.getElementById('longueurPC').value);
        const diametre = parseFloat(document.getElementById('diametrePC').value);
        const typeTube = parseFloat(document.getElementById('typeTubePC').value);

        if (!isNaN(longueur)) {
            const perteCharge = (longueur * typeTube).toFixed(1);
            const debitMax = (diametre === 12 ? 1.2 : diametre === 16 ? 2.1 : 3.3).toFixed(1);
            document.getElementById('resEmetteur').textContent =
                `Perte de charge : ${perteCharge} mbar | Débit max recommandé : ${debitMax} L/min`;
        }
    }
}

document.querySelectorAll('input').forEach(input => input.addEventListener('input', calcule));
window.onload = calcule;

// Vérifications réglementaires gaz
function verifieReglementaire() {
    // Conformité Gaz
    const regletteVaso = document.getElementById('regletteVaso').checked;
    const roai = document.getElementById('roai').checked;
    const distances = document.getElementById('distances').checked;
    const resConformite = document.getElementById('resConformiteGaz');

    if (regletteVaso && roai && distances) {
        resConformite.textContent = '✔️ Conforme';
        resConformite.className = 'result conforme';
    } else {
        resConformite.textContent = '⚠️ Non conforme';
        resConformite.className = 'result non-conforme';
    }

    // Ventilation et Hotte
    const typeHotte = document.getElementById('typeHotte').value;
    const typeAppareil = document.getElementById('typeAppareil').value;
    const volumePiece = parseFloat(document.getElementById('volumePiece').value);
    const clapet = document.getElementById('clapet').checked;
    const asservissement = document.getElementById('asservissement').checked;
    const resVentilation = document.getElementById('resVentilation');

    let ventilationConforme = true;
    let messageVentilation = '';

    if (typeHotte === 'motorisee' && typeAppareil === 'B' && !asservissement) {
        ventilationConforme = false;
        messageVentilation = '⚠️ Hotte motorisée interdite avec appareil type B sans asservissement';
    }

    if (!clapet) {
        ventilationConforme = false;
        messageVentilation += '\n⚠️ Clapet anti-retour requis';
    }

    if (ventilationConforme) {
        resVentilation.textContent = '✔️ Conforme';
        resVentilation.className = 'result conforme';
    } else {
        resVentilation.textContent = messageVentilation;
        resVentilation.className = 'result non-conforme';
    }

    // Évacuation Fumées
    const materiau = document.getElementById('materiauEvac').value;
    const pente = parseFloat(document.getElementById('penteEvac').value);
    const longueur = parseFloat(document.getElementById('longueurEvac').value);
    const coudes = parseInt(document.getElementById('coudesEvac').value);
    const distanceOuvrants = parseFloat(document.getElementById('distanceOuvrants').value);
    const resEvacuation = document.getElementById('resEvacuation');

    let evacuationConforme = true;
    let messageEvacuation = '';

    if (pente < 1 || pente > 3) {
        evacuationConforme = false;
        messageEvacuation += '⚠️ Pente doit être entre 1% et 3%\n';
    }

    if (materiau === 'pvc' && typeAppareil === 'B') {
        evacuationConforme = false;
        messageEvacuation += '⚠️ PVC interdit avec appareil type B\n';
    }

    if (coudes > 3) {
        evacuationConforme = false;
        messageEvacuation += '⚠️ Maximum 3 coudes autorisés\n';
    }

    if (distanceOuvrants < 0.4) {
        evacuationConforme = false;
        messageEvacuation += '⚠️ Distance minimale aux ouvrants : 0.4m\n';
    }

    if (evacuationConforme) {
        resEvacuation.textContent = '✔️ Conforme';
        resEvacuation.className = 'result conforme';
    } else {
        resEvacuation.textContent = messageEvacuation;
        resEvacuation.className = 'result non-conforme';
    }

    // VMC Gaz & Anomalie 32C
    const vmcFonctionne = document.getElementById('vmcFonctionne').checked;
    const dscPresent = document.getElementById('dscPresent').checked;
    const testCO = document.getElementById('testCO').checked;
    const resVMC = document.getElementById('resVMC');

    if (vmcFonctionne && dscPresent && testCO) {
        resVMC.textContent = '✔️ Conforme';
        resVMC.className = 'result conforme';
    } else {
        resVMC.textContent = '⚠️ Anomalie 32C détectée : Vérification requise';
        resVMC.className = 'result non-conforme';
    }
}

// Ajouter les écouteurs d'événements
document.querySelectorAll('#regletteVaso, #roai, #distances').forEach(input => {
    input.addEventListener('change', verifieReglementaire);
});

document.querySelectorAll('#typeHotte, #typeAppareil, #volumePiece, #clapet, #asservissement').forEach(input => {
    input.addEventListener('change', verifieReglementaire);
});

document.querySelectorAll('#materiauEvac, #penteEvac, #longueurEvac, #coudesEvac, #distanceOuvrants').forEach(input => {
    input.addEventListener('change', verifieReglementaire);
});

document.querySelectorAll('#vmcFonctionne, #dscPresent, #testCO').forEach(input => {
    input.addEventListener('change', verifieReglementaire);
});

// Gestion de la barre de progression
function updateProgress() {
    const sections = document.querySelectorAll('section');
    const progressBar = document.getElementById('progressBar');
    const windowHeight = window.innerHeight;
    const documentHeight = document.documentElement.scrollHeight - windowHeight;
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

    // Mise à jour de la barre de progression
    const progress = (scrollTop / documentHeight) * 100;
    progressBar.style.width = progress + '%';

    // Mise en évidence du lien actif
    sections.forEach(section => {
        const sectionTop = section.offsetTop - 120;
        const sectionBottom = sectionTop + section.offsetHeight;
        const link = document.querySelector(`a[href="#${section.id}"]`);

        if (scrollTop >= sectionTop && scrollTop < sectionBottom) {
            link.style.backgroundColor = '#f0f0f0';
            link.style.fontWeight = 'bold';
        } else {
            link.style.backgroundColor = 'transparent';
            link.style.fontWeight = 'normal';
        }
    });
}

// Ajouter les écouteurs d'événements pour la navigation
window.addEventListener('scroll', updateProgress);
window.addEventListener('load', updateProgress);

// Navigation fluide
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            window.scrollTo({
                top: target.offsetTop - 100,
                behavior: 'smooth'
            });
        }
    });
});

function verifierConformiteGaz() {
    const checkboxes = document.querySelectorAll('#conformiteGaz input[type="checkbox"]');
    const resultContainer = document.getElementById('resConformiteGaz');
    let conforme = true;
    let details = [];

    checkboxes.forEach(checkbox => {
        if (!checkbox.checked) {
            conforme = false;
            details.push(`❌ ${checkbox.nextElementSibling.textContent}`);
        } else {
            details.push(`✅ ${checkbox.nextElementSibling.textContent}`);
        }
    });

    resultContainer.innerHTML = `
        <div class="result ${conforme ? 'conforme' : 'non-conforme'}">
            ${conforme ? '✅ Conforme' : '❌ Non conforme'}
        </div>
        <div class="details">
            ${details.join('\n')}
        </div>
    `;
}

function verifierVentilation() {
    const checkboxes = document.querySelectorAll('#ventilation input[type="checkbox"]');
    const resultContainer = document.getElementById('resVentilation');
    let conforme = true;
    let details = [];

    checkboxes.forEach(checkbox => {
        if (!checkbox.checked) {
            conforme = false;
            details.push(`❌ ${checkbox.nextElementSibling.textContent}`);
        } else {
            details.push(`✅ ${checkbox.nextElementSibling.textContent}`);
        }
    });

    resultContainer.innerHTML = `
        <div class="result ${conforme ? 'conforme' : 'non-conforme'}">
            ${conforme ? '✅ Conforme' : '❌ Non conforme'}
        </div>
        <div class="details">
            ${details.join('\n')}
        </div>
    `;
}

function verifierEvacuation() {
    const checkboxes = document.querySelectorAll('#evacuation input[type="checkbox"]');
    const resultContainer = document.getElementById('resEvacuation');
    let conforme = true;
    let details = [];

    checkboxes.forEach(checkbox => {
        if (!checkbox.checked) {
            conforme = false;
            details.push(`❌ ${checkbox.nextElementSibling.textContent}`);
        } else {
            details.push(`✅ ${checkbox.nextElementSibling.textContent}`);
        }
    });

    resultContainer.innerHTML = `
        <div class="result ${conforme ? 'conforme' : 'non-conforme'}">
            ${conforme ? '✅ Conforme' : '❌ Non conforme'}
        </div>
        <div class="details">
            ${details.join('\n')}
        </div>
    `;
}

function verifierVMC() {
    const checkboxes = document.querySelectorAll('#vmc input[type="checkbox"]');
    const resultContainer = document.getElementById('resVMC');
    let conforme = true;
    let details = [];

    checkboxes.forEach(checkbox => {
        if (!checkbox.checked) {
            conforme = false;
            details.push(`❌ ${checkbox.nextElementSibling.textContent}`);
        } else {
            details.push(`✅ ${checkbox.nextElementSibling.textContent}`);
        }
    });

    resultContainer.innerHTML = `
        <div class="result ${conforme ? 'conforme' : 'non-conforme'}">
            ${conforme ? '✅ Conforme' : '❌ Non conforme'}
        </div>
        <div class="details">
            ${details.join('\n')}
        </div>
    `;
}

// Ajout des écouteurs d'événements
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('verifierGaz').addEventListener('click', verifierConformiteGaz);
    document.getElementById('verifierVentilation').addEventListener('click', verifierVentilation);
    document.getElementById('verifierEvacuation').addEventListener('click', verifierEvacuation);
    document.getElementById('verifierVMC').addEventListener('click', verifierVMC);
});