// ChauffageExpert/lib/services/dgi_verification_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/dgi_verification.dart';
import 'hive_service.dart';

class DGIVerificationService {
  static final Box<DGIVerification> _box = HiveService.dgiVerifications;

  // Ajouter une vérification DGI
  static Future<void> addVerification(DGIVerification verification) async {
    await _box.put(verification.id, verification);
  }

  // Récupérer une vérification par son ID
  static DGIVerification? getVerification(String id) {
    return _box.get(id);
  }

  // Récupérer toutes les vérifications
  static List<DGIVerification> getAllVerifications() {
    return _box.values.toList();
  }

  // Récupérer les vérifications d'un équipement
  static List<DGIVerification> getVerificationsByEquipment(String equipmentId) {
    return _box.values
        .where((verification) => verification.equipmentId == equipmentId)
        .toList();
  }

  // Mettre à jour une vérification
  static Future<void> updateVerification(DGIVerification verification) async {
    await _box.put(verification.id, verification);
  }

  // Supprimer une vérification
  static Future<void> deleteVerification(String id) async {
    await _box.delete(id);
  }

  // Rechercher des vérifications par statut
  static List<DGIVerification> searchByStatus(String status) {
    return _box.values
        .where((verification) => verification.status == status)
        .toList();
  }

  // Rechercher des vérifications par date
  static List<DGIVerification> searchByDate(DateTime date) {
    return _box.values
        .where((verification) =>
            verification.date.year == date.year &&
            verification.date.month == date.month &&
            verification.date.day == date.day)
        .toList();
  }
}
