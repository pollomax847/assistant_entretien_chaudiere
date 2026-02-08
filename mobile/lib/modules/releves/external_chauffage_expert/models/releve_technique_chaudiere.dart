// new_project/lib/core/models/releve_technique_chaudiere.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'releve_technique_chaudiere.freezed.dart';
part 'releve_technique_chaudiere.g.dart';

@freezed
class ReleveTechniqueChaudiere with _$ReleveTechniqueChaudiere {
  @JsonSerializable(explicitToJson: true)
  const factory ReleveTechniqueChaudiere({
    @JsonKey(defaultValue: '') required String id,
    required Map<String, List<String>> sections,
    required List<Photo> photos,
    required DateTime dateCreation,
    String? adresse,
    String? nomEntreprise,
    String? nomTechnicien,
    String? signatureTechnicien,
    String? signatureClient,
  }) = _ReleveTechniqueChaudiere;

  factory ReleveTechniqueChaudiere.fromJson(Map<String, dynamic> json) =>
      _$ReleveTechniqueChaudiereFromJson(json);
}

@freezed
class Photo with _$Photo {
  @JsonSerializable(explicitToJson: true)
  const factory Photo({
    required String path,
    required String description,
    required DateTime datePrise,
  }) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}

extension ReleveTechniqueChaudiereExtension on ReleveTechniqueChaudiere {
  static Map<String, List<String>> getSections() {
    return {
      "Informations du Relevé": [
        "Numéro de relevé: CH-0000",
        "Date: ${DateTime.now().toString()}",
      ],
      "Informations générales": [
        "Adresse: ",
        "Fabricant: ",
        "Modèle: ",
        "Numéro de série: ",
        "Année de fabrication: ",
      ],
      "Caractéristiques techniques": [
        "Puissance nominale: ",
        "Type de combustible: ",
        "Pression de service: ",
        "Température de départ: ",
        "Température de retour: ",
      ],
      "Mesures": [
        "Pression d'eau: ",
        "Pression gaz: ",
        "Tension: ",
        "Intensité: ",
        "Puissance: ",
      ],
      "Observations": [
        "État général: ",
        "Fonctionnement: ",
        "Anomalies: ",
        "Recommandations: ",
      ],
      "Signatures": [
        "Signature technicien: ",
        "Signature client: ",
      ],
    };
  }

  static String genererNumeroReleve(String prefix, int nombre) {
    return "$prefix-${nombre.toString().padLeft(4, '0')}";
  }

  void mettreAJourAdresse(String adresse) {
    sections["Informations générales"]?[0] = "Adresse: $adresse";
  }

  ReleveTechniqueChaudiere mettreAJourTechnicien(
      String entreprise, String technicien) {
    return copyWith(
      nomEntreprise: entreprise,
      nomTechnicien: technicien,
    );
  }
}
