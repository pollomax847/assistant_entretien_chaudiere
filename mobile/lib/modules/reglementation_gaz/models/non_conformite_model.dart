import 'dart:io';

/// Modèle pour une non-conformité Qualigaz avec photos optionnelles
class NonConformite {
  /// ID unique de la non-conformité (ex: 'NC_001')
  final String id;
  
  /// Code Qualigaz associé
  final String codeQualigaz;
  
  /// Description de la non-conformité
  final String description;
  
  /// Sévérité (critique, majeure, mineure)
  final String severite;
  
  /// Observations/commentaires sur la non-conformité
  final String? observation;
  
  /// Photos associées à cette non-conformité
  /// (non-obligatoires mais recommandées)
  final List<File> photos;
  
  /// Date de création
  final DateTime dateCreation;

  NonConformite({
    required this.id,
    required this.codeQualigaz,
    required this.description,
    required this.severite,
    this.observation,
    this.photos = const [],
    DateTime? dateCreation,
  }) : dateCreation = dateCreation ?? DateTime.now();

  /// Convertir en JSON pour sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codeQualigaz': codeQualigaz,
      'description': description,
      'severite': severite,
      'observation': observation,
      'photoPaths': photos.map((f) => f.path).toList(),
      'dateCreation': dateCreation.toIso8601String(),
    };
  }

  /// Créer depuis JSON
  factory NonConformite.fromJson(Map<String, dynamic> json) {
    return NonConformite(
      id: json['id'] as String,
      codeQualigaz: json['codeQualigaz'] as String,
      description: json['description'] as String,
      severite: json['severite'] as String,
      observation: json['observation'] as String?,
      photos: (json['photoPaths'] as List<dynamic>?)
              ?.map((path) => File(path as String))
              .toList() ??
          [],
      dateCreation: DateTime.parse(json['dateCreation'] as String),
    );
  }

  /// Nombre de photos attachées
  int get nombrePhotos => photos.length;
  
  /// Vérifier si des photos sont présentes
  bool get aDesPhotos => photos.isNotEmpty;
}
