import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _technician = '';
  String _company = '';
  String _defaultModule = 'home';

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get technician => _technician;
  String get company => _company;
  String get defaultModule => _defaultModule;

  // Charger les préférences
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _technician = prefs.getString('technician') ?? '';
    _company = prefs.getString('company') ?? '';
    _defaultModule = prefs.getString('defaultModule') ?? 'home';
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
}