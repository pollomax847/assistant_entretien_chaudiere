class PuissanceChauffageCalculator {
  // Coefficients selon l'isolation (W/m³)
  static const Map<String, double> coeffIsolation = {
    'excellente': 6.0, // BBC, RT2012+
    'bonne': 9.0,      // RT2005
    'moyenne': 12.0,    // 1980-2000
    'faible': 15.0,     // avant 1980
  };

  // Coefficients selon la zone climatique
  static const Map<String, double> coeffZone = {
    'H1': 1.2, // Nord, Est
    'H2': 1.0, // Ouest, Centre
    'H3': 0.8, // Sud
  };

  /// Calcule la puissance nécessaire pour le chauffage
  /// 
  /// [surface] Surface habitable en m²
  /// [hauteur] Hauteur sous plafond en m
  /// [isolation] Niveau d'isolation ('excellente', 'bonne', 'moyenne', 'faible')
  /// [zone] Zone climatique ('H1', 'H2', 'H3')
  /// [typeEmetteur] Type d'émetteur ('radiateur', 'plancher')
  /// 
  /// Retourne la puissance en kW
  static double calculerPuissance({
    required double surface,
    required double hauteur,
    required String isolation,
    required String zone,
    required String typeEmetteur,
  }) {
    // Validation des paramètres
    if (surface <= 0 || hauteur <= 0) {
      throw ArgumentError('Surface et hauteur doivent être positives');
    }

    if (!coeffIsolation.containsKey(isolation)) {
      throw ArgumentError('Niveau d\'isolation invalide: $isolation');
    }

    if (!coeffZone.containsKey(zone)) {
      throw ArgumentError('Zone climatique invalide: $zone');
    }

    // Calcul de la puissance de base
    double puissance = surface * hauteur * 
                      coeffIsolation[isolation]! * 
                      coeffZone[zone]!;

    // Ajustement selon le type d'émetteur
    if (typeEmetteur == 'plancher') {
      puissance *= 0.9; // Le plancher chauffant est plus efficace
    }

    // Conversion en kW
    return puissance / 1000.0;
  }

  /// Calcule la puissance par m²
  static double calculerPuissanceParM2({
    required double puissanceTotale,
    required double surface,
  }) {
    if (surface <= 0) {
      throw ArgumentError('Surface doit être positive');
    }
    return (puissanceTotale * 1000) / surface;
  }

  /// Vérifie la cohérence de la puissance calculée
  static Map<String, dynamic> verifierCoherence({
    required double puissance,
    required double surface,
    required String typeEmetteur,
  }) {
    final puissanceParM2 = calculerPuissanceParM2(
      puissanceTotale: puissance,
      surface: surface,
    );

    // Valeurs de référence pour la puissance par m² selon le type d'émetteur
    Map<String, Map<String, double>> references = {
      'radiateur': {'min': 30.0, 'max': 150.0},
      'plancher': {'min': 20.0, 'max': 100.0},
    };

    final ref = references[typeEmetteur] ?? references['radiateur']!;
    
    bool coherent = puissanceParM2 >= ref['min']! && puissanceParM2 <= ref['max']!;
    String message = '';

    if (!coherent) {
      if (puissanceParM2 < ref['min']!) {
        message = 'Puissance faible (${puissanceParM2.toStringAsFixed(0)} W/m²). '
                 'Vérifiez l\'isolation et les paramètres.';
      } else {
        message = 'Puissance élevée (${puissanceParM2.toStringAsFixed(0)} W/m²). '
                 'Vérifiez les paramètres de calcul.';
      }
    } else {
      message = 'Puissance cohérente (${puissanceParM2.toStringAsFixed(0)} W/m²)';
    }

    return {
      'coherent': coherent,
      'message': message,
      'puissanceParM2': puissanceParM2,
    };
  }
}
