/// Section Conformité - Vérifications normes gaz
class ConformiteSection {
  // Vérifications obligatoires
  final bool? compteurPlus20m;
  final bool? organeCoupure;
  final bool? alimenteeLigneSeparee;
  final bool? priseTerragePresente;
  final bool? robinetArretGeneralPresent;

  // Sécurité gaz
  final bool? flexibleGazNonPerime;
  final bool? testNonRotationOk;

  // Ventilation
  final bool? ameneeAirPresente;
  final bool? extracteurMotorisePresent;
  final bool? boucheVmcSanitairePresente;

  // Foyer ouvert
  final bool? foyerOuvert;
  final bool? clapet;

  // Conformité générale
  final bool? conformeReglementationGaz;
  final String? raison; // Si non-conforme

  // Commentaires
  final String? commentaire;

  const ConformiteSection({
    this.compteurPlus20m,
    this.organeCoupure,
    this.alimenteeLigneSeparee,
    this.priseTerragePresente,
    this.robinetArretGeneralPresent,
    this.flexibleGazNonPerime,
    this.testNonRotationOk,
    this.ameneeAirPresente,
    this.extracteurMotorisePresent,
    this.boucheVmcSanitairePresente,
    this.foyerOuvert,
    this.clapet,
    this.conformeReglementationGaz,
    this.raison,
    this.commentaire,
  });

  ConformiteSection copyWith({
    bool? compteurPlus20m,
    bool? organeCoupure,
    bool? alimenteeLigneSeparee,
    bool? priseTerragePresente,
    bool? robinetArretGeneralPresent,
    bool? flexibleGazNonPerime,
    bool? testNonRotationOk,
    bool? ameneeAirPresente,
    bool? extracteurMotorisePresent,
    bool? boucheVmcSanitairePresente,
    bool? foyerOuvert,
    bool? clapet,
    bool? conformeReglementationGaz,
    String? raison,
    String? commentaire,
  }) {
    return ConformiteSection(
      compteurPlus20m: compteurPlus20m ?? this.compteurPlus20m,
      organeCoupure: organeCoupure ?? this.organeCoupure,
      alimenteeLigneSeparee: alimenteeLigneSeparee ?? this.alimenteeLigneSeparee,
      priseTerragePresente: priseTerragePresente ?? this.priseTerragePresente,
      robinetArretGeneralPresent:
          robinetArretGeneralPresent ?? this.robinetArretGeneralPresent,
      flexibleGazNonPerime: flexibleGazNonPerime ?? this.flexibleGazNonPerime,
      testNonRotationOk: testNonRotationOk ?? this.testNonRotationOk,
      ameneeAirPresente: ameneeAirPresente ?? this.ameneeAirPresente,
      extracteurMotorisePresent:
          extracteurMotorisePresent ?? this.extracteurMotorisePresent,
      boucheVmcSanitairePresente:
          boucheVmcSanitairePresente ?? this.boucheVmcSanitairePresente,
      foyerOuvert: foyerOuvert ?? this.foyerOuvert,
      clapet: clapet ?? this.clapet,
      conformeReglementationGaz:
          conformeReglementationGaz ?? this.conformeReglementationGaz,
      raison: raison ?? this.raison,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compteurPlus20m': compteurPlus20m,
      'organeCoupure': organeCoupure,
      'alimenteeLigneSeparee': alimenteeLigneSeparee,
      'priseTerragePresente': priseTerragePresente,
      'robinetArretGeneralPresent': robinetArretGeneralPresent,
      'flexibleGazNonPerime': flexibleGazNonPerime,
      'testNonRotationOk': testNonRotationOk,
      'ameneeAirPresente': ameneeAirPresente,
      'extracteurMotorisePresent': extracteurMotorisePresent,
      'boucheVmcSanitairePresente': boucheVmcSanitairePresente,
      'foyerOuvert': foyerOuvert,
      'clapet': clapet,
      'conformeReglementationGaz': conformeReglementationGaz,
      'raison': raison,
      'commentaire': commentaire,
    };
  }

  factory ConformiteSection.fromJson(Map<String, dynamic> json) {
    return ConformiteSection(
      compteurPlus20m: json['compteurPlus20m'] as bool?,
      organeCoupure: json['organeCoupure'] as bool?,
      alimenteeLigneSeparee: json['alimenteeLigneSeparee'] as bool?,
      priseTerragePresente: json['priseTerragePresente'] as bool?,
      robinetArretGeneralPresent:
          json['robinetArretGeneralPresent'] as bool?,
      flexibleGazNonPerime: json['flexibleGazNonPerime'] as bool?,
      testNonRotationOk: json['testNonRotationOk'] as bool?,
      ameneeAirPresente: json['ameneeAirPresente'] as bool?,
      extracteurMotorisePresent: json['extracteurMotorisePresent'] as bool?,
      boucheVmcSanitairePresente: json['boucheVmcSanitairePresente'] as bool?,
      foyerOuvert: json['foyerOuvert'] as bool?,
      clapet: json['clapet'] as bool?,
      conformeReglementationGaz: json['conformeReglementationGaz'] as bool?,
      raison: json['raison'] as String?,
      commentaire: json['commentaire'] as String?,
    );
  }
}
