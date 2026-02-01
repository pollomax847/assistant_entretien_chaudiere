/// Modèle de données pour un relevé technique (chaudière, PAC, clim, etc.)
class ReleveTechnique {
  final String? clientNumber;
  final String? clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String? chantierAddress;
  final String? equipementType;
  final String? surface;
  final String? occupants;
  final String? anneeConstruction;
  final String? equipementMarque;
  final String? equipementAnnee;
  final String? equipementType2;
  // Ajoute ici d'autres champs selon les besoins (voir form_fields.json et les .txt)
  // --- Réglementation Gaz ---
  final String? vasoPresent;
  final String? vasoConforme;
  final String? vasoObservation;
  final String? roaiPresent;
  final String? roaiConforme;
  final String? roaiObservation;
  final String? typeHotte;
  final String? ventilationConforme;
  final String? ventilationObservation;
  final String? vmcPresent;
  final String? vmcConforme;
  final String? vmcObservation;
  final String? detecteurCO;
  final String? detecteurGaz;
  final String? detecteursConformes;
  final String? distanceFenetre;
  final String? distancePorte;
  final String? distanceEvacuation;
  final String? distanceAspiration;
  // Diagnostic complet (questions dynamiques)
  final Map<String, dynamic>? diagnosticGaz;

  ReleveTechnique({
    this.clientNumber,
    this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.chantierAddress,
    this.equipementType,
    this.surface,
    this.occupants,
    this.anneeConstruction,
    this.equipementMarque,
    this.equipementAnnee,
    this.equipementType2,
    this.vasoPresent,
    this.vasoConforme,
    this.vasoObservation,
    this.roaiPresent,
    this.roaiConforme,
    this.roaiObservation,
    this.typeHotte,
    this.ventilationConforme,
    this.ventilationObservation,
    this.vmcPresent,
    this.vmcConforme,
    this.vmcObservation,
    this.detecteurCO,
    this.detecteurGaz,
    this.detecteursConformes,
    this.distanceFenetre,
    this.distancePorte,
    this.distanceEvacuation,
    this.distanceAspiration,
    this.diagnosticGaz,
    // Ajoute ici d'autres champs
  });

  // Factory pour créer depuis un Map (ex: JSON)
  factory ReleveTechnique.fromJson(Map<String, dynamic> json) {
    return ReleveTechnique(
      clientNumber: json['clientNumber'] as String?,
      clientName: json['clientName'] as String?,
      clientEmail: json['clientEmail'] as String?,
      clientPhone: json['clientPhone'] as String?,
      chantierAddress: json['chantierAddress'] as String?,
      equipementType: json['equipementType'] as String?,
      surface: json['surface'] as String?,
      occupants: json['occupants'] as String?,
      anneeConstruction: json['anneeConstruction'] as String?,
      equipementMarque: json['equipementMarque'] as String?,
      equipementAnnee: json['equipementAnnee'] as String?,
      equipementType2: json['equipementType2'] as String?,
      vasoPresent: json['vasoPresent'] as String?,
      vasoConforme: json['vasoConforme'] as String?,
      vasoObservation: json['vasoObservation'] as String?,
      roaiPresent: json['roaiPresent'] as String?,
      roaiConforme: json['roaiConforme'] as String?,
      roaiObservation: json['roaiObservation'] as String?,
      typeHotte: json['typeHotte'] as String?,
      ventilationConforme: json['ventilationConforme'] as String?,
      ventilationObservation: json['ventilationObservation'] as String?,
      vmcPresent: json['vmcPresent'] as String?,
      vmcConforme: json['vmcConforme'] as String?,
      vmcObservation: json['vmcObservation'] as String?,
      detecteurCO: json['detecteurCO'] as String?,
      detecteurGaz: json['detecteurGaz'] as String?,
      detecteursConformes: json['detecteursConformes'] as String?,
      distanceFenetre: json['distanceFenetre'] as String?,
      distancePorte: json['distancePorte'] as String?,
      distanceEvacuation: json['distanceEvacuation'] as String?,
      distanceAspiration: json['distanceAspiration'] as String?,
      diagnosticGaz: json['diagnostic_gaz'] as Map<String, dynamic>?,
      // Ajoute ici d'autres champs
    );
  }

  // Conversion en Map (ex: pour export ou sauvegarde)
  Map<String, dynamic> toJson() {
    return {
      'clientNumber': clientNumber,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'chantierAddress': chantierAddress,
      'equipementType': equipementType,
      'surface': surface,
      'occupants': occupants,
      'anneeConstruction': anneeConstruction,
      'equipementMarque': equipementMarque,
      'equipementAnnee': equipementAnnee,
      'equipementType2': equipementType2,
      'vasoPresent': vasoPresent,
      'vasoConforme': vasoConforme,
      'vasoObservation': vasoObservation,
      'roaiPresent': roaiPresent,
      'roaiConforme': roaiConforme,
      'roaiObservation': roaiObservation,
      'typeHotte': typeHotte,
      'ventilationConforme': ventilationConforme,
      'ventilationObservation': ventilationObservation,
      'vmcPresent': vmcPresent,
      'vmcConforme': vmcConforme,
      'vmcObservation': vmcObservation,
      'detecteurCO': detecteurCO,
      'detecteurGaz': detecteurGaz,
      'detecteursConformes': detecteursConformes,
      'distanceFenetre': distanceFenetre,
      'distancePorte': distancePorte,
      'distanceEvacuation': distanceEvacuation,
      'distanceAspiration': distanceAspiration,
      'diagnostic_gaz': diagnosticGaz,
      // Ajoute ici d'autres champs
    };
  }
}