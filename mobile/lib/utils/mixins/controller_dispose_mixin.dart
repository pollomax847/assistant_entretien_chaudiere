import 'package:flutter/material.dart';

/// Mixin pour gérer automatiquement la disposition des TextEditingControllers
/// 
/// Ce mixin simplifie la gestion du cycle de vie des controllers en fournissant
/// des méthodes pour enregistrer et disposer automatiquement les controllers.
/// 
/// Exemple d'utilisation :
/// ```dart
/// class MyScreen extends StatefulWidget {
///   // ...
/// }
/// 
/// class _MyScreenState extends State<MyScreen> with ControllerDisposeMixin {
///   late final TextEditingController nameController;
///   late final TextEditingController emailController;
///   
///   @override
///   void initState() {
///     super.initState();
///     nameController = registerController(TextEditingController());
///     emailController = registerController(TextEditingController());
///   }
///   
///   @override
///   void dispose() {
///     disposeControllers(); // Dispose tous les controllers enregistrés
///     super.dispose();
///   }
/// }
/// ```
mixin ControllerDisposeMixin<T extends StatefulWidget> on State<T> {
  final List<TextEditingController> _registeredControllers = [];

  /// Enregistre un controller pour le disposer automatiquement
  /// 
  /// Retourne le controller pour pouvoir l'assigner directement :
  /// ```dart
  /// final controller = registerController(TextEditingController());
  /// ```
  TextEditingController registerController(TextEditingController controller) {
    _registeredControllers.add(controller);
    return controller;
  }

  /// Enregistre plusieurs controllers à la fois
  /// 
  /// Exemple :
  /// ```dart
  /// final controllers = registerControllers([
  ///   TextEditingController(),
  ///   TextEditingController(),
  ///   TextEditingController(),
  /// ]);
  /// ```
  List<TextEditingController> registerControllers(List<TextEditingController> controllers) {
    _registeredControllers.addAll(controllers);
    return controllers;
  }

  /// Enregistre une Map de controllers (utile pour les formulaires dynamiques)
  /// 
  /// Exemple :
  /// ```dart
  /// final controllers = registerControllerMap({
  ///   'name': TextEditingController(),
  ///   'email': TextEditingController(),
  ///   'phone': TextEditingController(),
  /// });
  /// ```
  Map<String, TextEditingController> registerControllerMap(
    Map<String, TextEditingController> controllers,
  ) {
    _registeredControllers.addAll(controllers.values);
    return controllers;
  }

  /// Dispose tous les controllers enregistrés
  /// 
  /// À appeler dans la méthode dispose() du widget :
  /// ```dart
  /// @override
  /// void dispose() {
  ///   disposeControllers();
  ///   super.dispose();
  /// }
  /// ```
  void disposeControllers() {
    for (final controller in _registeredControllers) {
      controller.dispose();
    }
    _registeredControllers.clear();
  }

  /// Retourne le nombre de controllers enregistrés
  int get controllersCount => _registeredControllers.length;

  /// Réinitialise tous les controllers (vide leur texte)
  void clearAllControllers() {
    for (final controller in _registeredControllers) {
      controller.clear();
    }
  }
}
