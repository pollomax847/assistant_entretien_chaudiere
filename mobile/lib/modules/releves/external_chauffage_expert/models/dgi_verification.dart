// new_project/lib/models/dgi_verification.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'dgi_verification.freezed.dart';
part 'dgi_verification.g.dart';

@freezed
@HiveType(typeId: 1)
class DGIVerification with _$DGIVerification {
  const DGIVerification._(); // Constructeur privé requis pour les getters

  const factory DGIVerification({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime date,
    @HiveField(2) required bool isConforme,
    @HiveField(3) List<String>? nonConformites,
    @HiveField(4) required Map<String, dynamic> mesures,
    @HiveField(5) required String commentaires,
  }) = _DGIVerification;

  factory DGIVerification.fromJson(Map<String, dynamic> json) =>
      _$DGIVerificationFromJson(json);

  // Getters
  bool get conforme => isConforme;
  DateTime get dateVerification => date;
}
