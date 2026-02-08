// services/dimensionnement_service.dart
class DimensionnementService {
  // Coefficients d'isolation standards
  static const Map<String, double> coefficientsIsolation = {
    'faible': 1.3,
    'moyen': 1.0,
    'bon': 0.8,
  };

  // Coefficients de zone climatique
  static const Map<String, double> coefficientsZoneClimatique = {
    'H1': 1.2,
    'H2': 1.0,
    'H3': 0.8,
  };

  // Calcul de la puissance nécessaire
  static double calculPuissanceNecessaire({
    required double surfaceM2,
    required double hauteurM,
    required String niveauIsolation,
    required String zoneClimatique,
    required bool presencePontThermique,
  }) {
    double volume = surfaceM2 * hauteurM;
    double coeffIsolation = coefficientsIsolation[niveauIsolation] ?? 1.0;
    double coeffZone = coefficientsZoneClimatique[zoneClimatique] ?? 1.0;
    double coeffPontThermique = presencePontThermique ? 1.1 : 1.0;

    // Formule de base : 30W/m³ pour une isolation moyenne
    double puissanceBase = volume * 30 * coeffIsolation * coeffZone * coeffPontThermique;
    
    // Ajout d'une marge de sécurité de 10%
    return puissanceBase * 1.1;
  }

  // Calcul du rendement saisonnier
  static double calculRendementSaisonnier({
    required String typeChaudiere,
    required int ageAnnees,
    required bool entretienRegulier,
  }) {
    // Rendements de base par type de chaudière
    Map<String, double> rendementBase = {
      'Condensation': 0.95,
      'Basse température': 0.88,
      'Standard': 0.80,
    };

    double rendement = rendementBase[typeChaudiere] ?? 0.80;

    // Perte de rendement avec l'âge
    double perteAge = ageAnnees * 0.005;
    
    // Bonus pour l'entretien régulier
    double bonusEntretien = entretienRegulier ? 0.02 : 0.0;

    return (rendement - perteAge + bonusEntretien).clamp(0.5, 0.98);
  }

  // Calcul de la consommation annuelle estimée
  static Map<String, double> calculConsommationAnnuelle({
    required double puissanceKW,
    required String typeEnergie,
    required int heuresUtilisation,
    required double rendement,
  }) {
    // Facteurs de conversion en kWh
    Map<String, double> facteurConversion = {
      'Gaz naturel': 1.0,
      'Fioul': 1.02,
      'Électricité': 1.0,
      'Bois': 0.85,
    };

    double facteur = facteurConversion[typeEnergie] ?? 1.0;
    
    // Calcul de la consommation en kWh
    double consommationKWh = (puissanceKW * heuresUtilisation) / rendement;
    
    // Conversion selon le type d'énergie
    double consommationEnergie = consommationKWh * facteur;

    return {
      'consommationKWh': consommationKWh,
      'consommationEnergie': consommationEnergie,
    };
  }

  // Recommandations d'amélioration
  static List<Map<String, dynamic>> genererRecommandations({
    required double rendementActuel,
    required String typeChaudiere,
    required int ageAnnees,
    required double consommationAnnuelle,
  }) {
    List<Map<String, dynamic>> recommandations = [];

    // Recommandations basées sur l'âge
    if (ageAnnees > 15) {
      recommandations.add({
        'titre': 'Remplacement recommandé',
        'description': 'Votre chaudière a plus de 15 ans, un remplacement devrait être envisagé.',
        'priorite': 'Haute',
      });
    } else if (ageAnnees > 10) {
      recommandations.add({
        'titre': 'Surveillance accrue',
        'description': 'Votre chaudière a plus de 10 ans, une surveillance accrue est conseillée.',
        'priorite': 'Moyenne',
      });
    }

    // Recommandations basées sur le rendement
    if (rendementActuel < 0.7) {
      recommandations.add({
        'titre': 'Rendement faible',
        'description': 'Le rendement de votre chaudière est faible. Envisagez une mise à niveau.',
        'priorite': 'Haute',
      });
    }

    // Recommandations basées sur le type
    if (typeChaudiere == 'Standard' && consommationAnnuelle > 20000) {
      recommandations.add({
        'titre': 'Modernisation conseillée',
        'description': 'Une chaudière à condensation permettrait des économies significatives.',
        'priorite': 'Moyenne',
      });
    }

    return recommandations;
  }
} 