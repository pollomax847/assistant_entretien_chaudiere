import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mixins/theme_state_mixin.dart';

/// Provider pour la gestion des préférences utilisateur de l'application
class PreferencesProvider with ChangeNotifier, ThemeStateMixin {
  static const String _themeKey = 'isDarkMode';
  
  String _technician = '';
  String _company = '';
  String _defaultModule = 'home';

  // Getters
  String get technician => _technician;
  String get company => _company;
  String get defaultModule => _defaultModule;

  // Charger les préférences
  Future<void> loadPreferences() async {
    await loadTheme(_themeKey);
    final prefs = await SharedPreferences.getInstance();
    _technician = prefs.getString('technician') ?? '';
    _company = prefs.getString('company') ?? '';
    _defaultModule = prefs.getString('defaultModule') ?? 'home';
  }

  // Sauvegarder le mode sombre
  Future<void> setDarkMode(bool value) async {
    await saveTheme(_themeKey, value);
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
}