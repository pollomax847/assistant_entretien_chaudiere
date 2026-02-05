import 'package:flutter/material.dart';
import 'dart:io';
import '../models/photo_category.dart';
import '../../../utils/mixins/photo_manager_mixin.dart';

/// Widget pour gérer les photos par catégories
class CategorizedPhotoWidget extends StatefulWidget {
  final List<PhotoCategory> categories;
  final ValueChanged<Map<String, File?>>? onPhotosChanged;

  const CategorizedPhotoWidget({
    super.key,
    required this.categories,
    this.onPhotosChanged,
  });

  @override
  State<CategorizedPhotoWidget> createState() => _CategorizedPhotoWidgetState();
}

class _CategorizedPhotoWidgetState extends State<CategorizedPhotoWidget>
    with PhotoManagerMixin {
  final Map<String, File?> _photos = {};

  @override
  void initState() {
    super.initState();
    for (var category in widget.categories) {
      _photos[category.id] = null;
    }
  }

  Future<void> _capturePhoto(String categoryId) async {
    final file = await showPhotoPickerDialog(context, '/sdcard/DCIM/RelevelTechnique');
    if (file != null) {
      setState(() {
        _photos[categoryId] = file;
      });
      widget.onPhotosChanged?.call(_photos);
    }
  }

  void _removePhoto(String categoryId) {
    setState(() {
      _photos[categoryId] = null;
    });
    widget.onPhotosChanged?.call(_photos);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.categories.map((category) {
        final hasPhoto = _photos[category.id] != null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (category.icon != null) ...[
                        Icon(category.icon, size: 24, color: Colors.indigo),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              category.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (hasPhoto)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '✓',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (hasPhoto)
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _previewPhoto(_photos[category.id]!),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Image.file(
                              _photos[category.id]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: FloatingActionButton.small(
                            onPressed: () => _removePhoto(category.id),
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.delete, size: 18),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _capturePhoto(category.id),
                          icon: const Icon(Icons.camera_alt, size: 18),
                          label: const Text('Caméra'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _capturePhoto(category.id),
                          icon: const Icon(Icons.photo_library, size: 18),
                          label: const Text('Galerie'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
