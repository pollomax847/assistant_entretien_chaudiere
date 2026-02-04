import 'sections/client_section.dart';
import 'sections/chaudiere_section.dart';
import 'sections/ecs_section.dart';
import 'sections/tirage_section.dart';
import 'sections/evacuation_section.dart';
import 'sections/conformite_section.dart';
import 'sections/accessoires_section.dart';
import 'sections/securite_section.dart';
import 'sections/puissance_section.dart';
import 'sections/vmc_section.dart';

/// Type d'équipement principal
enum TypeReleve {
  chaudiere,
  pac, // Pompe à chaleur
  clim, // Climatisation
  radiateur,
}

/// Modèle complet du Relevé Technique - Parent
/// Agrège 9 sections logiques pour une meilleure organisation
class ReleveTechnique {
  // Métadonnées
  final String? id;
  final DateTime dateCreation;
  final DateTime? dateModification;
  final DateTime? dateVisite;

  // Équipement principal
  final TypeReleve? typeEquipement;

  // Sections logiques (9 sections)
  final ClientSection? client;
  final ChaudiereSection? chaudiere;
  final EcsSection? ecs;
  final TirageSection? tirage;
  final EvacuationSection? evacuation;
  final ConformiteSection? conformite;
  final AccessoiresSection? accessoires;
  final SecuriteSection? securite;
  final PuissanceSection? puissance;
  final VmcSection? vmc;

  // Fichiers/Photos
  final List<String>? photos; // Chemins des photos
  final List<String>? pieces; // Fichiers justificatifs

  // Commentaires globaux
  final String? commentaireGlobal;

  // Données de test (préservation de l'ancienne structure si besoin)
  final Map<String, dynamic>? donneesLegacy;

  const ReleveTechnique({
    this.id,
    required this.dateCreation,
    this.dateModification,
    this.dateVisite,
    this.typeEquipement,
    this.client,
    this.chaudiere,
    this.ecs,
    this.tirage,
    this.evacuation,
    this.conformite,
    this.accessoires,
    this.securite,
    this.puissance,
    this.vmc,
    this.photos,
    this.pieces,
    this.commentaireGlobal,
    this.donneesLegacy,
  });

  /// Crée un nouveau ReléveTechnique avec les sections vides
  factory ReleveTechnique.create({
    String? id,
    TypeReleve? typeEquipement,
    DateTime? dateVisite,
  }) {
    return ReleveTechnique(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      dateCreation: DateTime.now(),
      dateModification: DateTime.now(),
      dateVisite: dateVisite,
      typeEquipement: typeEquipement,
    );
  }

  /// Copie avec modifications partielles
  ReleveTechnique copyWith({
    String? id,
    DateTime? dateCreation,
    DateTime? dateModification,
    DateTime? dateVisite,
    TypeReleve? typeEquipement,
    ClientSection? client,
    ChaudiereSection? chaudiere,
    EcsSection? ecs,
    TirageSection? tirage,
    EvacuationSection? evacuation,
    ConformiteSection? conformite,
    AccessoiresSection? accessoires,
    SecuriteSection? securite,
    PuissanceSection? puissance,
    VmcSection? vmc,
    List<String>? photos,
    List<String>? pieces,
    String? commentaireGlobal,
    Map<String, dynamic>? donneesLegacy,
  }) {
    return ReleveTechnique(
      id: id ?? this.id,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? DateTime.now(),
      dateVisite: dateVisite ?? this.dateVisite,
      typeEquipement: typeEquipement ?? this.typeEquipement,
      client: client ?? this.client,
      chaudiere: chaudiere ?? this.chaudiere,
      ecs: ecs ?? this.ecs,
      tirage: tirage ?? this.tirage,
      evacuation: evacuation ?? this.evacuation,
      conformite: conformite ?? this.conformite,
      accessoires: accessoires ?? this.accessoires,
      securite: securite ?? this.securite,
      puissance: puissance ?? this.puissance,
      vmc: vmc ?? this.vmc,
      photos: photos ?? this.photos,
      pieces: pieces ?? this.pieces,
      commentaireGlobal: commentaireGlobal ?? this.commentaireGlobal,
      donneesLegacy: donneesLegacy ?? this.donneesLegacy,
    );
  }

  /// Sérialise en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreation': dateCreation.toIso8601String(),
      'dateModification': dateModification?.toIso8601String(),
      'dateVisite': dateVisite?.toIso8601String(),
      'typeEquipement': typeEquipement?.toString().split('.').last,
      'client': client?.toJson(),
      'chaudiere': chaudiere?.toJson(),
      'ecs': ecs?.toJson(),
      'tirage': tirage?.toJson(),
      'evacuation': evacuation?.toJson(),
      'conformite': conformite?.toJson(),
      'accessoires': accessoires?.toJson(),
      'securite': securite?.toJson(),
      'puissance': puissance?.toJson(),
      'vmc': vmc?.toJson(),
      'photos': photos,
      'pieces': pieces,
      'commentaireGlobal': commentaireGlobal,
      'donneesLegacy': donneesLegacy,
    };
  }

  /// Désérialise depuis JSON
  factory ReleveTechnique.fromJson(Map<String, dynamic> json) {
    return ReleveTechnique(
      id: json['id'] as String?,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      dateModification:
          json['dateModification'] != null
              ? DateTime.parse(json['dateModification'] as String)
              : null,
      dateVisite:
          json['dateVisite'] != null
              ? DateTime.parse(json['dateVisite'] as String)
              : null,
      typeEquipement:
          json['typeEquipement'] != null
              ? TypeReleve.values.firstWhere(
                  (e) =>
                      e.toString().split('.').last ==
                      json['typeEquipement'],
                  orElse: () => TypeReleve.chaudiere,
                )
              : null,
      client:
          json['client'] != null
              ? ClientSection.fromJson(json['client'] as Map<String, dynamic>)
              : null,
      chaudiere:
          json['chaudiere'] != null
              ? ChaudiereSection.fromJson(
                  json['chaudiere'] as Map<String, dynamic>,
                )
              : null,
      ecs:
          json['ecs'] != null
              ? EcsSection.fromJson(json['ecs'] as Map<String, dynamic>)
              : null,
      tirage:
          json['tirage'] != null
              ? TirageSection.fromJson(json['tirage'] as Map<String, dynamic>)
              : null,
      evacuation:
          json['evacuation'] != null
              ? EvacuationSection.fromJson(
                  json['evacuation'] as Map<String, dynamic>,
                )
              : null,
      conformite:
          json['conformite'] != null
              ? ConformiteSection.fromJson(
                  json['conformite'] as Map<String, dynamic>,
                )
              : null,
      accessoires:
          json['accessoires'] != null
              ? AccessoiresSection.fromJson(
                  json['accessoires'] as Map<String, dynamic>,
                )
              : null,
      securite:
          json['securite'] != null
              ? SecuriteSection.fromJson(
                  json['securite'] as Map<String, dynamic>,
                )
              : null,
      puissance:
          json['puissance'] != null
              ? PuissanceSection.fromJson(
                  json['puissance'] as Map<String, dynamic>,
                )
              : null,
      vmc:
          json['vmc'] != null
              ? VmcSection.fromJson(json['vmc'] as Map<String, dynamic>)
              : null,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pieces: (json['pieces'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      commentaireGlobal: json['commentaireGlobal'] as String?,
      donneesLegacy: json['donneesLegacy'] as Map<String, dynamic>?,
    );
  }

  /// Vérifie si le relevé est complet (toutes sections remplies)
  bool get estComplet {
    return client != null &&
        chaudiere != null &&
        ecs != null &&
        tirage != null &&
        evacuation != null &&
        conformite != null &&
        accessoires != null &&
        securite != null;
  }

  /// Pourcentage de complétion (0-100)
  int get pourcentageCompletion {
    final sections = [
      client != null,
      chaudiere != null,
      ecs != null,
      tirage != null,
      evacuation != null,
      conformite != null,
      accessoires != null,
      securite != null,
      puissance != null,
      vmc != null,
    ];
    final completes = sections.where((s) => s).length;
    return ((completes / sections.length) * 100).toInt();
  }
}
