import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chauffageexpert/utils/mixins/shared_preferences_mixin.dart';

/// Mixin pour la gestion de données complexes stockées en JSON
/// 
/// Permet de sauvegarder/charger des listes et des maps facilement
/// avec conversion automatique JSON
mixin JsonStorageMixin<T extends StatefulWidget> on State<T>, SharedPreferencesMixin {
  
  /// Sauvegarde une liste de maps en JSON
  Future<void> saveListAsJson(String key, List<Map<String, dynamic>> data) async {
    final jsonString = json.encode(data);
    await saveString(key, jsonString);
  }
  
  /// Charge une liste de maps depuis JSON
  Future<List<Map<String, dynamic>>> loadListFromJson(String key, {List<Map<String, dynamic>>? defaultValue}) async {
    final jsonString = await loadString(key);
    if (jsonString == null) {
      return defaultValue ?? [];
    }
    
    try {
      final decoded = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      debugPrint('Erreur lors du décodage JSON: $e');
      return defaultValue ?? [];
    }
  }
  
  /// Sauvegarde une map en JSON
  Future<void> saveMapAsJson(String key, Map<String, dynamic> data) async {
    final jsonString = json.encode(data);
    await saveString(key, jsonString);
  }
  
  /// Charge une map depuis JSON
  Future<Map<String, dynamic>?> loadMapFromJson(String key) async {
    final jsonString = await loadString(key);
    if (jsonString == null) {
      return null;
    }
    
    try {
      return Map<String, dynamic>.from(json.decode(jsonString));
    } catch (e) {
      debugPrint('Erreur lors du décodage JSON: $e');
      return null;
    }
  }
  
  /// Sauvegarde un objet sérialisable en JSON
  Future<void> saveObjectAsJson<O>(String key, O object) async {
    final jsonString = json.encode(object);
    await saveString(key, jsonString);
  }
  
  /// Charge et décode un objet JSON
  Future<O?> loadObjectFromJson<O>(
    String key,
    O Function(Map<String, dynamic>) fromJson,
  ) async {
    final jsonString = await loadString(key);
    if (jsonString == null) {
      return null;
    }
    
    try {
      final decoded = json.decode(jsonString);
      return fromJson(decoded);
    } catch (e) {
      debugPrint('Erreur lors du décodage de l\'objet JSON: $e');
      return null;
    }
  }
  
  /// Sauvegarde une liste d'objets sérialisables en JSON
  Future<void> saveObjectListAsJson<O>(String key, List<O> objects) async {
    final jsonString = json.encode(objects);
    await saveString(key, jsonString);
  }
  
  /// Charge une liste d'objets depuis JSON
  Future<List<O>> loadObjectListFromJson<O>(
    String key,
    O Function(dynamic) fromJson, {
    List<O>? defaultValue,
  }) async {
    final jsonString = await loadString(key);
    if (jsonString == null) {
      return defaultValue ?? [];
    }
    
    try {
      final decoded = json.decode(jsonString);
      final list = List.from(decoded);
      return list.map((item) => fromJson(item)).toList();
    } catch (e) {
      debugPrint('Erreur lors du décodage de la liste JSON: $e');
      return defaultValue ?? [];
    }
  }
  
  /// Ajoute un élément à une liste JSON existante
  Future<void> appendToJsonList(String key, Map<String, dynamic> newItem) async {
    final currentList = await loadListFromJson(key);
    currentList.add(newItem);
    await saveListAsJson(key, currentList);
  }
  
  /// Retire un élément d'une liste JSON par index
  Future<bool> removeFromJsonListAt(String key, int index) async {
    final currentList = await loadListFromJson(key);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      await saveListAsJson(key, currentList);
      return true;
    }
    return false;
  }
  
  /// Met à jour un élément dans une liste JSON
  Future<bool> updateJsonListAt(String key, int index, Map<String, dynamic> updatedItem) async {
    final currentList = await loadListFromJson(key);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = updatedItem;
      await saveListAsJson(key, currentList);
      return true;
    }
    return false;
  }
  
  /// Filtre les éléments d'une liste JSON
  Future<List<Map<String, dynamic>>> filterJsonList(
    String key,
    bool Function(Map<String, dynamic>) predicate,
  ) async {
    final currentList = await loadListFromJson(key);
    return currentList.where(predicate).toList();
  }
  
  /// Trouve un élément dans une liste JSON
  Future<Map<String, dynamic>?> findInJsonList(
    String key,
    bool Function(Map<String, dynamic>) predicate,
  ) async {
    final currentList = await loadListFromJson(key);
    try {
      return currentList.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }
}
