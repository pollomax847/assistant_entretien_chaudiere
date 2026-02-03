import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _technician = '';
  String _company = '';
  String _defaultModule = 'home';
  bool _isFirstLaunch = true;
  List<String> _favoriteModules = [];

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get technician => _technician;
  String get company => _company;
  String get defaultModule => _defaultModule;
  bool get isFirstLaunch => _isFirstLaunch;
  List<String> get favoriteModules => _favoriteModules;

  // Charger les préférences
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _technician = prefs.getString('technician') ?? '';
    _company = prefs.getString('company') ?? '';
    _defaultModule = prefs.getString('defaultModule') ?? 'home';
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    _favoriteModules = prefs.getStringList('favoriteModules') ?? [];
    notifyListeners();
  }

  // Sauvegarder le mode sombre
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  // Sauvegarder le technicien
  Future<void> setTechnician(String value) async {
    _technician = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('technician', value);
    notifyListeners();
  }

  // Sauvegarder l'entreprise
  Future<void> setCompany(String value) async {
    _company = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company', value);
    notifyListeners();
  }

  // Sauvegarder le module par défaut
  Future<void> setDefaultModule(String value) async {
    _defaultModule = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultModule', value);
    notifyListeners();
  }

  // Marquer que ce n'est plus le premier lancement
  Future<void> setFirstLaunchCompleted() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    notifyListeners();
  }

  // Ajouter un module aux favoris
  Future<void> addFavorite(String moduleId) async {
    if (!_favoriteModules.contains(moduleId)) {
      _favoriteModules.add(moduleId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favoriteModules', _favoriteModules);
      notifyListeners();
    }
  }

  // Retirer un module des favoris
  Future<void> removeFavorite(String moduleId) async {
    _favoriteModules.remove(moduleId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteModules', _favoriteModules);
    notifyListeners();
  }

  // Basculer un module dans les favoris
  Future<void> toggleFavorite(String moduleId) async {
    if (_favoriteModules.contains(moduleId)) {
      await removeFavorite(moduleId);
    } else {
      await addFavorite(moduleId);
    }
  }

  // Vérifier si un module est favori
  bool isFavorite(String moduleId) {
    return _favoriteModules.contains(moduleId);
  }
}
