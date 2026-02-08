// ChauffageExpert/lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/equipment.dart';
import '../models/dgi_verification.dart';
import '../models/dimensionnement.dart';
import '../models/chaudiere.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Enregistrement des adaptateurs
    Hive.registerAdapter(EquipmentAdapter());
    Hive.registerAdapter(DGIVerificationAdapter());
    Hive.registerAdapter(DimensionnementAdapter());
    Hive.registerAdapter(ChaudiereAdapter());

    // Ouverture des boîtes
    await Hive.openBox<Equipment>('equipments');
    await Hive.openBox<DGIVerification>('dgi_verifications');
    await Hive.openBox<Dimensionnement>('dimensionnements');
    await Hive.openBox<Chaudiere>('chaudieres');
  }

  // Getters pour les boîtes
  static Box<Equipment> get equipments => Hive.box<Equipment>('equipments');
  static Box<DGIVerification> get dgiVerifications =>
      Hive.box<DGIVerification>('dgi_verifications');
  static Box<Dimensionnement> get dimensionnements =>
      Hive.box<Dimensionnement>('dimensionnements');
  static Box<Chaudiere> get chaudieres => Hive.box<Chaudiere>('chaudieres');
}
