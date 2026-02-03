import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service pour gérer les mises à jour in-app
class UpdateService {
  static final UpdateService _instance = UpdateService._internal();
  factory UpdateService() => _instance;
  UpdateService._internal();

  /// Vérifier si une mise à jour est disponible
  Future<void> checkForUpdate(BuildContext context) async {
    try {
      // Vérifier la disponibilité d'une mise à jour via Google Play
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Une mise à jour est disponible
        await _showUpdateDialog(context, updateInfo);
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification de mise à jour: $e');
    }
  }

  /// Afficher une boîte de dialogue proposant la mise à jour
  Future<void> _showUpdateDialog(BuildContext context, AppUpdateInfo updateInfo) async {
    final packageInfo = await PackageInfo.fromPlatform();
    
    if (!context.mounted) return;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Colors.blue),
            SizedBox(width: 12),
            Text('Mise à jour disponible'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version actuelle : ${packageInfo.version}'),
            const SizedBox(height: 8),
            const Text('Une nouvelle version est disponible avec des améliorations et corrections.'),
            const SizedBox(height: 16),
            const Text(
              'Voulez-vous mettre à jour maintenant ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Plus tard'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Mettre à jour'),
            onPressed: () {
              Navigator.pop(context);
              _performUpdate(context, updateInfo);
            },
          ),
        ],
      ),
    );
  }

  /// Effectuer la mise à jour
  Future<void> _performUpdate(BuildContext context, AppUpdateInfo updateInfo) async {
    try {
      if (updateInfo.immediateUpdateAllowed) {
        // Mise à jour immédiate (l'app redémarre après)
        await InAppUpdate.performImmediateUpdate();
      } else if (updateInfo.flexibleUpdateAllowed) {
        // Mise à jour flexible (téléchargement en arrière-plan)
        await _performFlexibleUpdate(context);
      }
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour: $e');
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la mise à jour. Réessayez plus tard.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Mise à jour flexible avec progression
  Future<void> _performFlexibleUpdate(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      
      // Écouter la progression du téléchargement
      InAppUpdate.completeFlexibleUpdate().then((_) {
        if (!context.mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Mise à jour installée ! Redémarrage...'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Redémarrer',
              textColor: Colors.white,
              onPressed: () {
                // L'app va redémarrer automatiquement
              },
            ),
          ),
        );
      });
    } catch (e) {
      debugPrint('Erreur mise à jour flexible: $e');
    }
  }

  /// Vérification au démarrage de l'app
  Future<void> checkOnAppStart(BuildContext context) async {
    // Attendre un peu avant de vérifier (pour ne pas bloquer le démarrage)
    await Future.delayed(const Duration(seconds: 3));
    await checkForUpdate(context);
  }

  /// Forcer une vérification manuelle (depuis les paramètres par exemple)
  Future<void> checkManually(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Vérification des mises à jour...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      
      if (!context.mounted) return;
      Navigator.pop(context); // Fermer le dialogue de chargement

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await _showUpdateDialog(context, updateInfo);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Vous avez la dernière version'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de vérifier les mises à jour'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  /// Obtenir les informations de version actuelles
  Future<Map<String, String>> getVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return {
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
    };
  }
}
