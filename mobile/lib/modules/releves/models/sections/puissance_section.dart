/// Section Puissance - Calculs puissance chauffage
class PuissanceSection {
  // Déperditions thermiques
  final String? deperditonsCalculees; // W
  final String? depertitionsEstimees;

  // Capacité chaudière
  final String? puissanceChaudiere; // kW
  final bool? puissanceSuffisante;

  // Chauffage
  final bool? radiateurs;
  final bool? plancherChauffant;
  final String? surfacePlancherChauffant; // m²
  final String? temperatureDepart; // °C
  final String? temperatureRetour; // °C

  // Tuyauterie
  final bool? isolationTuyauterie;
  final String? reseauDistribution;

  // Commentaires
  final String? commentaire;

  const PuissanceSection({
    this.deperditonsCalculees,
    this.depertitionsEstimees,
    this.puissanceChaudiere,
    this.puissanceSuffisante,
    this.radiateurs,
    this.plancherChauffant,
    this.surfacePlancherChauffant,
    this.temperatureDepart,
    this.temperatureRetour,
    this.isolationTuyauterie,
    this.reseauDistribution,
    this.commentaire,
  });

  PuissanceSection copyWith({
    String? deperditonsCalculees,
    String? depertitionsEstimees,
    String? puissanceChaudiere,
    bool? puissanceSuffisante,
    bool? radiateurs,
    bool? plancherChauffant,
    String? surfacePlancherChauffant,
    String? temperatureDepart,
    String? temperatureRetour,
    bool? isolationTuyauterie,
    String? reseauDistribution,
    String? commentaire,
  }) {
    return PuissanceSection(
      deperditonsCalculees:
          deperditonsCalculees ?? this.deperditonsCalculees,
      depertitionsEstimees:
          depertitionsEstimees ?? this.depertitionsEstimees,
      puissanceChaudiere: puissanceChaudiere ?? this.puissanceChaudiere,
      puissanceSuffisante: puissanceSuffisante ?? this.puissanceSuffisante,
      radiateurs: radiateurs ?? this.radiateurs,
      plancherChauffant: plancherChauffant ?? this.plancherChauffant,
      surfacePlancherChauffant:
          surfacePlancherChauffant ?? this.surfacePlancherChauffant,
      temperatureDepart: temperatureDepart ?? this.temperatureDepart,
      temperatureRetour: temperatureRetour ?? this.temperatureRetour,
      isolationTuyauterie: isolationTuyauterie ?? this.isolationTuyauterie,
      reseauDistribution: reseauDistribution ?? this.reseauDistribution,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deperditonsCalculees': deperditonsCalculees,
      'depertitionsEstimees': depertitionsEstimees,
      'puissanceChaudiere': puissanceChaudiere,
      'puissanceSuffisante': puissanceSuffisante,
      'radiateurs': radiateurs,
      'plancherChauffant': plancherChauffant,
      'surfacePlancherChauffant': surfacePlancherChauffant,
      'temperatureDepart': temperatureDepart,
      'temperatureRetour': temperatureRetour,
      'isolationTuyauterie': isolationTuyauterie,
      'reseauDistribution': reseauDistribution,
      'commentaire': commentaire,
    };
  }

  factory PuissanceSection.fromJson(Map<String, dynamic> json) {
    return PuissanceSection(
      deperditonsCalculees: json['deperditonsCalculees'] as String?,
      depertitionsEstimees: json['depertitionsEstimees'] as String?,
      puissanceChaudiere: json['puissanceChaudiere'] as String?,
      puissanceSuffisante: json['puissanceSuffisante'] as bool?,
      radiateurs: json['radiateurs'] as bool?,
      plancherChauffant: json['plancherChauffant'] as bool?,
      surfacePlancherChauffant: json['surfacePlancherChauffant'] as String?,
      temperatureDepart: json['temperatureDepart'] as String?,
      temperatureRetour: json['temperatureRetour'] as String?,
      isolationTuyauterie: json['isolationTuyauterie'] as bool?,
      reseauDistribution: json['reseauDistribution'] as String?,
      commentaire: json['commentaire'] as String?,
    );
  }
}
