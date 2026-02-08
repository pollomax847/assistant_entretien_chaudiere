// new_project/lib/models/dimensionnement.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'dimensionnement.freezed.dart';
part 'dimensionnement.g.dart';

@freezed
@HiveType(typeId: 3)
class Dimensionnement with _$Dimensionnement {
  const Dimensionnement._(); // Constructeur privé requis pour les getters

  const factory Dimensionnement({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime date,
    @HiveField(2) required double surfaceHabitable,
    @HiveField(3) required double hauteurSousPafond,
    @HiveField(4) required String zoneClimatique,
    @HiveField(5) required double coefficientG,
    @HiveField(6) required double temperatureExterieure,
    @HiveField(7) required double temperatureInterieure,
    @HiveField(8) required Map<String, double> deperditionsPieces,
    @HiveField(9) String? commentaires,
  }) = _Dimensionnement;

  factory Dimensionnement.fromJson(Map<String, dynamic> json) =>
      _$DimensionnementFromJson(json);

  // Getters
  double get volumeTotal => surfaceHabitable * hauteurSousPafond;
  
  double get deperditionsGlobales {
    final deltaT = temperatureInterieure - temperatureExterieure;
    return volumeTotal * coefficientG * deltaT;
  }
  
  double get deperditionsTotales {
    return deperditionsPieces.values.fold(0, (sum, value) => sum + value);
  }
  
  double get puissanceChaudiereRecommandee {
    // On ajoute une marge de sécurité de 20%
    return deperditionsTotales * 1.2;
  }
} 