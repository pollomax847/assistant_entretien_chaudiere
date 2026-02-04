/// Section Accessoires - Équipements additionnels
class AccessoiresSection {
  // Filtration
  final bool? filtrePresent;
  final String? typeFiltre; // Sanitaire, Magnétique, etc
  final bool? preFiltre;

  // Eau
  final bool? desembouage;
  final bool? reducteurPression;
  final bool? crepine;

  // Chauffage
  final bool? vasExpansion;
  final String? typeVase; // Fermée, Ouverte
  final String? volumeVase;
  final bool? sonde;

  // Contrôle
  final bool? dsp; // Détecteur de surpression
  final bool? limiteurTemperature;
  final bool? manometrePresent;

  // Gaz
  final bool? flexibleGaz;
  final bool? roaiPresent;

  // Sécurité additionnelle
  final bool? daaf;
  final bool? detectionGaz;

  // Accessoires spécifiques
  final List<String>? autresAccessoires;

  // Commentaires
  final String? commentaire;

  const AccessoiresSection({
    this.filtrePresent,
    this.typeFiltre,
    this.preFiltre,
    this.desembouage,
    this.reducteurPression,
    this.crepine,
    this.vasExpansion,
    this.typeVase,
    this.volumeVase,
    this.sonde,
    this.dsp,
    this.limiteurTemperature,
    this.manometrePresent,
    this.flexibleGaz,
    this.roaiPresent,
    this.daaf,
    this.detectionGaz,
    this.autresAccessoires,
    this.commentaire,
  });

  AccessoiresSection copyWith({
    bool? filtrePresent,
    String? typeFiltre,
    bool? preFiltre,
    bool? desembouage,
    bool? reducteurPression,
    bool? crepine,
    bool? vasExpansion,
    String? typeVase,
    String? volumeVase,
    bool? sonde,
    bool? dsp,
    bool? limiteurTemperature,
    bool? manometrePresent,
    bool? flexibleGaz,
    bool? roaiPresent,
    bool? daaf,
    bool? detectionGaz,
    List<String>? autresAccessoires,
    String? commentaire,
  }) {
    return AccessoiresSection(
      filtrePresent: filtrePresent ?? this.filtrePresent,
      typeFiltre: typeFiltre ?? this.typeFiltre,
      preFiltre: preFiltre ?? this.preFiltre,
      desembouage: desembouage ?? this.desembouage,
      reducteurPression: reducteurPression ?? this.reducteurPression,
      crepine: crepine ?? this.crepine,
      vasExpansion: vasExpansion ?? this.vasExpansion,
      typeVase: typeVase ?? this.typeVase,
      volumeVase: volumeVase ?? this.volumeVase,
      sonde: sonde ?? this.sonde,
      dsp: dsp ?? this.dsp,
      limiteurTemperature: limiteurTemperature ?? this.limiteurTemperature,
      manometrePresent: manometrePresent ?? this.manometrePresent,
      flexibleGaz: flexibleGaz ?? this.flexibleGaz,
      roaiPresent: roaiPresent ?? this.roaiPresent,
      daaf: daaf ?? this.daaf,
      detectionGaz: detectionGaz ?? this.detectionGaz,
      autresAccessoires: autresAccessoires ?? this.autresAccessoires,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filtrePresent': filtrePresent,
      'typeFiltre': typeFiltre,
      'preFiltre': preFiltre,
      'desembouage': desembouage,
      'reducteurPression': reducteurPression,
      'crepine': crepine,
      'vasExpansion': vasExpansion,
      'typeVase': typeVase,
      'volumeVase': volumeVase,
      'sonde': sonde,
      'dsp': dsp,
      'limiteurTemperature': limiteurTemperature,
      'manometrePresent': manometrePresent,
      'flexibleGaz': flexibleGaz,
      'roaiPresent': roaiPresent,
      'daaf': daaf,
      'detectionGaz': detectionGaz,
      'autresAccessoires': autresAccessoires,
      'commentaire': commentaire,
    };
  }

  factory AccessoiresSection.fromJson(Map<String, dynamic> json) {
    return AccessoiresSection(
      filtrePresent: json['filtrePresent'] as bool?,
      typeFiltre: json['typeFiltre'] as String?,
      preFiltre: json['preFiltre'] as bool?,
      desembouage: json['desembouage'] as bool?,
      reducteurPression: json['reducteurPression'] as bool?,
      crepine: json['crepine'] as bool?,
      vasExpansion: json['vasExpansion'] as bool?,
      typeVase: json['typeVase'] as String?,
      volumeVase: json['volumeVase'] as String?,
      sonde: json['sonde'] as bool?,
      dsp: json['dsp'] as bool?,
      limiteurTemperature: json['limiteurTemperature'] as bool?,
      manometrePresent: json['manometrePresent'] as bool?,
      flexibleGaz: json['flexibleGaz'] as bool?,
      roaiPresent: json['roaiPresent'] as bool?,
      daaf: json['daaf'] as bool?,
      detectionGaz: json['detectionGaz'] as bool?,
      autresAccessoires: (json['autresAccessoires'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      commentaire: json['commentaire'] as String?,
    );
  }
}
