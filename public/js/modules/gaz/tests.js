import { calculerDebitGaz, calculerTopGaz, verifierConformiteGaz, verifierVentilation, verifierEvacuation } from './logic.js';

describe('Module Gaz - Tests de calculs et vérifications', () => {
    describe('Calcul débit gaz', () => {
        test('Calcul avec des valeurs valides', () => {
            const result = calculerDebitGaz(1000, 1200, 3600, 10, 20);
            expect(result.success).toBe(true);
            expect(result.debit).toBeDefined();
            expect(result.puissance).toBeDefined();
            expect(result.pression).toBeDefined();
            expect(result.rapport).toBeDefined();
        });

        test('Calcul avec valeurs manquantes', () => {
            const result = calculerDebitGaz(null, 1200, 3600, 10, 20);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Calcul Top Gaz', () => {
        test('Calcul avec des valeurs valides', () => {
            const result = calculerTopGaz(1, 2, 3, 60, 10);
            expect(result.success).toBe(true);
            expect(result.volume).toBeDefined();
            expect(result.duree).toBeDefined();
            expect(result.debitHoraire).toBeDefined();
            expect(result.puissance).toBeDefined();
        });

        test('Calcul avec puissance chaudière', () => {
            const result = calculerTopGaz(1, 2, 3, 60, 10, 24);
            expect(result.success).toBe(true);
            expect(result.ecart).toBeDefined();
            expect(result.coherence).toBeDefined();
            expect(result.messageCoherence).toBeDefined();
        });

        test('Calcul avec valeurs manquantes', () => {
            const result = calculerTopGaz(null, 2, 3, 60, 10);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Vérification conformité gaz', () => {
        test('Installation conforme', () => {
            const result = verifierConformiteGaz({
                regletteVaso: true,
                roai: true,
                distances: true
            });
            expect(result.success).toBe(true);
            expect(result.conforme).toBe(true);
            expect(result.message).toBeDefined();
        });

        test('Installation non conforme', () => {
            const result = verifierConformiteGaz({
                regletteVaso: false,
                roai: true,
                distances: true
            });
            expect(result.success).toBe(true);
            expect(result.conforme).toBe(false);
            expect(result.details).toBeDefined();
        });
    });

    describe('Vérification ventilation', () => {
        test('Ventilation conforme', () => {
            const result = verifierVentilation('motorisee', 'A', 50, true, true);
            expect(result.success).toBe(true);
            expect(result.conforme).toBe(true);
        });

        test('Ventilation non conforme', () => {
            const result = verifierVentilation('motorisee', 'B', 50, false, false);
            expect(result.success).toBe(true);
            expect(result.conforme).toBe(false);
            expect(result.details).toBeDefined();
        });
    });

    describe('Vérification évacuation', () => {
        test('Évacuation conforme', () => {
            const result = verifierEvacuation('acier', 2, 5, 2, 0.5);
            expect(result.success).toBe(true);
            expect(result.conforme).toBe(true);
        });

        test('Évacuation non conforme', () => {
            const result = verifierEvacuation('pvc', 0.5, 10, 4, 0.3);
            expect(result.success).toBe(true);
            expect(result.conforme).toBe(false);
            expect(result.details).toBeDefined();
        });
    });
}); 