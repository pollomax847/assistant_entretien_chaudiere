// new_project/lib/models/chaudiere.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chaudiere.freezed.dart';
part 'chaudiere.g.dart';

@freezed
@HiveType(typeId: 0)
class Chaudiere with _$Chaudiere {
  const Chaudiere._(); // Constructeur privé requis pour les getters

  const factory Chaudiere({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String type,
    @HiveField(3) required double puissanceNominale,
    @HiveField(4) required double rendement,
    @HiveField(5) DateTime? dateDernierEntretien,
    @HiveField(6) String? marque,
    @HiveField(7) String? modele,
    @HiveField(8) String? numeroSerie,
    @HiveField(9) DateTime? dateInstallation,
    @HiveField(10) String? adresse,
    @HiveField(11) String? client,
    @HiveField(12) Map<String, dynamic>? parametresCombustion,
    @HiveField(13) List<String>? photos,
    @HiveField(14) @Default(false) bool conforme,
    @HiveField(15) List<String>? nonConformites,
    @HiveField(16) Map<String, dynamic>? mesures,
    @HiveField(17) String? signatureClient,
    @HiveField(18) String? signatureTechnicien,
  }) = _Chaudiere;

  factory Chaudiere.fromJson(Map<String, dynamic> json) =>
      _$ChaudiereFromJson(json);

  // Getters
  double get puissance => puissanceNominale * (rendement / 100);
}

class ReleveTechniqueChaudiere {
  final String id;
  final Map<String, List<String>> sections;
  final List<PhotoData> photos;
  final DateTime dateCreation;

  ReleveTechniqueChaudiere({
    required this.id,
    required this.sections,
    required this.photos,
    required this.dateCreation,
  });

  static Map<String, List<String>> getSections() {
    return {
      "Informations du Relevé": ["Numéro de relevé: "],
      "Informations générales": ["Adresse: "],
    };
  }

  static String genererNumeroReleve(String prefix, int numero) {
    return "${prefix}_${numero.toString().padLeft(4, '0')}";
  }

  void mettreAJourAdresse(String adresse) {}
  void mettreAJourTechnicien(String entreprise, String technicien) {}

  ReleveTechniqueChaudiere copyWith({
    List<PhotoData>? photos,
    List<int>? signatureTechnicien,
    List<int>? signatureClient,
  }) {
    return ReleveTechniqueChaudiere(
      id: id,
      sections: sections,
      photos: photos ?? this.photos,
      dateCreation: dateCreation,
    );
  }

  Map<String, List<String>> identifierFabricant() {
    return {"Configuration non reconnue": []};
  }
}

class PhotoData {
  final String path;
  final String? category;

  PhotoData({required this.path, this.category});
}
