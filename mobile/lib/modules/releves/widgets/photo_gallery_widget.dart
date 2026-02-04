import 'package:flutter/material.dart';
import 'dart:io';
import '../../utils/mixins/photo_manager_mixin.dart';

/// Widget réutilisable pour gérer les photos dans les formulaires
class PhotoGalleryWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final ValueChanged<List<File>> onPhotosChanged;
  final int maxPhotos;

  const PhotoGalleryWidget({
    super.key,
    required this.title,
    this.subtitle = 'Cliquez pour ajouter des photos',
    required this.onPhotosChanged,
    this.maxPhotos = 10,
  });

  @override
  State<PhotoGalleryWidget> createState() => _PhotoGalleryWidgetState();
}

class _PhotoGalleryWidgetState extends State<PhotoGalleryWidget>
    with PhotoManagerMixin {
  final List<File> _photos = [];

  @override
  void initState() {
    super.initState();
    _initializePhotoDirectory();
  }

  Future<void> _initializePhotoDirectory() async {
    // La création du dossier se fera lors de la première sauvegarde
    // Dans un cas réel, vous utiliseriez path_provider
  }

  void _addPhoto() async {
    if (_photos.length >= widget.maxPhotos) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Limite de ${widget.maxPhotos} photos atteinte',
            ),
          ),
        );
      }
      return;
    }

    final file = await showPhotoPickerDialog(
      context,
      '/sdcard/DCIM/RelevelTechnique',
    );

    if (file != null) {
      setState(() {
        _photos.add(file);
      });
      widget.onPhotosChanged(_photos);
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onPhotosChanged(_photos);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Photo supprimée')),
    );
  }

  void _previewPhoto(File photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.file(photo, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera,
                    color: Colors.blue.shade600, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_photos.length}/${widget.maxPhotos}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_photos.isEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.add_a_photo,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'Aucune photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _photos.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: buildPhotoThumbnail(
                        _photos[index],
                        onDelete: () => _removePhoto(index),
                        onPreview: () => _previewPhoto(_photos[index]),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _photos.length < widget.maxPhotos ? _addPhoto : null,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Ajouter une photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
