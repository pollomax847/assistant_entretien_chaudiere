import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mixin pour simplifier la gestion des formulaires avec SharedPreferences
/// 
/// Ce mixin combine la gestion des controllers et la persistence des données
/// pour créer des formulaires complets avec sauvegarde automatique.
/// 
/// Exemple d'utilisation :
/// ```dart
/// class MyFormScreen extends StatefulWidget {
///   // ...
/// }
/// 
/// class _MyFormScreenState extends State<MyFormScreen> with FormStateMixin {
///   late final nameController = registerFormField('user_name');
///   late final emailController = registerFormField('user_email');
///   
///   @override
///   void initState() {
///     super.initState();
///     loadFormData(); // Charge automatiquement toutes les données
///   }
///   
///   Future<void> saveData() async {
///     await saveFormData(); // Sauvegarde automatiquement toutes les données
///   }
/// }
/// ```
mixin FormStateMixin<T extends StatefulWidget> on State<T> {
  final Map<String, TextEditingController> _formControllers = {};
  final Map<String, String> _formKeys = {};

  /// Enregistre un champ de formulaire avec sa clé de sauvegarde
  /// 
  /// Le controller sera automatiquement chargé et sauvegardé via SharedPreferences
  TextEditingController registerFormField(
    String preferenceKey, {
    String? initialValue,
  }) {
    final controller = TextEditingController(text: initialValue ?? '');
    _formControllers[preferenceKey] = controller;
    _formKeys[preferenceKey] = preferenceKey;
    return controller;
  }

  /// Charge toutes les données du formulaire depuis SharedPreferences
  Future<void> loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _formControllers.entries) {
      final key = entry.key;
      final controller = entry.value;
      final savedValue = prefs.getString(key);
      if (savedValue != null) {
        controller.text = savedValue;
      }
    }
    if (mounted) setState(() {});
  }

  /// Sauvegarde toutes les données du formulaire dans SharedPreferences
  Future<void> saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _formControllers.entries) {
      final key = entry.key;
      final controller = entry.value;
      await prefs.setString(key, controller.text);
    }
  }

  /// Charge une valeur spécifique depuis SharedPreferences
  Future<String?> loadFormValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Sauvegarde une valeur spécifique dans SharedPreferences
  Future<void> saveFormValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Réinitialise tous les champs du formulaire
  void clearFormData() {
    for (final controller in _formControllers.values) {
      controller.clear();
    }
    if (mounted) setState(() {});
  }

  /// Dispose tous les controllers du formulaire
  void disposeFormControllers() {
    for (final controller in _formControllers.values) {
      controller.dispose();
    }
    _formControllers.clear();
  }

  /// Valide que tous les champs obligatoires sont remplis
  bool validateRequiredFields(List<String> requiredKeys, {String? errorMessage}) {
    for (final key in requiredKeys) {
      final controller = _formControllers[key];
      if (controller == null || controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  /// Retourne un controller par sa clé
  TextEditingController? getController(String key) {
    return _formControllers[key];
  }

  /// Retourne la valeur d'un champ par sa clé
  String? getFieldValue(String key) {
    return _formControllers[key]?.text;
  }

  /// Définit la valeur d'un champ par sa clé
  void setFieldValue(String key, String value) {
    final controller = _formControllers[key];
    if (controller != null) {
      controller.text = value;
    }
  }

  /// Retourne le nombre de champs enregistrés
  int get formFieldsCount => _formControllers.length;
}
