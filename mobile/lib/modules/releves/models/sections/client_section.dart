/// Section Client - Informations générales et environnement
class ClientSection {
  // Client
  final String? numero;
  final String? nom;
  final String? email;
  final String? telephone;
  final String? telephonePortable;
  final String? adresseChantier;

  // Informations installation
  final String? nomTechnicien;
  final String? matriculeTechnicien;
  final DateTime? dateVisite;

  // Environnement
  final bool? estAppartement;
  final String? surface; // m²
  final String? nombreOccupants;
  final int? anneeConstruction;
  final bool? reperageAmiante;
  final bool? accordCopropriete;
  final bool? estPavillon;
  final String? nombrePieces;

  const ClientSection({
    this.numero,
    this.nom,
    this.email,
    this.telephone,
    this.telephonePortable,
    this.adresseChantier,
    this.nomTechnicien,
    this.matriculeTechnicien,
    this.dateVisite,
    this.estAppartement,
    this.surface,
    this.nombreOccupants,
    this.anneeConstruction,
    this.reperageAmiante,
    this.accordCopropriete,
    this.estPavillon,
    this.nombrePieces,
  });

  /// Créer une copie avec modifications
  ClientSection copyWith({
    String? numero,
    String? nom,
    String? email,
    String? telephone,
    String? telephonePortable,
    String? adresseChantier,
    String? nomTechnicien,
    String? matriculeTechnicien,
    DateTime? dateVisite,
    bool? estAppartement,
    String? surface,
    String? nombreOccupants,
    int? anneeConstruction,
    bool? reperageAmiante,
    bool? accordCopropriete,
    bool? estPavillon,
    String? nombrePieces,
  }) {
    return ClientSection(
      numero: numero ?? this.numero,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      telephonePortable: telephonePortable ?? this.telephonePortable,
      adresseChantier: adresseChantier ?? this.adresseChantier,
      nomTechnicien: nomTechnicien ?? this.nomTechnicien,
      matriculeTechnicien: matriculeTechnicien ?? this.matriculeTechnicien,
      dateVisite: dateVisite ?? this.dateVisite,
      estAppartement: estAppartement ?? this.estAppartement,
      surface: surface ?? this.surface,
      nombreOccupants: nombreOccupants ?? this.nombreOccupants,
      anneeConstruction: anneeConstruction ?? this.anneeConstruction,
      reperageAmiante: reperageAmiante ?? this.reperageAmiante,
      accordCopropriete: accordCopropriete ?? this.accordCopropriete,
      estPavillon: estPavillon ?? this.estPavillon,
      nombrePieces: nombrePieces ?? this.nombrePieces,
    );
  }

  /// Conversion en JSON
  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'telephonePortable': telephonePortable,
      'adresseChantier': adresseChantier,
      'nomTechnicien': nomTechnicien,
      'matriculeTechnicien': matriculeTechnicien,
      'dateVisite': dateVisite?.toIso8601String(),
      'estAppartement': estAppartement,
      'surface': surface,
      'nombreOccupants': nombreOccupants,
      'anneeConstruction': anneeConstruction,
      'reperageAmiante': reperageAmiante,
      'accordCopropriete': accordCopropriete,
      'estPavillon': estPavillon,
      'nombrePieces': nombrePieces,
    };
  }

  /// Créer depuis JSON
  factory ClientSection.fromJson(Map<String, dynamic> json) {
    return ClientSection(
      numero: json['numero'] as String?,
      nom: json['nom'] as String?,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      telephonePortable: json['telephonePortable'] as String?,
      adresseChantier: json['adresseChantier'] as String?,
      nomTechnicien: json['nomTechnicien'] as String?,
      matriculeTechnicien: json['matriculeTechnicien'] as String?,
      dateVisite: json['dateVisite'] != null
          ? DateTime.parse(json['dateVisite'] as String)
          : null,
      estAppartement: json['estAppartement'] as bool?,
      surface: json['surface'] as String?,
      nombreOccupants: json['nombreOccupants'] as String?,
      anneeConstruction: json['anneeConstruction'] as int?,
      reperageAmiante: json['reperageAmiante'] as bool?,
      accordCopropriete: json['accordCopropriete'] as bool?,
      estPavillon: json['estPavillon'] as bool?,
      nombrePieces: json['nombrePieces'] as String?,
    );
  }
}
