import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/releve_technique.dart';

/// Service de stockage pour ReleveTechnique
/// Gère la sauvegarde et chargement JSON
class RelevelStorageService {
  static const String _releveKey = 'releve_technique_actuel';
  static const String _relevelistKey = 'releve_technique_list';

  /// Sauvegarde un relevé en JSON
  static Future<bool> saveReleve(ReleveTechnique releve) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(releve.toJson());
      return await prefs.setString(_releveKey, json);
    } catch (e) {
      debugPrint('Erreur sauvegarde relevé: $e');
      return false;
    }
  }

  /// Charge le relevé actuel depuis JSON
  static Future<ReleveTechnique?> loadReleve() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_releveKey);
      if (jsonStr == null) return null;
      
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ReleveTechnique.fromJson(json);
    } catch (e) {
      debugPrint('Erreur chargement relevé: $e');
      return null;
    }
  }

  /// Sauvegarde une liste de relevés (historique)
  static Future<bool> saveReleveList(List<ReleveTechnique> releves) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = releves.map((r) => r.toJson()).toList();
      return await prefs.setString(_relevelistKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Erreur sauvegarde liste: $e');
      return false;
    }
  }

  /// Charge la liste des relevés
  static Future<List<ReleveTechnique>> loadReleveList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_relevelistKey);
      if (jsonStr == null) return [];
      
      final jsonList = jsonDecode(jsonStr) as List<dynamic>;
      return jsonList
          .map((json) => ReleveTechnique.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Erreur chargement liste: $e');
      return [];
    }
  }

  /// Supprime le relevé actuel
  static Future<bool> deleteReleve() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_releveKey);
    } catch (e) {
      debugPrint('Erreur suppression: $e');
      return false;
    }
  }

  /// Supprime toute l'historique
  static Future<bool> deleteHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_relevelistKey);
    } catch (e) {
      debugPrint('Erreur suppression historique: $e');
      return false;
    }
  }

  /// Exporte un relevé en chaîne JSON formatée
  static String exportToJson(ReleveTechnique releve) {
    return jsonEncode(releve.toJson());
  }

  /// Importe un relevé depuis une chaîne JSON
  static ReleveTechnique? importFromJson(String jsonStr) {
    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ReleveTechnique.fromJson(json);
    } catch (e) {
      debugPrint('Erreur import JSON: $e');
      return null;
    }
  }
}
