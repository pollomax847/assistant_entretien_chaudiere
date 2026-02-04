import 'package:flutter/material.dart';
import '../widgets/app_snackbar.dart';

/// Mixin pour simplifier l'affichage des SnackBars dans les écrans
/// 
/// Ce mixin fournit des méthodes pratiques pour afficher des notifications
/// sans avoir à utiliser directement ScaffoldMessenger ou AppSnackBar.
/// 
/// Exemple d'utilisation :
/// ```dart
/// class MyScreen extends StatefulWidget {
///   // ...
/// }
/// 
/// class _MyScreenState extends State<MyScreen> with SnackBarMixin {
///   void saveData() async {
///     try {
///       // Logique de sauvegarde...
///       showSuccess('Données sauvegardées avec succès');
///     } catch (e) {
///       showError('Erreur lors de la sauvegarde: $e');
///     }
///   }
/// }
/// ```
mixin SnackBarMixin<T extends StatefulWidget> on State<T> {
  /// Affiche un message de succès (vert)
  void showSuccess(String message, {Duration? duration}) {
    AppSnackBar.showSuccess(context, message, duration: duration);
  }

  /// Affiche un message d'erreur (rouge)
  void showError(String message, {Duration? duration}) {
    AppSnackBar.showError(context, message, duration: duration);
  }

  /// Affiche un message d'information (bleu)
  void showInfo(String message, {Duration? duration}) {
    AppSnackBar.showInfo(context, message, duration: duration);
  }

  /// Affiche un message d'avertissement (orange)
  void showWarning(String message, {Duration? duration}) {
    AppSnackBar.showWarning(context, message, duration: duration);
  }

  /// Affiche un message "Copié !" pour les opérations de copie
  void showCopied({String message = 'Copié !'}) {
    AppSnackBar.showCopied(context, message: message);
  }

  /// Affiche un SnackBar personnalisé
  void showMessage(
    String message, {
    Color? backgroundColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    AppSnackBar.show(
      context,
      message,
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    );
  }
}
