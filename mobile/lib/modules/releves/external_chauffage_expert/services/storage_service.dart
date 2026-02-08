// services/storage_service.dart (externe)
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Clés pour SharedPreferences
  static const String _lastSyncKey = 'last_sync';
  static const String _settingsKey = 'app_settings';
  static const String _relevesKey = 'releves';

  // Gestion des préférences utilisateur
  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      return json.decode(settingsJson);
    }
    return {};
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, json.encode(settings));
  }

  // Gestion de la dernière synchronisation
  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(_lastSyncKey);
    if (lastSyncStr != null) {
      return DateTime.parse(lastSyncStr);
    }
    return null;
  }

  Future<void> updateLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Gestion des relevés en local
  Future<List<Map<String, dynamic>>> getLocalReleves() async {
    final prefs = await SharedPreferences.getInstance();
    final relevesJson = prefs.getString(_relevesKey);
    if (relevesJson != null) {
      return List<Map<String, dynamic>>.from(json.decode(relevesJson));
    }
    return [];
  }

  Future<void> saveLocalReleves(List<Map<String, dynamic>> releves) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_relevesKey, json.encode(releves));
  }

  // Gestion des fichiers
  Future<String> getAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return path;
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<String>> listFiles(String directory) async {
    final dir = Directory(directory);
    if (await dir.exists()) {
      return dir.listSync().map((entity) => entity.path).toList();
    }
    return [];
  }

  // Nettoyage du cache
  Future<void> clearCache() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/cache');
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }
}
