// ChauffageExpert/lib/models/equipment.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'equipment.freezed.dart';
part 'equipment.g.dart';

@freezed
@HiveType(typeId: 1)
class Equipment with _$Equipment {
  const Equipment._(); // Constructeur privé requis pour les getters

  const factory Equipment({
    @HiveField(0) required String id,
    @HiveField(1) required String equipmentName,
    @HiveField(2) required String type,
    @HiveField(3) String? marque,
    @HiveField(4) String? modele,
    @HiveField(5) String? numeroSerie,
    @HiveField(6) DateTime? dateInstallation,
    @HiveField(7) bool? conforme,
    @HiveField(8) DateTime? dateIntervention,
    @HiveField(9) String? nomClient,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);

  // Getters
  String get name => equipmentName;
  bool get isConforme => conforme ?? false;
  DateTime? get interventionDate => dateIntervention;
  String? get clientName => nomClient;
}
