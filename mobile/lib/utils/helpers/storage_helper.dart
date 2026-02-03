import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Helper pour la gestion des fichiers et du stockage
class StorageHelper {
  /// Retourne le répertoire des documents de l'application
  static Future<Directory> getDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
  
  /// Retourne le répertoire temporaire
  static Future<Directory> getTemporaryDirectory() async {
    return await getTemporaryDirectory();
  }
  
  /// Retourne le chemin complet d'un fichier dans les documents
  static Future<String> getDocumentPath(String filename) async {
    final dir = await getDocumentsDirectory();
    return '${dir.path}/$filename';
  }
  
  /// Retourne le chemin complet d'un fichier temporaire
  static Future<String> getTempPath(String filename) async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/$filename';
  }
  
  /// Vérifie si un fichier existe
  static Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }
  
  /// Supprime un fichier
  static Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Lit le contenu d'un fichier
  static Future<String?> readFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Écrit du contenu dans un fichier
  static Future<bool> writeFile(String path, String content) async {
    try {
      final file = File(path);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Copie un fichier
  static Future<bool> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      if (await sourceFile.exists()) {
        await sourceFile.copy(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Partage un fichier
  static Future<void> shareFile(String path, {String? subject}) async {
    try {
      await Share.shareXFiles(
        [XFile(path)],
        subject: subject,
      );
    } catch (e) {
      throw Exception('Erreur lors du partage du fichier: $e');
    }
  }
  
  /// Partage du texte
  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (e) {
      throw Exception('Erreur lors du partage du texte: $e');
    }
  }
  
  /// Retourne la taille d'un fichier en bytes
  static Future<int> getFileSize(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
  
  /// Formate une taille de fichier en string lisible
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  /// Liste tous les fichiers dans un répertoire
  static Future<List<FileSystemEntity>> listFiles(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      if (await directory.exists()) {
        return directory.listSync();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  /// Crée un répertoire s'il n'existe pas
  static Future<bool> createDirectory(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Supprime un répertoire
  static Future<bool> deleteDirectory(String path) async {
    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Nettoie les fichiers temporaires
  static Future<bool> cleanTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
        await tempDir.create();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
