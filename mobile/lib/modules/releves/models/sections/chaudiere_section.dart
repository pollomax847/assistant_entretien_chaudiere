/// Section Chaudière - Équipement chaudière, énergie, configuration
class ChaudiereSection {
  // Équipement actuel
  final String? marque;
  final String? modele;
  final int? anneeInstallation;
  final String? energie; // GPL, GN, Fioul
  final String? puissance; // Watts

  // Configuration
  final bool? chauffageSeul;
  final bool? avecEcs; // Eau chaude sanitaire
  final String? typeBallonEcs; // Ballon séparé, instantané, micro-accumulation

  // Ballons ECS
  final String? volumeBallon; // Litres
  final String? marqueBallon; // Marque du ballon
  final String? hauteurBallon; // cm
  final String? profondeurBallon; // cm

  // Installation
  final bool? radiateur;
  final bool? plancherChauffant;
  final String? typeTuyauterie;
  final bool? tuyauxDerriereChaudiere;

  // Raccordements
  final String? typeRaccordementEvacuation;
  final String? diametre;
  final bool? besoinPompeRelevage;

  // Électricité
  final String? typeAlimentationElectrique;

  // Commentaires
  final String? commentaire;

  const ChaudiereSection({
    this.marque,
    this.modele,
    this.anneeInstallation,
    this.energie,
    this.puissance,
    this.chauffageSeul,
    this.avecEcs,
    this.typeBallonEcs,
    this.volumeBallon,
    this.marqueBallon,
    this.hauteurBallon,
    this.profondeurBallon,
    this.radiateur,
    this.plancherChauffant,
    this.typeTuyauterie,
    this.tuyauxDerriereChaudiere,
    this.typeRaccordementEvacuation,
    this.diametre,
    this.besoinPompeRelevage,
    this.typeAlimentationElectrique,
    this.commentaire,
  });

  ChaudiereSection copyWith({
    String? marque,
    String? modele,
    int? anneeInstallation,
    String? energie,
    String? puissance,
    bool? chauffageSeul,
    bool? avecEcs,
    String? typeBallonEcs,
    String? marqueBallon,
    String? hauteurBallon,
    String? profondeurBallon,
    bool? radiateur,
    bool? plancherChauffant,
    String? typeTuyauterie,
    bool? tuyauxDerriereChaudiere,
    String? typeRaccordementEvacuation,
    String? diametre,
    bool? besoinPompeRelevage,
    String? typeAlimentationElectrique,
    String? commentaire,
  }) {
    return ChaudiereSection(
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      anneeInstallation: anneeInstallation ?? this.anneeInstallation,
      energie: energie ?? this.energie,
      puissance: puissance ?? this.puissance,
      chauffageSeul: chauffageSeul ?? this.chauffageSeul,
      avecEcs: avecEcs ?? this.avecEcs,
      typeBallonEcs: typeBallonEcs ?? this.typeBallonEcs,
      volumeBallon: volumeBallon ?? this.volumeBallon,
      marqueBallon: marqueBallon ?? this.marqueBallon,
      hauteurBallon: hauteurBallon ?? this.hauteurBallon,
      profondeurBallon: profondeurBallon ?? this.profondeurBallon,
      radiateur: radiateur ?? this.radiateur,
      plancherChauffant: plancherChauffant ?? this.plancherChauffant,
      typeTuyauterie: typeTuyauterie ?? this.typeTuyauterie,
      tuyauxDerriereChaudiere:
          tuyauxDerriereChaudiere ?? this.tuyauxDerriereChaudiere,
      typeRaccordementEvacuation:
          typeRaccordementEvacuation ?? this.typeRaccordementEvacuation,
      diametre: diametre ?? this.diametre,
      besoinPompeRelevage: besoinPompeRelevage ?? this.besoinPompeRelevage,
      typeAlimentationElectrique:
          typeAlimentationElectrique ?? this.typeAlimentationElectrique,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'marque': marque,
      'modele': modele,
      'anneeInstallation': anneeInstallation,
      'energie': energie,
      'puissance': puissance,
      'chauffageSeul': chauffageSeul,
      'avecEcs': avecEcs,
      'typeBallonEcs': typeBallonEcs,
      'volumeBallon': volumeBallon,
      'marqueBallon': marqueBallon,
      'hauteurBallon': hauteurBallon,
      'profondeurBallon': profondeurBallon,
      'radiateur': radiateur,
      'plancherChauffant': plancherChauffant,
      'typeTuyauterie': typeTuyauterie,
      'tuyauxDerriereChaudiere': tuyauxDerriereChaudiere,
      'typeRaccordementEvacuation': typeRaccordementEvacuation,
      'diametre': diametre,
      'besoinPompeRelevage': besoinPompeRelevage,
      'typeAlimentationElectrique': typeAlimentationElectrique,
      'commentaire': commentaire,
    };
  }

  factory ChaudiereSection.fromJson(Map<String, dynamic> json) {
    return ChaudiereSection(
      marque: json['marque'] as String?,
      modele: json['modele'] as String?,
      anneeInstallation: json['anneeInstallation'] as int?,
      energie: json['energie'] as String?,
      puissance: json['puissance'] as String?,
      chauffageSeul: json['chauffageSeul'] as bool?,
      avecEcs: json['avecEcs'] as bool?,
      typeBallonEcs: json['typeBallonEcs'] as String?,
      volumeBallon: json['volumeBallon'] as String?,
      marqueBallon: json['marqueBallon'] as String?,
      hauteurBallon: json['hauteurBallon'] as String?,
      profondeurBallon: json['profondeurBallon'] as String?,
      radiateur: json['radiateur'] as bool?,
      plancherChauffant: json['plancherChauffant'] as bool?,
      typeTuyauterie: json['typeTuyauterie'] as String?,
      tuyauxDerriereChaudiere: json['tuyauxDerriereChaudiere'] as bool?,
      typeRaccordementEvacuation:
          json['typeRaccordementEvacuation'] as String?,
      diametre: json['diametre'] as String?,
      besoinPompeRelevage: json['besoinPompeRelevage'] as bool?,
      typeAlimentationElectrique:
          json['typeAlimentationElectrique'] as String?,
      commentaire: json['commentaire'] as String?,
    );
  }
}
