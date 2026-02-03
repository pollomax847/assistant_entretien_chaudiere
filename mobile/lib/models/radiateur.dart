// no dart:convert needed here

enum StatutRadiateur {
  ok,
  tropChaud,
  tropFroid,
  aPurger,
  aAjuster,
  autre,
}

class Radiateur {
  final String id; // UUID pour unicité
  String nom; // ex. "Salon sud"
  double toursVanne; // 0.0 à 5.0 par ex.
  double? tempAller;
  double? tempRetour;
  double? get deltaT => (tempAller != null && tempRetour != null)
      ? (tempAller! - tempRetour!).abs()
      : null;
  StatutRadiateur statut;
  String notes;
  String? photoPath; // Chemin local de la photo (ex. /storage/.../photo.jpg)
  int ordre; // Pour trier proche → loin (0 = plus proche)

  Radiateur({
    required this.id,
    required this.nom,
    this.toursVanne = 0.0,
    this.tempAller,
    this.tempRetour,
    this.statut = StatutRadiateur.ok,
    this.notes = '',
    this.photoPath,
    this.ordre = 0,
  });

  // Pour sauvegarde JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'toursVanne': toursVanne,
      'tempAller': tempAller,
      'tempRetour': tempRetour,
      'statut': statut.toString().split('.').last, // "ok" au lieu de "StatutRadiateur.ok"
      'notes': notes,
      'photoPath': photoPath,
      'ordre': ordre,
    };
  }

  factory Radiateur.fromJson(Map<String, dynamic> json) {
    return Radiateur(
      id: json['id'] as String,
      nom: json['nom'] as String,
      toursVanne: (json['toursVanne'] as num?)?.toDouble() ?? 0.0,
      tempAller: (json['tempAller'] as num?)?.toDouble(),
      tempRetour: (json['tempRetour'] as num?)?.toDouble(),
      statut: StatutRadiateur.values.firstWhere(
        (e) => e.toString().split('.').last == json['statut'],
        orElse: () => StatutRadiateur.ok,
      ),
      notes: json['notes'] as String? ?? '',
      photoPath: json['photoPath'] as String?,
      ordre: json['ordre'] as int? ?? 0,
    );
  }

  // Pour affichage simple du statut
  String get statutDisplay {
    switch (statut) {
      case StatutRadiateur.ok:
        return 'OK';
      case StatutRadiateur.tropChaud:
        return 'Trop chaud';
      case StatutRadiateur.tropFroid:
        return 'Trop froid';
      case StatutRadiateur.aPurger:
        return 'À purger';
      case StatutRadiateur.aAjuster:
        return 'À ajuster';
      case StatutRadiateur.autre:
        return 'Autre';
    }
  }
}