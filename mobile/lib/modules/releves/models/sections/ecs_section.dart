/// Section ECS - Eau Chaude Sanitaire
class EcsSection {
  // Configuration ECS
  final String? typeEcs; // INSTANTANEE, BALLON_SEPARE, MICRO_ACCUM, MIXTE
  final bool? integreChaudiere;

  // Ballon (si applicable)
  final String? volumeBallon; // Litres
  final String? marqueBallon;
  final String? hauteurBallon; // cm
  final String? profondeurBallon; // cm

  // Débits et températures
  final String? debitSimultaneL;
  final String? debitSimultaneM3h;
  final double? temperatureFroide; // °C
  final double? temperatureChaudeConsigne; // °C
  final double? temperatureChaudeMesuree; // °C

  // Accessoires ECS
  final bool? thermostat;
  final bool? reducteurPression;
  final bool? crepine;
  final bool? filtresSanitaires;
  final bool? clapet;

  // Puissance
  final String? puissanceInstantanee; // kW

  // Équipements connectés
  final List<String>? equipements;
  final List<double>? coefficients;

  // Commentaires
  final String? commentaire;

  const EcsSection({
    this.typeEcs,
    this.integreChaudiere,
    this.volumeBallon,
    this.marqueBallon,
    this.hauteurBallon,
    this.profondeurBallon,
    this.debitSimultaneL,
    this.debitSimultaneM3h,
    this.temperatureFroide,
    this.temperatureChaudeConsigne,
    this.temperatureChaudeMesuree,
    this.thermostat,
    this.reducteurPression,
    this.crepine,
    this.filtresSanitaires,
    this.clapet,
    this.puissanceInstantanee,
    this.equipements,
    this.coefficients,
    this.commentaire,
  });

  EcsSection copyWith({
    String? typeEcs,
    bool? integreChaudiere,
    String? volumeBallon,
    String? marqueBallon,
    String? hauteurBallon,
    String? profondeurBallon,
    String? debitSimultaneL,
    String? debitSimultaneM3h,
    double? temperatureFroide,
    double? temperatureChaudeConsigne,
    double? temperatureChaudeMesuree,
    bool? thermostat,
    bool? reducteurPression,
    bool? crepine,
    bool? filtresSanitaires,
    bool? clapet,
    String? puissanceInstantanee,
    List<String>? equipements,
    List<double>? coefficients,
    String? commentaire,
  }) {
    return EcsSection(
      typeEcs: typeEcs ?? this.typeEcs,
      integreChaudiere: integreChaudiere ?? this.integreChaudiere,
      volumeBallon: volumeBallon ?? this.volumeBallon,
      marqueBallon: marqueBallon ?? this.marqueBallon,
      hauteurBallon: hauteurBallon ?? this.hauteurBallon,
      profondeurBallon: profondeurBallon ?? this.profondeurBallon,
      debitSimultaneL: debitSimultaneL ?? this.debitSimultaneL,
      debitSimultaneM3h: debitSimultaneM3h ?? this.debitSimultaneM3h,
      temperatureFroide: temperatureFroide ?? this.temperatureFroide,
      temperatureChaudeConsigne:
          temperatureChaudeConsigne ?? this.temperatureChaudeConsigne,
      temperatureChaudeMesuree:
          temperatureChaudeMesuree ?? this.temperatureChaudeMesuree,
      thermostat: thermostat ?? this.thermostat,
      reducteurPression: reducteurPression ?? this.reducteurPression,
      crepine: crepine ?? this.crepine,
      filtresSanitaires: filtresSanitaires ?? this.filtresSanitaires,
      clapet: clapet ?? this.clapet,
      puissanceInstantanee: puissanceInstantanee ?? this.puissanceInstantanee,
      equipements: equipements ?? this.equipements,
      coefficients: coefficients ?? this.coefficients,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeEcs': typeEcs,
      'integreChaudiere': integreChaudiere,
      'volumeBallon': volumeBallon,
      'marqueBallon': marqueBallon,
      'hauteurBallon': hauteurBallon,
      'profondeurBallon': profondeurBallon,
      'debitSimultaneL': debitSimultaneL,
      'debitSimultaneM3h': debitSimultaneM3h,
      'temperatureFroide': temperatureFroide,
      'temperatureChaudeConsigne': temperatureChaudeConsigne,
      'temperatureChaudeMesuree': temperatureChaudeMesuree,
      'thermostat': thermostat,
      'reducteurPression': reducteurPression,
      'crepine': crepine,
      'filtresSanitaires': filtresSanitaires,
      'clapet': clapet,
      'puissanceInstantanee': puissanceInstantanee,
      'equipements': equipements,
      'coefficients': coefficients,
      'commentaire': commentaire,
    };
  }

  factory EcsSection.fromJson(Map<String, dynamic> json) {
    return EcsSection(
      typeEcs: json['typeEcs'] as String?,
      integreChaudiere: json['integreChaudiere'] as bool?,
      volumeBallon: json['volumeBallon'] as String?,
      marqueBallon: json['marqueBallon'] as String?,
      hauteurBallon: json['hauteurBallon'] as String?,
      profondeurBallon: json['profondeurBallon'] as String?,
      debitSimultaneL: json['debitSimultaneL'] as String?,
      debitSimultaneM3h: json['debitSimultaneM3h'] as String?,
      temperatureFroide: json['temperatureFroide'] as double?,
      temperatureChaudeConsigne: json['temperatureChaudeConsigne'] as double?,
      temperatureChaudeMesuree: json['temperatureChaudeMesuree'] as double?,
      thermostat: json['thermostat'] as bool?,
      reducteurPression: json['reducteurPression'] as bool?,
      crepine: json['crepine'] as bool?,
      filtresSanitaires: json['filtresSanitaires'] as bool?,
      clapet: json['clapet'] as bool?,
      puissanceInstantanee: json['puissanceInstantanee'] as String?,
      equipements: (json['equipements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      coefficients: (json['coefficients'] as List<dynamic>?)
          ?.map((e) => e as double)
          .toList(),
      commentaire: json['commentaire'] as String?,
    );
  }
}
