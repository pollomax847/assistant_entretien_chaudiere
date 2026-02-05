import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Mixin pour gérer les photos associées aux mesures et non-conformités
mixin MeasurementPhotoStorageMixin {
  /// Sauvegarder les chemins des photos pour une mesure
  Future<void> saveMeasurementPhotos(String measurementId, List<File> photos) async {
    final prefs = await SharedPreferences.getInstance();
    final paths = photos.map((f) => f.path).toList();
    await prefs.setString(
      'measurement_photos_$measurementId',
      jsonEncode(paths),
    );
  }

  /// Charger les photos pour une mesure
  Future<List<File>> loadMeasurementPhotos(String measurementId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('measurement_photos_$measurementId');
    
    if (json == null) return [];
    
    try {
      final List<dynamic> paths = jsonDecode(json);
      return paths
          .map((path) => File(path as String))
          .where((f) => f.existsSync()) // Vérifier que les fichiers existent
          .toList();
    } catch (e) {
      print('Erreur chargement photos: $e');
      return [];
    }
  }

  /// Sauvegarder toutes les photos pour toutes les mesures
  Future<void> saveAllMeasurementPhotos(
    Map<String, List<File>> photosMap,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    
    for (final entry in photosMap.entries) {
      final paths = entry.value.map((f) => f.path).toList();
      await prefs.setString(
        'measurement_photos_${entry.key}',
        jsonEncode(paths),
      );
    }
  }

  /// Supprimer les photos d'une mesure
  Future<void> deleteMeasurementPhotos(String measurementId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('measurement_photos_$measurementId');
  }

  /// Exporter les photos en JSON (pour PDF ou export)
  Map<String, List<String>> exportPhotosAsJson(
    Map<String, List<File>> photosMap,
  ) {
    final export = <String, List<String>>{};
    
    for (final entry in photosMap.entries) {
      export[entry.key] = entry.value.map((f) => f.path).toList();
    }
    
    return export;
  }

  /// Compter le nombre total de photos
  int countTotalPhotos(Map<String, List<File>> photosMap) {
    return photosMap.values.fold(0, (sum, list) => sum + list.length);
  }
}
