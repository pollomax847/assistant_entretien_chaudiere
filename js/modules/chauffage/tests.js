import { calculerPuissanceChauffage, calculerPuissanceRadiateur, calculerVaseExpansion } from './logic.js';

describe('Module Chauffage - Tests de calculs', () => {
    describe('Calcul de puissance de chauffage', () => {
        test('Calcul avec des valeurs valides', () => {
            const result = calculerPuissanceChauffage(100, 0.8, -5);
            expect(result.success).toBe(true);
            expect(result.volume).toBeDefined();
            expect(result.deltaT).toBeDefined();
            expect(result.puissance).toBeDefined();
        });

        test('Calcul avec valeurs manquantes', () => {
            const result = calculerPuissanceChauffage(null, 0.8, -5);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Calcul de puissance radiateur', () => {
        test('Calcul pour radiateur en acier', () => {
            const result = calculerPuissanceRadiateur('Acier', 600, 1000);
            expect(result.success).toBe(true);
            expect(result.surface).toBeDefined();
            expect(result.puissance).toBeDefined();
        });

        test('Calcul pour radiateur à panneaux', () => {
            const result = calculerPuissanceRadiateur('Panneaux', 600, 1000, 'T22');
            expect(result.success).toBe(true);
            expect(result.surface).toBeDefined();
            expect(result.puissance).toBeDefined();
        });

        test('Calcul avec valeurs manquantes', () => {
            const result = calculerPuissanceRadiateur(null, 600, 1000);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });

    describe('Calcul vase d\'expansion', () => {
        test('Calcul avec hauteur standard', () => {
            const result = calculerVaseExpansion(10, false);
            expect(result.success).toBe(true);
            expect(result.pression).toBeDefined();
            expect(result.reglage).toBeDefined();
        });

        test('Calcul avec radiateur au dernier étage', () => {
            const result = calculerVaseExpansion(10, true);
            expect(result.success).toBe(true);
            expect(result.pression).toBeDefined();
            expect(result.reglage).toBeDefined();
        });

        test('Calcul avec hauteur manquante', () => {
            const result = calculerVaseExpansion(null, false);
            expect(result.success).toBe(false);
            expect(result.message).toBeDefined();
        });
    });
}); 