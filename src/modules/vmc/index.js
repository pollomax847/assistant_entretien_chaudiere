export class VMCModule {
    constructor(container) {
        this.container = container;
        this.render();
    }

    render() {
        this.container.innerHTML = `
            <div class="module-content">
                <h2>Calcul VMC</h2>
                <form id="vmcForm">
                    <div class="form-group">
                        <label for="volume">Volume de la pièce (m³)</label>
                        <input type="number" id="volume" required>
                    </div>
                    <div class="form-group">
                        <label for="renouvellement">Nombre de renouvellements d'air par heure</label>
                        <input type="number" id="renouvellement" value="1" required>
                    </div>
                    <button type="submit" class="btn-primary">Calculer</button>
                </form>
                <div id="result" class="result hidden"></div>
            </div>
        `;

        this.initializeEventListeners();
    }

    initializeEventListeners() {
        const form = this.container.querySelector('#vmcForm');
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            this.calculate();
        });
    }

    calculate() {
        const volume = parseFloat(document.getElementById('volume').value);
        const renouvellement = parseFloat(document.getElementById('renouvellement').value);
        
        const debit = volume * renouvellement;
        
        const result = this.container.querySelector('#result');
        result.innerHTML = `
            <h3>Résultat</h3>
            <p>Débit d'air nécessaire : ${debit.toFixed(2)} m³/h</p>
        `;
        result.classList.remove('hidden');
    }
} 