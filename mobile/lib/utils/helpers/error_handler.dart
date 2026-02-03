import 'package:flutter/material.dart';
import 'package:chauffageexpert/utils/widgets/app_snackbar.dart';

/// Classe pour gérer les erreurs de manière centralisée
class ErrorHandler {
  /// Gère une erreur et l'affiche à l'utilisateur
  static void handle(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    bool showSnackBar = true,
    VoidCallback? onRetry,
  }) {
    final message = customMessage ?? _getErrorMessage(error);
    
    if (showSnackBar) {
      AppSnackBar.showError(context, message);
    }
    
    // Log l'erreur (à remplacer par un système de logging professionnel)
    debugPrint('❌ ERROR: $error');
    debugPrint('Stack trace: ${StackTrace.current}');
  }
  
  /// Retourne un message d'erreur convivial selon le type d'erreur
  static String _getErrorMessage(dynamic error) {
    if (error == null) return 'Une erreur est survenue';
    
    final errorString = error.toString().toLowerCase();
    
    // Erreurs réseau
    if (errorString.contains('socket') || 
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Erreur de connexion. Vérifiez votre connexion internet.';
    }
    
    // Erreurs de timeout
    if (errorString.contains('timeout')) {
      return 'La requête a expiré. Veuillez réessayer.';
    }
    
    // Erreurs de fichier
    if (errorString.contains('file') || 
        errorString.contains('path') ||
        errorString.contains('directory')) {
      return 'Erreur d\'accès au fichier.';
    }
    
    // Erreurs de permission
    if (errorString.contains('permission') || 
        errorString.contains('denied')) {
      return 'Permission refusée.';
    }
    
    // Erreurs de format
    if (errorString.contains('format') || 
        errorString.contains('parse')) {
      return 'Format de données invalide.';
    }
    
    // Par défaut
    return 'Une erreur est survenue: ${error.toString()}';
  }
  
  /// Wrapper pour exécuter du code avec gestion d'erreur
  static Future<T?> tryAsync<T>(
    BuildContext context,
    Future<T> Function() action, {
    String? errorMessage,
    bool showError = true,
    T? defaultValue,
  }) async {
    try {
      return await action();
    } catch (e) {
      if (showError) {
        handle(context, e, customMessage: errorMessage);
      }
      return defaultValue;
    }
  }
  
  /// Wrapper pour exécuter du code synchrone avec gestion d'erreur
  static T? trySync<T>(
    BuildContext context,
    T Function() action, {
    String? errorMessage,
    bool showError = true,
    T? defaultValue,
  }) {
    try {
      return action();
    } catch (e) {
      if (showError) {
        handle(context, e, customMessage: errorMessage);
      }
      return defaultValue;
    }
  }
  
  /// Affiche une boîte de dialogue d'erreur
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              child: const Text('Réessayer'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Widget pour gérer les états de chargement et d'erreur
class AsyncWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final VoidCallback? onRetry;
  
  const AsyncWidget({
    super.key,
    required this.future,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder?.call(context) ?? 
            const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return errorBuilder?.call(context, snapshot.error!) ??
            _DefaultErrorWidget(
              error: snapshot.error!,
              onRetry: onRetry,
            );
        }
        
        if (!snapshot.hasData) {
          return const Center(
            child: Text('Aucune donnée'),
          );
        }
        
        return builder(context, snapshot.data as T);
      },
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  
  const _DefaultErrorWidget({
    required this.error,
    this.onRetry,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Une erreur est survenue',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              ErrorHandler._getErrorMessage(error),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
