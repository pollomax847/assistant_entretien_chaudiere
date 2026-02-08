import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'releve_technique_mapper.dart';
import 'models/releve_technique.dart';

/// Couche d'adaptation pour travailler avec les deux formats de relevé :
/// - format "plat" (legacy / ChauffageExpert)
/// - modèle structuré `ReleveTechnique` utilisé dans ce module
///
/// Fournit méthodes de conversion + sauvegarde/chargement simple via
/// `SharedPreferences` pour faciliter l'intégration progressive.
class ReleveTechniqueAdapter {
  ReleveTechniqueAdapter._internal();
  static final ReleveTechniqueAdapter instance = ReleveTechniqueAdapter._internal();

  /// Sauvegarde un relevé structuré sous la clé fournie (JSON plat stocké)
  Future<void> saveStructured(String key, ReleveTechnique rt) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> flat = mapStructuredToFlat(rt);
    await prefs.setString(key, json.encode(flat));
  }

  /// Charge un relevé depuis la clé. Retourne `null` si absent.
  Future<ReleveTechnique?> loadStructured(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(key);
    if (s == null) return null;
    final Map<String, dynamic> flat = json.decode(s) as Map<String, dynamic>;
    return mapFlatToStructured(flat);
  }

  /// Sauvegarde directement un JSON plat (legacy) sous la clé fournie.
  Future<void> saveLegacy(String key, Map<String, dynamic> flatJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(flatJson));
  }

  /// Charge un JSON plat et le convertit en `ReleveTechnique`.
  Future<ReleveTechnique> importLegacy(Map<String, dynamic> flatJson) async {
    return mapFlatToStructured(flatJson);
  }

  /// Exporte le relevé structuré vers une Map plate (legacy-compatible).
  Map<String, dynamic> exportLegacy(ReleveTechnique rt) => mapStructuredToFlat(rt);

  /// Supprime la clé stockée
  Future<void> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
