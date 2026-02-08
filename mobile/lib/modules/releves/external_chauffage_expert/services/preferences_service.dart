// services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  static SharedPreferences? _prefs;

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Gestion des pièces
  Future<void> savePieces(List<Map<String, dynamic>> pieces) async {
    if (_prefs == null) await init();
    await _prefs!.setString('pieces', jsonEncode(pieces));
  }

  Future<List<Map<String, dynamic>>> getPieces() async {
    if (_prefs == null) await init();
    final piecesJson = _prefs!.getString('pieces');
    if (piecesJson == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(piecesJson));
  }

  // Gestion des types de pièces
  Future<void> saveTypesPieces(
      Map<String, Map<String, double>> typesPieces) async {
    if (_prefs == null) await init();
    await _prefs!.setString('typesPieces', jsonEncode(typesPieces));
  }

  Future<Map<String, Map<String, double>>> getTypesPieces() async {
    if (_prefs == null) await init();
    final typesJson = _prefs!.getString('typesPieces');
    if (typesJson == null) return {};
    return Map<String, Map<String, double>>.from(jsonDecode(typesJson));
  }

  // Gestion des volumes
  Future<void> saveVolumeValues({
    required double volumeFonte,
    required double volumeAcier,
    required double volumeAluminium,
    required double volumePanneau,
    required double volumeChaudiere,
  }) async {
    if (_prefs == null) await init();
    await _prefs!.setString('volumeFonte', volumeFonte.toString());
    await _prefs!.setString('volumeAcier', volumeAcier.toString());
    await _prefs!.setString('volumeAluminium', volumeAluminium.toString());
    await _prefs!.setString('volumePanneau', volumePanneau.toString());
    await _prefs!.setString('volumeChaudiere', volumeChaudiere.toString());
  }

  Future<Map<String, double>> getVolumeValues() async {
    if (_prefs == null) await init();
    return {
      'fonte':
          double.tryParse(_prefs!.getString('volumeFonte') ?? '0.0') ?? 0.0,
      'acier':
          double.tryParse(_prefs!.getString('volumeAcier') ?? '0.0') ?? 0.0,
      'aluminium':
          double.tryParse(_prefs!.getString('volumeAluminium') ?? '0.0') ?? 0.0,
      'panneau':
          double.tryParse(_prefs!.getString('volumePanneau') ?? '0.0') ?? 0.0,
      'chaudiere':
          double.tryParse(_prefs!.getString('volumeChaudiere') ?? '0.0') ?? 0.0,
    };
  }

  // Gestion des recherches récentes
  Future<void> saveRecentSearches(List<String> searches) async {
    if (_prefs == null) await init();
    await _prefs!.setStringList('recentSearches', searches);
  }

  Future<List<String>> getRecentSearches() async {
    if (_prefs == null) await init();
    return _prefs!.getStringList('recentSearches') ?? [];
  }

  // Gestion du mode sombre
  Future<void> setDarkMode(bool isDark) async {
    if (_prefs == null) await init();
    await _prefs!.setBool('isDarkMode', isDark);
  }

  Future<bool> isDarkMode() async {
    if (_prefs == null) await init();
    return _prefs!.getBool('isDarkMode') ?? false;
  }

  // Méthodes génériques pour les préférences avec typage strict
  Future<String> getString(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getString(key) ?? '';
  }

  Future<void> setString(String key, String value) async {
    if (_prefs == null) await init();
    await _prefs!.setString(key, value);
  }

  Future<bool> getBool(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getBool(key) ?? false;
  }

  Future<void> setBool(String key, bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(key, value);
  }

  Future<double> getDouble(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getDouble(key) ?? 0.0;
  }

  Future<void> setDouble(String key, double value) async {
    if (_prefs == null) await init();
    await _prefs!.setDouble(key, value);
  }

  Future<int> getInt(String key) async {
    if (_prefs == null) await init();
    return _prefs!.getInt(key) ?? 0;
  }

  Future<void> setInt(String key, int value) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(key, value);
  }
}
