import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mixin pour gérer l'état du thème avec persistence
/// 
/// Ce mixin fournit une gestion complète du thème (dark/light mode)
/// avec sauvegarde automatique dans SharedPreferences.
/// 
/// Exemple d'utilisation :
/// ```dart
/// class MyProvider with ChangeNotifier, ThemeStateMixin {
///   MyProvider() {
///     loadTheme('my_theme_key');
///   }
/// }
/// ```
mixin ThemeStateMixin on ChangeNotifier {
  bool _isDarkMode = false;
  
  /// Retourne true si le mode sombre est activé
  bool get isDarkMode => _isDarkMode;
  
  /// Charge le thème depuis SharedPreferences
  /// 
  /// [preferenceKey] : clé utilisée pour stocker le thème dans SharedPreferences
  /// Notifie automatiquement les listeners après le chargement
  Future<void> loadTheme(String preferenceKey) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(preferenceKey) ?? false;
    notifyListeners();
  }
  
  /// Sauvegarde le thème dans SharedPreferences
  /// 
  /// [preferenceKey] : clé utilisée pour stocker le thème
  /// [value] : true pour mode sombre, false pour mode clair
  /// Notifie automatiquement les listeners après la sauvegarde
  Future<void> saveTheme(String preferenceKey, bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(preferenceKey, value);
    notifyListeners();
  }
  
  /// Inverse le thème actuel (dark ↔ light)
  /// 
  /// [preferenceKey] : clé utilisée pour stocker le thème
  /// Notifie automatiquement les listeners après le changement
  Future<void> toggleTheme(String preferenceKey) async {
    await saveTheme(preferenceKey, !_isDarkMode);
  }
}
