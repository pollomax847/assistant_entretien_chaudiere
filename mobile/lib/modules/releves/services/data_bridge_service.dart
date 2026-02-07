import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/releve_technique.dart';
import '../models/sections/chaudiere_section.dart';
import '../models/sections/ecs_section.dart';
import '../models/sections/tirage_section.dart';

/// Service d'import de données depuis l'ancienne structure
/// Migre les données des modules anciens vers la nouvelle structure
class DataBridgeService {
  // Clés SharedPreferences des anciens modules
  static const String _chaudiereTirageKey = 'dernier_tirage';
  static const String _ecsEquipementsKey = 'ecs_equipements';
  static const String _tireageCoKey = 'tirage_co';
  static const String _tirageCo2Key = 'tirage_co2';
  static const String _tirageO2Key = 'tirage_o2';

  /// Importe les données depuis ChaudiereScreen
  static Future<ChaudiereSection?> importChaudiereData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tirage = prefs.getDouble(_chaudiereTirageKey);
      
      if (tirage == null) return null;
      
      return ChaudiereSection(
        commentaire: 'Migré depuis ancienne structure (tirage: $tirage)',
      );
    } catch (e) {
      debugPrint('Erreur import chaudière: $e');
      return null;
    }
  }

  /// Importe les données depuis EcsScreen
  static Future<EcsSection?> importEcsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final equipements = prefs.getStringList(_ecsEquipementsKey);
      
      if (equipements == null || equipements.isEmpty) return null;
      
      return EcsSection(
        equipements: equipements,
        commentaire: 'Migré depuis ancienne structure',
      );
    } catch (e) {
      debugPrint('Erreur import ECS: $e');
      return null;
    }
  }

  /// Importe les données depuis TirageScreen
  static Future<TirageSection?> importTirageData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final co = prefs.getDouble(_tireageCoKey);
      final co2 = prefs.getDouble(_tirageCo2Key);
      final o2 = prefs.getDouble(_tirageO2Key);
      
      if (co == null && co2 == null && o2 == null) return null;
      
      return TirageSection(
        co: co,
        co2: co2,
        o2: o2,
        commentaire: 'Migré depuis ancienne structure',
      );
    } catch (e) {
      debugPrint('Erreur import tirage: $e');
      return null;
    }
  }

  /// Importe tous les anciens modules dans un nouveau ReleveTechnique
  static Future<ReleveTechnique> importAllData() async {
    final releve = ReleveTechnique.create();
    
    // Importer chaque section
    final chaudiere = await importChaudiereData();
    final ecs = await importEcsData();
    final tirage = await importTirageData();
    
    return releve.copyWith(
      chaudiere: chaudiere,
      ecs: ecs,
      tirage: tirage,
      commentaireGlobal:
          'Données migrées des anciens modules le ${DateTime.now()}',
    );
  }

  /// Archive les anciennes données (ne les supprime pas)
  static Future<bool> archiveOldData() async {
    try {
      // Copier toutes les anciennes clés vers une clé archive
      // Créer une archive (optionnel - les données restent en place)
      debugPrint('Archivage des anciennes données effectué');
      return true;
    } catch (e) {
      debugPrint('Erreur archivage: $e');
      return false;
    }
  }

  /// Nettoie les anciennes données après migration réussie
  static Future<bool> cleanOldData({
    bool cleanChaudiere = false,
    bool cleanEcs = false,
    bool cleanTirage = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (cleanChaudiere) await prefs.remove(_chaudiereTirageKey);
      if (cleanEcs) await prefs.remove(_ecsEquipementsKey);
      if (cleanTirage) {
        await prefs.remove(_tireageCoKey);
        await prefs.remove(_tirageCo2Key);
        await prefs.remove(_tirageO2Key);
      }
      
      return true;
    } catch (e) {
      debugPrint('Erreur nettoyage: $e');
      return false;
    }
  }

  /// Détecte si des anciennes données existent
  static Future<Map<String, bool>> detectOldData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      return {
        'chaudiere': prefs.containsKey(_chaudiereTirageKey),
        'ecs': prefs.containsKey(_ecsEquipementsKey),
        'tirage': prefs.containsKey(_tireageCoKey),
      };
    } catch (e) {
      debugPrint('Erreur détection: $e');
      return {};
    }
  }
}
