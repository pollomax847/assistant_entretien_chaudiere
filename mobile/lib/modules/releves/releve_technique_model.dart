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
      // Ajoute ici d'autres champs
    };
  }
}