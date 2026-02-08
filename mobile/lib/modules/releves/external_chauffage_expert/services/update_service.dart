// services/update_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateService {
  static const String LAST_UPDATE_CHECK_KEY = 'last_update_check';
  static const String LATEST_VERSION_KEY = 'latest_version';
  static const Duration CHECK_INTERVAL = Duration(days: 1);

  static Future<bool> checkForUpdates() async {
    try {
      // Vérifier si nous avons déjà vérifié aujourd'hui
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(LAST_UPDATE_CHECK_KEY) ?? 0;
      if (DateTime.now().millisecondsSinceEpoch - lastCheck <
          CHECK_INTERVAL.inMilliseconds) {
        return false;
      }

      // Obtenir la version actuelle
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Vérifier la dernière version sur GitHub
      final response = await http.get(
        Uri.parse(
            'https://api.github.com/repos/pollomax847/memo_chaudiere/releases/latest'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');

        // Sauvegarder la dernière vérification
        await prefs.setInt(
            LAST_UPDATE_CHECK_KEY, DateTime.now().millisecondsSinceEpoch);
        await prefs.setString(LATEST_VERSION_KEY, latestVersion);

        // Comparer les versions
        return _compareVersions(currentVersion, latestVersion) < 0;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la vérification des mises à jour : $e');
      return false;
    }
  }

  static int _compareVersions(String v1, String v2) {
    List<int> v1Parts = v1.split('.').map(int.parse).toList();
    List<int> v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  static Future<void> downloadUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final latestVersion = prefs.getString(LATEST_VERSION_KEY);

      if (latestVersion != null) {
        final url = Uri.parse(
            'https://github.com/pollomax847/memo_chaudiere/releases/download/v$latestVersion/app-release.apk');
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Erreur lors du téléchargement de la mise à jour : $e');
    }
  }
}
