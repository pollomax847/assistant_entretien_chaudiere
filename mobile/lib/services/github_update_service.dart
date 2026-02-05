import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:assistant_entreiten_chaudiere/utils/widgets/app_snackbar.dart';

/// Service de mise à jour via GitHub Releases
class GitHubUpdateService {
  static final GitHubUpdateService _instance = GitHubUpdateService._internal();
  factory GitHubUpdateService() => _instance;
  GitHubUpdateService._internal();

  // URL du fichier version.json sur GitHub (branche main)
  static const String _versionUrl = 
      'https://raw.githubusercontent.com/pollomax847/assistant_entretien_chaudiere/main/version.json';
  
  // Repo GitHub pour les releases
  static const String _repoOwner = 'pollomax847';
  static const String _repoName = 'assistant_entretien_chaudiere';

  /// Vérifier si une mise à jour est disponible
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      // Récupérer les infos de la version actuelle
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
      
      debugPrint('[UpdateCheck] Version actuelle: $currentVersion (build $currentBuildNumber)');
      debugPrint('[UpdateCheck] URL: $_versionUrl');

      // Télécharger le fichier version.json depuis GitHub
      final response = await http.get(Uri.parse(_versionUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout lors de la vérification des mises à jour');
        },
      );
      
      if (response.statusCode != 200) {
        debugPrint('[UpdateCheck] Erreur HTTP: ${response.statusCode}');
        debugPrint('[UpdateCheck] Body: ${response.body}');
        return null;
      }

      final data = json.decode(response.body);
      final latestVersion = data['version'] as String;
      final latestBuildNumber = int.tryParse(data['buildNumber'].toString()) ?? 0;
      final downloadUrl = data['downloadUrl'] as String;
      final releaseNotes = data['releaseNotes'] as String;
      final forceUpdate = data['forceUpdate'] as bool? ?? false;

      debugPrint('[UpdateCheck] Version sur GitHub: $latestVersion (build $latestBuildNumber)');
      debugPrint('[UpdateCheck] Comparaison: $latestBuildNumber > $currentBuildNumber = ${latestBuildNumber > currentBuildNumber}');

      // Comparer les versions
      if (latestBuildNumber > currentBuildNumber) {
        debugPrint('[UpdateCheck] ✅ Mise à jour disponible!');
        return UpdateInfo(
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          downloadUrl: downloadUrl,
          releaseNotes: releaseNotes,
          forceUpdate: forceUpdate,
        );
      }

      debugPrint('[UpdateCheck] Pas de mise à jour (version à jour)');
      return null; // Pas de mise à jour disponible
    } catch (e) {
      debugPrint('[UpdateCheck] ❌ Erreur: $e');
      return null;
    }
  }

  /// Afficher le dialogue de mise à jour
  Future<void> showUpdateDialog(BuildContext context, UpdateInfo updateInfo) async {
    if (!context.mounted) return;

    return showDialog(
      context: context,
      barrierDismissible: !updateInfo.forceUpdate,
      builder: (context) => WillPopScope(
        onWillPop: () async => !updateInfo.forceUpdate,
        child: AlertDialog(
          title: Row(
            children: [
              Icon(
                updateInfo.forceUpdate ? Icons.warning : Icons.system_update,
                color: updateInfo.forceUpdate ? Colors.orange : Colors.blue,
              ),
              const SizedBox(width: 12),
              Text(updateInfo.forceUpdate ? 'Mise à jour requise' : 'Mise à jour disponible'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Version actuelle : ${updateInfo.currentVersion}'),
                Text(
                  'Nouvelle version : ${updateInfo.latestVersion}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nouveautés :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(updateInfo.releaseNotes),
                if (updateInfo.forceUpdate) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cette mise à jour est obligatoire pour continuer à utiliser l\'application.',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (!updateInfo.forceUpdate)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Plus tard'),
              ),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Télécharger'),
              onPressed: () {
                Navigator.pop(context);
                downloadUpdate(context, updateInfo.downloadUrl);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Télécharger la mise à jour
  Future<void> downloadUpdate(BuildContext context, String downloadUrl) async {
    try {
      final uri = Uri.parse(downloadUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        
        if (!context.mounted) return;
        
        AppSnackBar.showInfo(
          context,
          'Téléchargement lancé. Une fois terminé, ouvrez le fichier APK pour installer la mise à jour.',
        );
      } else {
        throw 'Impossible d\'ouvrir le lien de téléchargement';
      }
    } catch (e) {
      debugPrint('Erreur téléchargement: $e');
      
      if (!context.mounted) return;
      
      AppSnackBar.showError(
        context,
        'Erreur lors du téléchargement: $e',
      );
    }
  }

  /// Vérification au démarrage
  Future<void> checkOnAppStart(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    
    final updateInfo = await checkForUpdate();
    if (updateInfo != null && context.mounted) {
      await showUpdateDialog(context, updateInfo);
    }
  }

  /// Vérification manuelle
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
      final updateInfo = await checkForUpdate();
      
      if (!context.mounted) return;
      Navigator.pop(context);

      if (updateInfo != null) {
        await showUpdateDialog(context, updateInfo);
      } else {
        AppSnackBar.showSuccess(
          context,
          '✓ Vous utilisez la dernière version disponible',
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      
      AppSnackBar.showError(
        context,
        'Erreur de connexion: Vérifiez votre connexion internet',
      );
    }
  }

  /// Obtenir les infos de version
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

/// Classe pour stocker les infos de mise à jour
class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;

  UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.forceUpdate,
  });
}
