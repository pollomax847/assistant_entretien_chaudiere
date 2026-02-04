/// Section VMC - Ventilation mécanique contrôlée
class VmcSection {
  // Configuration VMC
  final bool? vmcPresente;
  final String? typeVmc; // Simple flux, Double flux, Hygroréglable
  final String? marqueVmc;
  final String? modeleVmc;
  final int? anneeInstallationVmc;

  // Débits
  final String? debitExtractionSalon; // m³/h
  final String? debitExtractionCuisine; // m³/h
  final String? debitExtractionSalle; // m³/h
  final String? debitEntreeAir; // m³/h

  // Conduits
  final bool? conduitsRigides;
  final String? materieConduit; // PVC, Alu, Caisson, etc
  final bool? isolationConduits;

  // Sortie
  final bool? sortieToiture;
  final bool? sortieParMur;
  final bool? aerotrermiquesPresentes;

  // Maintenance
  final bool? filtresDeclassables;
  final DateTime? derniereMaintenanceDate;
  final bool? cmaintenance;

  // Particularités
  final bool? foyer; // Foyer ouvert compatible VMC?
  final String? commentaire;

  const VmcSection({
    this.vmcPresente,
    this.typeVmc,
    this.marqueVmc,
    this.modeleVmc,
    this.anneeInstallationVmc,
    this.debitExtractionSalon,
    this.debitExtractionCuisine,
    this.debitExtractionSalle,
    this.debitEntreeAir,
    this.conduitsRigides,
    this.materieConduit,
    this.isolationConduits,
    this.sortieToiture,
    this.sortieParMur,
    this.aerotrermiquesPresentes,
    this.filtresDeclassables,
    this.derniereMaintenanceDate,
    this.cmaintenance,
    this.foyer,
    this.commentaire,
  });

  VmcSection copyWith({
    bool? vmcPresente,
    String? typeVmc,
    String? marqueVmc,
    String? modeleVmc,
    int? anneeInstallationVmc,
    String? debitExtractionSalon,
    String? debitExtractionCuisine,
    String? debitExtractionSalle,
    String? debitEntreeAir,
    bool? conduitsRigides,
    String? materieConduit,
    bool? isolationConduits,
    bool? sortieToiture,
    bool? sortieParMur,
    bool? aerotrermiquesPresentes,
    bool? filtresDeclassables,
    DateTime? derniereMaintenanceDate,
    bool? cmaintenance,
    bool? foyer,
    String? commentaire,
  }) {
    return VmcSection(
      vmcPresente: vmcPresente ?? this.vmcPresente,
      typeVmc: typeVmc ?? this.typeVmc,
      marqueVmc: marqueVmc ?? this.marqueVmc,
      modeleVmc: modeleVmc ?? this.modeleVmc,
      anneeInstallationVmc: anneeInstallationVmc ?? this.anneeInstallationVmc,
      debitExtractionSalon:
          debitExtractionSalon ?? this.debitExtractionSalon,
      debitExtractionCuisine:
          debitExtractionCuisine ?? this.debitExtractionCuisine,
      debitExtractionSalle:
          debitExtractionSalle ?? this.debitExtractionSalle,
      debitEntreeAir: debitEntreeAir ?? this.debitEntreeAir,
      conduitsRigides: conduitsRigides ?? this.conduitsRigides,
      materieConduit: materieConduit ?? this.materieConduit,
      isolationConduits: isolationConduits ?? this.isolationConduits,
      sortieToiture: sortieToiture ?? this.sortieToiture,
      sortieParMur: sortieParMur ?? this.sortieParMur,
      aerotrermiquesPresentes:
          aerotrermiquesPresentes ?? this.aerotrermiquesPresentes,
      filtresDeclassables: filtresDeclassables ?? this.filtresDeclassables,
      derniereMaintenanceDate:
          derniereMaintenanceDate ?? this.derniereMaintenanceDate,
      cmaintenance: cmaintenance ?? this.cmaintenance,
      foyer: foyer ?? this.foyer,
      commentaire: commentaire ?? this.commentaire,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vmcPresente': vmcPresente,
      'typeVmc': typeVmc,
      'marqueVmc': marqueVmc,
      'modeleVmc': modeleVmc,
      'anneeInstallationVmc': anneeInstallationVmc,
      'debitExtractionSalon': debitExtractionSalon,
      'debitExtractionCuisine': debitExtractionCuisine,
      'debitExtractionSalle': debitExtractionSalle,
      'debitEntreeAir': debitEntreeAir,
      'conduitsRigides': conduitsRigides,
      'materieConduit': materieConduit,
      'isolationConduits': isolationConduits,
      'sortieToiture': sortieToiture,
      'sortieParMur': sortieParMur,
      'aerotrermiquesPresentes': aerotrermiquesPresentes,
      'filtresDeclassables': filtresDeclassables,
      'derniereMaintenanceDate': derniereMaintenanceDate?.toIso8601String(),
      'cmaintenance': cmaintenance,
      'foyer': foyer,
      'commentaire': commentaire,
    };
  }

  factory VmcSection.fromJson(Map<String, dynamic> json) {
    return VmcSection(
      vmcPresente: json['vmcPresente'] as bool?,
      typeVmc: json['typeVmc'] as String?,
      marqueVmc: json['marqueVmc'] as String?,
      modeleVmc: json['modeleVmc'] as String?,
      anneeInstallationVmc: json['anneeInstallationVmc'] as int?,
      debitExtractionSalon: json['debitExtractionSalon'] as String?,
      debitExtractionCuisine: json['debitExtractionCuisine'] as String?,
      debitExtractionSalle: json['debitExtractionSalle'] as String?,
      debitEntreeAir: json['debitEntreeAir'] as String?,
      conduitsRigides: json['conduitsRigides'] as bool?,
      materieConduit: json['materieConduit'] as String?,
      isolationConduits: json['isolationConduits'] as bool?,
      sortieToiture: json['sortieToiture'] as bool?,
      sortieParMur: json['sortieParMur'] as bool?,
      aerotrermiquesPresentes: json['aerotrermiquesPresentes'] as bool?,
      filtresDeclassables: json['filtresDeclassables'] as bool?,
      derniereMaintenanceDate:
          json['derniereMaintenanceDate'] != null
              ? DateTime.parse(json['derniereMaintenanceDate'] as String)
              : null,
      cmaintenance: json['cmaintenance'] as bool?,
      foyer: json['foyer'] as bool?,
      commentaire: json['commentaire'] as String?,
    );
  }
}
