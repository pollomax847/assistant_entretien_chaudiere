// services/photo_service.dart (externe)
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import '../models/_photo_categories.dart';

class PhotoService {
  static final PhotoService _instance = PhotoService._internal();
  final ImagePicker _picker = ImagePicker();

  factory PhotoService() {
    return _instance;
  }

  PhotoService._internal();

  Future<String> _createPhotoDirectory(
      String clientId, String typeReleve) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String photosPath =
        path.join(appDir.path, 'photos', clientId, typeReleve);
    final Directory photosDir = Directory(photosPath);

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    return photosPath;
  }

  String _generatePhotoFileName(String categoryId) {
    final DateTime now = DateTime.now();
    final String dateStr = DateFormat('yyyyMMdd_HHmmss').format(now);
    final PhotoCategory? category = PhotoCategories.getCategoryById(categoryId);
    final String categoryName =
        category?.nom.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_') ?? 'photo';

    return '${categoryName}_$dateStr.jpg';
  }

  Future<String?> _savePhoto(String clientId, String typeReleve,
      String categoryId, XFile photo) async {
    try {
      final String dirPath = await _createPhotoDirectory(clientId, typeReleve);
      final String fileName = _generatePhotoFileName(categoryId);
      final String filePath = path.join(dirPath, fileName);

      // Copier la photo dans le dossier approprié
      final File newImage = File(filePath);
      await newImage.writeAsBytes(await File(photo.path).readAsBytes());

      return filePath;
    } catch (e) {
      print('Erreur lors de la sauvegarde de la photo: $e');
      return null;
    }
  }

  Future<String?> prendrePhoto({
    required String clientId,
    required String typeReleve,
    required String categoryId,
  }) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo == null) return null;

      return await _savePhoto(clientId, typeReleve, categoryId, photo);
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
      return null;
    }
  }

  Future<String?> choisirPhoto({
    required String clientId,
    required String typeReleve,
    required String categoryId,
  }) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo == null) return null;

      return await _savePhoto(clientId, typeReleve, categoryId, photo);
    } catch (e) {
      print('Erreur lors de la sélection de photo: $e');
      return null;
    }
  }

  Future<void> supprimerPhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Erreur lors de la suppression de la photo: $e');
    }
  }

  Future<List<String>> getPhotos(String clientId, String typeReleve) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String dirPath =
          path.join(appDir.path, 'photos', clientId, typeReleve);
      final Directory dir = Directory(dirPath);

      if (!await dir.exists()) {
        return [];
      }

      final List<FileSystemEntity> files = await dir.list().toList();
      return files
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.jpg'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des photos: $e');
      return [];
    }
  }

  Future<void> deplacerPhoto(String photoPath, String nouveauClientId,
      String nouveauTypeReleve) async {
    try {
      final File file = File(photoPath);
      if (!await file.exists()) return;

      final String fileName = path.basename(photoPath);
      final String nouveauDirPath =
          await _createPhotoDirectory(nouveauClientId, nouveauTypeReleve);
      final String nouveauPath = path.join(nouveauDirPath, fileName);

      await file.copy(nouveauPath);
      await file.delete();
    } catch (e) {
      print('Erreur lors du déplacement de la photo: $e');
    }
  }
}
