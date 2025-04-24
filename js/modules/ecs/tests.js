import { calculerEcsInstantane, calculerEcsVolume } from './logic.js';

describe('Module ECS - Tests de calculs', () => {
    describe('Calcul ECS instantané', () => {
        test('Calcul avec des valeurs valides', () => {
            const result = calculerEcsInstantane(10, 60, 12);
            expect(result.success).toBe(true);
            expect(result.deltaT).toBeDefined();
            expect(result.debit).toBeDefined();
            expect(result.puissanceRestituee).toBeDefined();
        });

        test('Calcul avec puissance chaudière', () => {
            const result = calculerEcsInstantane(10, 60, 12, 24);
            expect(result.success).toBe(true);
            expect(result.coherence).toBeDefined();
            expect(result.messageCoherence).toBeDefined();
        });

        test('Calcul avec valeurs manquantes', () => {
            const result = calculerEcsInstantane(null, 60, 12);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Calcul ECS par volume', () => {
        test('Calcul avec des valeurs valides', () => {
            const result = calculerEcsVolume(100, 5, 10, 60);
            expect(result.success).toBe(true);
            expect(result.debit).toBeDefined();
            expect(result.deltaT).toBeDefined();
            expect(result.puissance).toBeDefined();
        });

        test('Calcul avec durée nulle', () => {
            const result = calculerEcsVolume(100, 0, 10, 60);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });

        test('Calcul avec valeurs manquantes', () => {
            const result = calculerEcsVolume(null, 5, 10, 60);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });
}); 