// utils/photo_utils.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUtils {
  static Future<String?> takePhoto({
    required String clientId,
    required String typeReleve,
    required String categoryId,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      final String fileName =
          '${clientId}_${typeReleve}_${categoryId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'photos/$fileName';
      // TODO: Implémenter la sauvegarde de la photo
      return filePath;
    }
    return null;
  }

  static Future<String?> pickPhoto({
    required String clientId,
    required String typeReleve,
    required String categoryId,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final String fileName =
          '${clientId}_${typeReleve}_${categoryId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'photos/$fileName';
      // TODO: Implémenter la sauvegarde de la photo
      return filePath;
    }
    return null;
  }

  static Future<void> deletePhoto(String photoPath) async {
    // TODO: Implémenter la suppression de la photo
  }

  static Widget buildPhotoPreview({
    required String photoPath,
    required VoidCallback onDelete,
    double size = 100,
  }) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(photoPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }

  static Widget buildPhotoGrid({
    required List<String> photos,
    required Function(String) onDelete,
    double size = 100,
    double spacing = 8,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return buildPhotoPreview(
          photoPath: photos[index],
          onDelete: () => onDelete(photos[index]),
          size: size,
        );
      },
    );
  }
}
