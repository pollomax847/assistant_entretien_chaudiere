// Fusionné depuis les fichiers séparés
import 'data/debits_reglementaires.dart';
import 'data/vmc_content.dart';

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

  static List<Map<String, String>> getTypesVMC() {
    return [
      {'value': 'simple-flux', 'label': 'Simple Flux Autoréglable'},
      {'value': 'hygro-a', 'label': 'Hygroréglable Type A'},
      {'value': 'hygro-b', 'label': 'Hygroréglable Type B'},
      {'value': 'double-flux', 'label': 'Double Flux'},
      {'value': 'vmc-gaz', 'label': 'VMC Gaz'},
    ];
  }

  static List<Map<String, String>> getTypesLogement() {
    return [
      {'value': 'T1', 'label': 'T1 (1 pièce principale)'},
      {'value': 'T2', 'label': 'T2 (2 pièces principales)'},
      {'value': 'T3', 'label': 'T3 (3 pièces principales)'},
      {'value': 'T4', 'label': 'T4 (4 pièces principales)'},
      {'value': 'T5+', 'label': 'T5+ (5+ pièces principales)'},
    ];
  }

  // Export données pour utilisation dans les fichiers
  static Map<String, Map<String, int>> getDebitsReglementaires() {
    return debitsReglementaires;
  }

  static Map<String, int> getMinimumDebitsParLogement() {
    return minimumDebitsParLogement;
  }

  static Map<String, String> getVmcContent() {
    return vmcContent;
  }
}
