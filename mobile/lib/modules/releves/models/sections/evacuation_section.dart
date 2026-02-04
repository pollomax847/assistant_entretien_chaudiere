/// Section Évacuation - Détails système d'évacuation
class EvacuationSection {
  // Type d'évacuation principal
  final String? typeEvacuation;

  // Conduit de fumée
  final bool? conduitRigide;
  final String? diametre; // mm
  final String? matiere; // Acier, Inox, Brique, Tubage
  final String? longueur; // m
  final String? nombreCoudes90;
  final String? nombreCoudes45;
  final bool? tubage;
  final String? longueurTubage;

  // Sortie
  final bool? sortieCheminee;
  final bool? sortieToiture;
  final bool? sortieParMur;
  final String? hauteurSortieToiture; // cm
  final bool? depassementNormes;

  // Ventouse (si applicable)
  final String? diameterVentouse;
  final bool? ventouseVerticale;
  final bool? ventouseHorizontale;
  final String? distanceParoiVoisine; // cm

  // Conformité évacuation
  final bool? puregePresente;
  final bool? bouchonGaz;

  // Commentaires
  final String? commentaire;

  const EvacuationSection({
    this.typeEvacuation,
    this.conduitRigide,
    this.diametre,
    this.matiere,
    this.longueur,
    this.nombreCoudes90,
    this.nombreCoudes45,
    this.tubage,
    this.longueurTubage,
    this.sortieCheminee,
    this.sortieToiture,
    this.sortieParMur,
    this.hauteurSortieToiture,
    this.depassementNormes,
    this.diameterVentouse,
    this.ventouseVerticale,
    this.ventouseHorizontale,
    this.distanceParoiVoisine,
    this.puregePresente,
    this.bouchonGaz,
    this.commentaire,
  });

  EvacuationSection copyWith({
    String? typeEvacuation,
    bool? conduitRigide,
    String? diametre,
    String? matiere,
    String? longueur,
    String? nombreCoudes90,
    String? nombreCoudes45,
    bool? tubage,
    String? longueurTubage,
    bool? sortieCheminee,
    bool? sortieToiture,
    bool? sortieParMur,
    String? hauteurSortieToiture,
    bool? depassementNormes,
    String? diameterVentouse,
    bool? ventouseVerticale,
    bool? ventouseHorizontale,
    String? distanceParoiVoisine,
    bool? puregePresente,
    bool? bouchonGaz,
    String? commentaire,
  }) {
    return EvacuationSection(
      typeEvacuation: typeEvacuation ?? this.typeEvacuation,
      conduitRigide: conduitRigide ?? this.conduitRigide,
      diametre: diametre ?? this.diametre,
      matiere: matiere ?? this.matiere,
      longueur: longueur ?? this.longueur,
      nombreCoudes90: nombreCoudes90 ?? this.nombreCoudes90,
      nombreCoudes45: nombreCoudes45 ?? this.nombreCoudes45,
      tubage: tubage ?? this.tubage,
      longueurTubage: longueurTubage ?? this.longueurTubage,
      sortieCheminee: sortieCheminee ?? this.sortieCheminee,
      sortieToiture: sortieToiture ?? this.sortieToiture,
      sortieParMur: sortieParMur ?? this.sortieParMur,
      hauteurSortieToiture: hauteurSortieToiture ?? this.hauteurSortieToiture,
      depassementNormes: depassementNormes ?? this.depassementNormes,
      diameterVentouse: diameterVentouse ?? this.diameterVentouse,
      ventouseVerticale: ventouseVerticale ?? this.ventouseVerticale,
      ventouseHorizontale: ventouseHorizontale ?? this.ventouseHorizontale,
      distanceParoiVoisine: distanceParoiVoisine ?? this.distanceParoiVoisine,
      puregePresente: puregePresente ?? this.puregePresente,
      bouchonGaz: bouchonGaz ?? this.bouchonGaz,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeEvacuation': typeEvacuation,
      'conduitRigide': conduitRigide,
      'diametre': diametre,
      'matiere': matiere,
      'longueur': longueur,
      'nombreCoudes90': nombreCoudes90,
      'nombreCoudes45': nombreCoudes45,
      'tubage': tubage,
      'longueurTubage': longueurTubage,
      'sortieCheminee': sortieCheminee,
      'sortieToiture': sortieToiture,
      'sortieParMur': sortieParMur,
      'hauteurSortieToiture': hauteurSortieToiture,
      'depassementNormes': depassementNormes,
      'diameterVentouse': diameterVentouse,
      'ventouseVerticale': ventouseVerticale,
      'ventouseHorizontale': ventouseHorizontale,
      'distanceParoiVoisine': distanceParoiVoisine,
      'puregePresente': puregePresente,
      'bouchonGaz': bouchonGaz,
      'commentaire': commentaire,
    };
  }

  factory EvacuationSection.fromJson(Map<String, dynamic> json) {
    return EvacuationSection(
      typeEvacuation: json['typeEvacuation'] as String?,
      conduitRigide: json['conduitRigide'] as bool?,
      diametre: json['diametre'] as String?,
      matiere: json['matiere'] as String?,
      longueur: json['longueur'] as String?,
      nombreCoudes90: json['nombreCoudes90'] as String?,
      nombreCoudes45: json['nombreCoudes45'] as String?,
      tubage: json['tubage'] as bool?,
      longueurTubage: json['longueurTubage'] as String?,
      sortieCheminee: json['sortieCheminee'] as bool?,
      sortieToiture: json['sortieToiture'] as bool?,
      sortieParMur: json['sortieParMur'] as bool?,
      hauteurSortieToiture: json['hauteurSortieToiture'] as String?,
      depassementNormes: json['depassementNormes'] as bool?,
      diameterVentouse: json['diameterVentouse'] as String?,
      ventouseVerticale: json['ventouseVerticale'] as bool?,
      ventouseHorizontale: json['ventouseHorizontale'] as bool?,
      distanceParoiVoisine: json['distanceParoiVoisine'] as String?,
      puregePresente: json['puregePresente'] as bool?,
      bouchonGaz: json['bouchonGaz'] as bool?,
      commentaire: json['commentaire'] as String?,
    );
  }
}
