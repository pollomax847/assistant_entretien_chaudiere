import { verifierConformite } from './logic.js';

describe('Module VMC - Tests de conformité', () => {
    beforeEach(() => {
        document.body.innerHTML = `
            <select id="typeVMC">
                <option value="simple">Simple flux</option>
                <option value="double">Double flux</option>
            </select>
            <input id="nbBouches" type="number" value="4">
            <input id="debitMesure" type="number" value="60">
            <input id="debitMS" type="number" value="1.5">
            <select id="modulesFenetre">
                <option value="true">Oui</option>
                <option value="false">Non</option>
            </select>
            <select id="etalonnagePortes">
                <option value="true">Oui</option>
                <option value="false">Non</option>
            </select>
            <div id="resVMC"></div>
        `;
    });

    test('Vérification d\'une installation conforme', () => {
        verifierConformite();
        const resultat = document.getElementById('resVMC');
        expect(resultat.className).toBe('result success');
        expect(resultat.innerHTML).toContain('✅');
    });

    test('Vérification avec débit insuffisant', () => {
        document.getElementById('debitMesure').value = '30';
        verifierConformite();
        const resultat = document.getElementById('resVMC');
        expect(resultat.className).toBe('result error');
        expect(resultat.innerHTML).toContain('⚠️');
    });

    test('Vérification avec débit m/s hors plage', () => {
        document.getElementById('debitMS').value = '3';
        verifierConformite();
        const resultat = document.getElementById('resVMC');
        expect(resultat.className).toBe('result error');
        expect(resultat.innerHTML).toContain('⚠️');
    });

    test('Vérification avec modules fenêtres non conformes', () => {
        document.getElementById('modulesFenetre').value = 'false';
        verifierConformite();
        const resultat = document.getElementById('resVMC');
        expect(resultat.className).toBe('result error');
        expect(resultat.innerHTML).toContain('⚠️');
    });

    test('Vérification avec étalonnage portes non vérifié', () => {
        document.getElementById('etalonnagePortes').value = 'false';
        verifierConformite();
        const resultat = document.getElementById('resVMC');
        expect(resultat.className).toBe('result error');
        expect(resultat.innerHTML).toContain('⚠️');
    });
}); 