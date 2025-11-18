class VMCCalculator {
  // Normes VMC selon votre code JavaScript
  static const Map<String, Map<String, double>> normesVMC = {
    'simple_flux': {
      'debitMin': 15.0,
      'debitMax': 30.0,
    },
    'sanitaire': {
      'debitMin': 20.0,
      'debitMax': 40.0,
    },
    'sekoia': {
      'debitMin': 25.0,
      'debitMax': 45.0,
    },
    'vti': {
      'debitMin': 30.0,
      'debitMax': 50.0,
    },
  };

  /// Vérifie la conformité d'une installation VMC
  /// 
  /// Retourne un objet avec tous les résultats de vérification
  static Map<String, dynamic> verifierConformite({
    required String typeVMC,
    required int nbBouches,
    required double debitMesure,
    required double debitMS,
    required bool modulesFenetre,
    required bool etalonnagePortes,
  }) {
    List<String> messages = [];
    bool conforme = true;

    // Vérification des champs obligatoires
    if (nbBouches <= 0 || debitMesure <= 0 || debitMS <= 0) {
      messages.add("⚠️ Veuillez remplir toutes les valeurs numériques.");
      conforme = false;
      return {
        'conforme': conforme,
        'messages': messages,
        'debitParBouche': 0.0,
        'debitMSConforme': false,
        'modulesFenetreConformes': false,
        'etalonnagePortesOk': false,
      };
    }

    // Vérification selon les normes du type d'installation
    final norme = normesVMC[typeVMC] ?? normesVMC['simple_flux']!;
    final debitParBouche = debitMesure / nbBouches;

    // Débit par bouche
    bool debitParBoucheConforme = true;
    if (debitParBouche < norme['debitMin']!) {
      messages.add("❌ Débit par bouche trop faible: ${debitParBouche.toStringAsFixed(2)} m³/h (min: ${norme['debitMin']} m³/h)");
      conforme = false;
      debitParBoucheConforme = false;
    } else if (debitParBouche > norme['debitMax']!) {
      messages.add("❌ Débit par bouche trop élevé: ${debitParBouche.toStringAsFixed(2)} m³/h (max: ${norme['debitMax']} m³/h)");
      conforme = false;
      debitParBoucheConforme = false;
    } else {
      messages.add("✅ Débit par bouche conforme: ${debitParBouche.toStringAsFixed(2)} m³/h");
    }

    // Débit en m/s
    bool debitMSConforme = true;
    if (debitMS < 0.8 || debitMS > 2.5) {
      messages.add("❌ Débit en m/s hors plage recommandée (0.8 - 2.5 m/s)");
      conforme = false;
      debitMSConforme = false;
    } else {
      messages.add("✅ Débit en m/s conforme");
    }

    // Modules aux fenêtres
    bool modulesFenetreConformes = modulesFenetre;
    if (!modulesFenetre) {
      messages.add("❌ Modules aux fenêtres non conformes");
      conforme = false;
    } else {
      messages.add("✅ Modules aux fenêtres conformes");
    }

    // Étalonnage des portes
    bool etalonnagePortesOk = etalonnagePortes;
    if (!etalonnagePortes) {
      messages.add("❌ Étalonnage des portes non vérifié");
      conforme = false;
    } else {
      messages.add("✅ Étalonnage des portes vérifié");
    }

    return {
      'conforme': conforme,
      'messages': messages,
      'debitParBouche': debitParBouche,
      'debitParBoucheConforme': debitParBoucheConforme,
      'debitMSConforme': debitMSConforme,
      'modulesFenetreConformes': modulesFenetreConformes,
      'etalonnagePortesOk': etalonnagePortesOk,
      'typeVMC': typeVMC,
      'normeMin': norme['debitMin'],
      'normeMax': norme['debitMax'],
    };
  }

  /// Calcule le débit d'air nécessaire selon le volume et le renouvellement
  static double calculerDebitVMC(double volume, double renouvellement) {
    return volume * renouvellement;
  }

  /// Retourne la liste des types VMC disponibles
  static List<Map<String, String>> getTypesVMC() {
    return [
      {'value': 'simple_flux', 'label': 'VMC simple flux classique'},
      {'value': 'sanitaire', 'label': 'VMC sanitaire (autoréglable)'},
      {'value': 'sekoia', 'label': 'Caisson Sekoia'},
      {'value': 'vti', 'label': 'VTI (VMC Très Intelligent)'},
    ];
  }
}
