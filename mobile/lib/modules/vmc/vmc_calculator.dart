class VMCCalculator {
  // Réplicates the site's debitsReglementaires structure
  static const Map<String, dynamic> debitsReglementaires = {
    'simple-flux': {
      'T1': {
        'cuisine': {'min': 20, 'max': 75},
        'salle-de-bain': {'min': 15, 'max': 15},
        'wc': {'min': 15, 'max': 15},
        'autre-sdb': {'min': 0, 'max': 15}
      },
      'T2': {
        'cuisine': {'min': 30, 'max': 90},
        'salle-de-bain': {'min': 15, 'max': 15},
        'wc': {'min': 15, 'max': 15},
        'autre-sdb': {'min': 0, 'max': 15}
      },
      'T3': {
        'cuisine': {'min': 45, 'max': 105},
        'salle-de-bain': {'min': 30, 'max': 30},
        'wc': {'min': 15, 'max': 15},
        'autre-sdb': {'min': 15, 'max': 15}
      },
      'T4': {
        'cuisine': {'min': 45, 'max': 120},
        'salle-de-bain': {'min': 30, 'max': 30},
        'wc': {'min': 30, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 15}
      },
      'T5+': {
        'cuisine': {'min': 45, 'max': 135},
        'salle-de-bain': {'min': 30, 'max': 30},
        'wc': {'min': 30, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 15}
      }
    },
    'hygro-a': {
      'T1': {
        'cuisine': {'min': 10, 'max': 50},
        'salle-de-bain': {'min': 10, 'max': 40},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 0, 'max': 40}
      },
      'T2': {
        'cuisine': {'min': 10, 'max': 50},
        'salle-de-bain': {'min': 10, 'max': 40},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 0, 'max': 40}
      },
      'T3': {
        'cuisine': {'min': 15, 'max': 50},
        'salle-de-bain': {'min': 10, 'max': 40},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 10, 'max': 40}
      },
      'T4': {
        'cuisine': {'min': 20, 'max': 55},
        'salle-de-bain': {'min': 15, 'max': 45},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 45}
      },
      'T5+': {
        'cuisine': {'min': 25, 'max': 60},
        'salle-de-bain': {'min': 15, 'max': 45},
        'wc': {'min': 10, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 45}
      }
    },
    'hygro-b': {
      'T1': {
        'cuisine': {'min': 10, 'max': 50},
        'salle-de-bain': {'min': 5, 'max': 40},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 0, 'max': 40}
      },
      'T2': {
        'cuisine': {'min': 10, 'max': 50},
        'salle-de-bain': {'min': 5, 'max': 40},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 0, 'max': 40}
      },
      'T3': {
        'cuisine': {'min': 10, 'max': 45},
        'salle-de-bain': {'min': 5, 'max': 35},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 5, 'max': 35}
      },
      'T4': {
        'cuisine': {'min': 15, 'max': 45},
        'salle-de-bain': {'min': 5, 'max': 35},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 5, 'max': 35}
      },
      'T5+': {
        'cuisine': {'min': 15, 'max': 50},
        'salle-de-bain': {'min': 10, 'max': 40},
        'wc': {'min': 5, 'max': 30},
        'autre-sdb': {'min': 10, 'max': 40}
      }
    },
    'double-flux': {
      'T1': {
        'cuisine': {'min': 45, 'max': 120},
        'salle-de-bain': {'min': 15, 'max': 30},
        'wc': {'min': 15, 'max': 30},
        'autre-sdb': {'min': 0, 'max': 30}
      },
      'T2': {
        'cuisine': {'min': 45, 'max': 120},
        'salle-de-bain': {'min': 15, 'max': 30},
        'wc': {'min': 15, 'max': 30},
        'autre-sdb': {'min': 0, 'max': 30}
      },
      'T3': {
        'cuisine': {'min': 45, 'max': 135},
        'salle-de-bain': {'min': 15, 'max': 30},
        'wc': {'min': 15, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 30}
      },
      'T4': {
        'cuisine': {'min': 45, 'max': 135},
        'salle-de-bain': {'min': 30, 'max': 30},
        'wc': {'min': 15, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 30}
      },
      'T5+': {
        'cuisine': {'min': 45, 'max': 135},
        'salle-de-bain': {'min': 30, 'max': 30},
        'wc': {'min': 15, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 30}
      }
    },
    'vmc-gaz': {
      'T1': {
        'cuisine': {'min': 45, 'max': 75, 'grand-debit': 90},
        'salle-de-bain': {'min': 15, 'max': 15, 'grand-debit': 15},
        'wc': {'min': 15, 'max': 15},
        'autre-sdb': {'min': 0, 'max': 15}
      },
      'T2': {
        'cuisine': {'min': 45, 'max': 90, 'grand-debit': 105},
        'salle-de-bain': {'min': 15, 'max': 15, 'grand-debit': 30},
        'wc': {'min': 15, 'max': 15},
        'autre-sdb': {'min': 0, 'max': 15}
      },
      'T3': {
        'cuisine': {'min': 45, 'max': 105, 'grand-debit': 120},
        'salle-de-bain': {'min': 15, 'max': 30, 'grand-debit': 45},
        'wc': {'min': 15, 'max': 15},
        'autre-sdb': {'min': 15, 'max': 15}
      },
      'T4': {
        'cuisine': {'min': 45, 'max': 120, 'grand-debit': 135},
        'salle-de-bain': {'min': 15, 'max': 30, 'grand-debit': 45},
        'wc': {'min': 30, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 15}
      },
      'T5+': {
        'cuisine': {'min': 45, 'max': 135, 'grand-debit': 135},
        'salle-de-bain': {'min': 15, 'max': 30, 'grand-debit': 45},
        'wc': {'min': 30, 'max': 30},
        'autre-sdb': {'min': 15, 'max': 15}
      }
    }
  };

  // Conversions
  static double m3hToMs(double debitM3h, double diametreMm) {
    final section = 3.141592653589793 * ((diametreMm / 1000) / 2) * ((diametreMm / 1000) / 2);
    return debitM3h / 3600 / section;
  }

  static double msToM3h(double vitesseMs, double diametreMm) {
    final section = 3.141592653589793 * ((diametreMm / 1000) / 2) * ((diametreMm / 1000) / 2);
    return vitesseMs * section * 3600;
  }

  static double paToMmce(double pa) => pa / 9.81;
  static double mmceToPa(double mmce) => mmce * 9.81;

  // Retourne la référence (min/max) pour un typeVMC et typeLogement
  static Map<String, dynamic>? getReference(String typeVMC, String typeLogement) {
    final vmc = debitsReglementaires[typeVMC];
    if (vmc == null) return null;
    final ref = vmc[typeLogement];
    if (ref == null) return null;
    return Map<String, dynamic>.from(ref as Map);
  }

  static String getEtatMessage(String etat, double valeur, double min, double max) {
    if (etat == 'error') {
      if (valeur < min) return 'DÉBIT INSUFFISANT';
      if (valeur > max) return 'DÉBIT TROP ÉLEVÉ';
      return 'ERREUR';
    }
    return 'CONFORME';
  }

  static String getDiagnosticMessage(int pourcentage, int tropFaible, int tropEleve) {
    if (pourcentage == 100) return 'Installation conforme';
    if (pourcentage >= 80) return 'Installation globalement conforme avec quelques ajustements nécessaires';
    if (pourcentage >= 50) {
      if (tropFaible > tropEleve) return 'Débit global insuffisant - Vérifier le caisson VMC';
      return 'Déséquilibre dans la distribution des débits - Réglage des bouches nécessaire';
    }
    if (tropFaible > tropEleve) return 'Débit très insuffisant - Vérifier le dimensionnement de l\'installation';
    return 'Installation non conforme nécessitant une révision complète';
  }

  // Vérifie la compatibilité entre entrées d'air (inlets) et extraction VMC
  // Retourne un map avec message et status (good/warning/bad)
  static Map<String, dynamic> checkCompatibilityWithVMC(double totalInletFlow, double extractionTotal) {
    if (extractionTotal <= 0) extractionTotal = 1; // éviter division par zéro
    final difference = totalInletFlow - extractionTotal;
    final percentDifference = (difference.abs() / extractionTotal) * 100;

    if (percentDifference <= 10) {
      return {
        'status': 'good',
        'message': 'Équilibre correct : Le débit d\'entrée d\'air (${totalInletFlow.round()} m³/h) est bien équilibré avec le débit d\'extraction (${extractionTotal.round()} m³/h).',
        'percentDifference': percentDifference,
        'difference': difference
      };
    } else if (percentDifference <= 20) {
      return {
        'status': 'warning',
        'message': 'Équilibre acceptable : Le débit d\'entrée d\'air (${totalInletFlow.round()} m³/h) diffère de ${percentDifference.round()}% du débit d\'extraction (${extractionTotal.round()} m³/h).',
        'percentDifference': percentDifference,
        'difference': difference
      };
    } else {
      if (difference > 0) {
        return {
          'status': 'bad',
          'message': 'Déséquilibre : Le débit d\'entrée d\'air (${totalInletFlow.round()} m³/h) est trop important par rapport au débit d\'extraction (${extractionTotal.round()} m³/h).',
          'percentDifference': percentDifference,
          'difference': difference
        };
      } else {
        return {
          'status': 'bad',
          'message': 'Déséquilibre : Le débit d\'entrée d\'air (${totalInletFlow.round()} m³/h) est insuffisant par rapport au débit d\'extraction (${extractionTotal.round()} m³/h).',
          'percentDifference': percentDifference,
          'difference': difference
        };
      }
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
}
