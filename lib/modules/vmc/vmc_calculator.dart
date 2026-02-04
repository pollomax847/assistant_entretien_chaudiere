class VMCCalculator {
  // Références de débits par type de VMC et logement (en m³/h)
  static const Map<String, Map<String, Map<String, dynamic>>> _references = {
    'simple-flux': {
      'T1': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T2': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T3': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T4': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T5+': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
    },
    'hygro-a': {
      'T1': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T2': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T3': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T4': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T5+': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
    },
    'hygro-b': {
      'T1': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T2': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T3': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T4': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T5+': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
    },
    'double-flux': {
      'T1': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T2': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T3': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T4': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T5+': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
    },
    'vmc-gaz': {
      'T1': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T2': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T3': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T4': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
      'T5+': {'cuisine': {'min': 60, 'max': 90}, 'salle-de-bain': {'min': 15, 'max': 30}, 'wc': {'min': 15, 'max': 30}},
    },
  };

  static Map<String, dynamic>? getReference(String typeVMC, String typeLogement) {
    return _references[typeVMC]?[typeLogement];
  }

  static String getEtatMessage(String etat, double valeur, double min, double max) {
    if (etat == 'success') {
      return 'Conforme';
    } else if (valeur < min) {
      return 'Trop faible';
    } else {
      return 'Trop élevé';
    }
  }

  static String getDiagnosticMessage(int pourcentage, int tropFaible, int tropEleve) {
    if (pourcentage >= 80) {
      return 'Installation globalement conforme avec quelques ajustements nécessaires.';
    } else if (pourcentage >= 50) {
      return 'Plusieurs débits sont hors normes. Réglage des bouches recommandé.';
    } else {
      return 'Installation non conforme. Révision complète nécessaire.';
    }
  }

  static Map<String, dynamic> checkCompatibilityWithVMC(double totalInletFlow, double extractionTotal) {
    final difference = totalInletFlow - extractionTotal;
    final percentDifference = extractionTotal > 0 ? (difference / extractionTotal) * 100 : 0;

    if ((percentDifference).abs() <= 10) {
      return {
        'status': 'good',
        'message': 'Équilibre satisfaisant entre entrées d\'air et extraction.',
        'difference': difference,
        'percentDifference': percentDifference
      };
    } else if ((percentDifference).abs() <= 25) {
      return {
        'status': 'warning',
        'message': 'Déséquilibre modéré. ${difference > 0 ? 'Entrée d\'air excessive' : 'Déficit d\'entrée d\'air'}.',
        'difference': difference,
        'percentDifference': percentDifference
      };
    } else {
      return {
        'status': 'bad',
        'message': 'Déséquilibre important. ${difference > 0 ? 'Entrée d\'air excessive' : 'Déficit d\'entrée d\'air'}.',
        'difference': difference,
        'percentDifference': percentDifference
      };
    }
  }

  static List<Map<String, String>> getTypesVMC() {
    return [
      {'value': 'simple-flux', 'label': 'VMC Simple Flux Autoréglable'},
      {'value': 'hygro-a', 'label': 'VMC Hygroréglable Type A'},
      {'value': 'hygro-b', 'label': 'VMC Hygroréglable Type B'},
      {'value': 'double-flux', 'label': 'VMC Double Flux'},
      {'value': 'vmc-gaz', 'label': 'VMC Gaz'},
    ];
  }

  static Map<String, dynamic> verifierConformite({
    required String typeVMC,
    required String nbBouches,
    required double debitMesure,
    required double debitMS,
    required bool modulesFenetre,
    required bool etalonnagePortes,
  }) {
    // Implémentation simplifiée
    return {
      'conforme': true,
      'message': 'Installation conforme',
      'recommandations': [],
    };
  }
}