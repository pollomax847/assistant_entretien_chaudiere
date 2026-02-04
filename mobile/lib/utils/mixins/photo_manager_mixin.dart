import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Mixin pour la gestion des photos dans les relevés techniques
/// 
/// Permet de:
/// - Capturer des photos avec la caméra
/// - Sélectionner depuis la galerie
/// - Sauvegarder dans les dossiers locaux
/// - Afficher un aperçu des photos
mixin PhotoManagerMixin {
  final ImagePicker _picker = ImagePicker();
  
  /// Capture une photo avec la caméra et la sauvegarde
  Future<File?> capturePhoto(BuildContext context, String directory) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compression pour économiser l'espace
      );
      
      if (image != null) {
        final savedFile = await _savePhoto(image, directory);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Photo capturée avec succès')),
          );
        }
        return savedFile;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur: $e')),
        );
      }
    }
    return null;
  }
  
  /// Sélectionne une photo depuis la galerie
  Future<File?> pickFromGallery(BuildContext context, String directory) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        final savedFile = await _savePhoto(image, directory);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Photo ajoutée avec succès')),
          );
        }
        return savedFile;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur: $e')),
        );
      }
    }
    return null;
  }
  
  /// Sauvegarde la photo dans le dossier spécifié
  Future<File> _savePhoto(XFile image, String directory) async {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'photo_$timestamp.jpg';
    final String fullPath = '$directory/$fileName';
    
    final File sourceFile = File(image.path);
    final File savedFile = await sourceFile.copy(fullPath);
    return savedFile;
  }
  
  /// Affiche un dialogue pour choisir caméra ou galerie
  Future<File?> showPhotoPickerDialog(
    BuildContext context,
    String directory,
  ) async {
    return showDialog<File?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une photo'),
        content: const Text('Choisir une source:'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Caméra'),
            onPressed: () async {
              final file = await capturePhoto(context, directory);
              if (context.mounted) Navigator.pop(context, file);
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Galerie'),
            onPressed: () async {
              final file = await pickFromGallery(context, directory);
              if (context.mounted) Navigator.pop(context, file);
            },
          ),
        ],
      ),
    );
  }
  
  /// Widget pour afficher une photo en miniature
  Widget buildPhotoThumbnail(
    File photo, {
    VoidCallback? onDelete,
    VoidCallback? onPreview,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onPreview,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Image.file(
              photo,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: -8,
            right: -8,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
