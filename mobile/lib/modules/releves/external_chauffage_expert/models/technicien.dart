// models/technicien.dart
class Technicien {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String? qualification;
  final DateTime dateCreation;
  final DateTime? dateDerniereModification;

  Technicien({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    this.qualification,
    required this.dateCreation,
    this.dateDerniereModification,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'qualification': qualification,
      'dateCreation': dateCreation.toIso8601String(),
      'dateDerniereModification': dateDerniereModification?.toIso8601String(),
    };
  }

  factory Technicien.fromMap(Map<String, dynamic> map) {
    return Technicien(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
      telephone: map['telephone'] as String,
      qualification: map['qualification'] as String?,
      dateCreation: DateTime.parse(map['dateCreation'] as String),
      dateDerniereModification: map['dateDerniereModification'] != null
          ? DateTime.parse(map['dateDerniereModification'] as String)
          : null,
    );
  }

  Technicien copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? qualification,
    DateTime? dateCreation,
    DateTime? dateDerniereModification,
  }) {
    return Technicien(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      qualification: qualification ?? this.qualification,
      dateCreation: dateCreation ?? this.dateCreation,
      dateDerniereModification:
          dateDerniereModification ?? this.dateDerniereModification,
    );
  }
}
