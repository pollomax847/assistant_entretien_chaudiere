/// Section Tirage - Mesures tirage et gaz
class TirageSection {
  // Mesures de tirage
  final double? tirage; // hPa (pascal)
  final double? co; // ppm
  final double? co2; // %
  final double? o2; // %
  final double? temperatureFumees; // °C

  // Normes
  final bool? tirageConforme;
  final bool? coConforme;
  final bool? co2Conforme;

  // Configuration d'évacuation
  final String? typeEvacuation; // CONDUIT_FUMEE, VENTOUSE, VMC, etc

  // Accessoires sécurité
  final bool? extracteurMotorise;
  final bool? daaf; // Détecteur avertisseur autonome incendie
  final bool? detectionGaz;

  // Résultats visites
  final bool? ramonageOk;
  final bool? nettoyageOk;

  // Commentaires
  final String? commentaire;

  const TirageSection({
    this.tirage,
    this.co,
    this.co2,
    this.o2,
    this.temperatureFumees,
    this.tirageConforme,
    this.coConforme,
    this.co2Conforme,
    this.typeEvacuation,
    this.extracteurMotorise,
    this.daaf,
    this.detectionGaz,
    this.ramonageOk,
    this.nettoyageOk,
    this.commentaire,
  });

  TirageSection copyWith({
    double? tirage,
    double? co,
    double? co2,
    double? o2,
    double? temperatureFumees,
    bool? tirageConforme,
    bool? coConforme,
    bool? co2Conforme,
    String? typeEvacuation,
    bool? extracteurMotorise,
    bool? daaf,
    bool? detectionGaz,
    bool? ramonageOk,
    bool? nettoyageOk,
    String? commentaire,
  }) {
    return TirageSection(
      tirage: tirage ?? this.tirage,
      co: co ?? this.co,
      co2: co2 ?? this.co2,
      o2: o2 ?? this.o2,
      temperatureFumees: temperatureFumees ?? this.temperatureFumees,
      tirageConforme: tirageConforme ?? this.tirageConforme,
      coConforme: coConforme ?? this.coConforme,
      co2Conforme: co2Conforme ?? this.co2Conforme,
      typeEvacuation: typeEvacuation ?? this.typeEvacuation,
      extracteurMotorise: extracteurMotorise ?? this.extracteurMotorise,
      daaf: daaf ?? this.daaf,
      detectionGaz: detectionGaz ?? this.detectionGaz,
      ramonageOk: ramonageOk ?? this.ramonageOk,
      nettoyageOk: nettoyageOk ?? this.nettoyageOk,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tirage': tirage,
      'co': co,
      'co2': co2,
      'o2': o2,
      'temperatureFumees': temperatureFumees,
      'tirageConforme': tirageConforme,
      'coConforme': coConforme,
      'co2Conforme': co2Conforme,
      'typeEvacuation': typeEvacuation,
      'extracteurMotorise': extracteurMotorise,
      'daaf': daaf,
      'detectionGaz': detectionGaz,
      'ramonageOk': ramonageOk,
      'nettoyageOk': nettoyageOk,
      'commentaire': commentaire,
    };
  }

  factory TirageSection.fromJson(Map<String, dynamic> json) {
    return TirageSection(
      tirage: json['tirage'] as double?,
      co: json['co'] as double?,
      co2: json['co2'] as double?,
      o2: json['o2'] as double?,
      temperatureFumees: json['temperatureFumees'] as double?,
      tirageConforme: json['tirageConforme'] as bool?,
      coConforme: json['coConforme'] as bool?,
      co2Conforme: json['co2Conforme'] as bool?,
      typeEvacuation: json['typeEvacuation'] as String?,
      extracteurMotorise: json['extracteurMotorise'] as bool?,
      daaf: json['daaf'] as bool?,
      detectionGaz: json['detectionGaz'] as bool?,
      ramonageOk: json['ramonageOk'] as bool?,
      nettoyageOk: json['nettoyageOk'] as bool?,
      commentaire: json['commentaire'] as String?,
    );
  }
}
