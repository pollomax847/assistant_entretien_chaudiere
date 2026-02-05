import 'package:flutter/material.dart';
import 'dart:io';
import '../../../utils/mixins/photo_manager_mixin.dart';

/// Widget pour gérer les photos associées à une mesure ou non-conformité
class MeasurementPhotoWidget extends StatefulWidget {
  /// Titre de la section photos
  final String title;
  
  /// Photos existantes
  final List<File> initialPhotos;
  
  /// Callback quand les photos changent
  final ValueChanged<List<File>> onPhotosChanged;
  
  /// Nombre max de photos autorisées
  final int maxPhotos;
  
  /// Recommandé (non obligatoire)
  final bool recommended;

  const MeasurementPhotoWidget({
    super.key,
    required this.title,
    required this.initialPhotos,
    required this.onPhotosChanged,
    this.maxPhotos = 5,
    this.recommended = true,
  });

  @override
  State<MeasurementPhotoWidget> createState() => _MeasurementPhotoWidgetState();
}

class _MeasurementPhotoWidgetState extends State<MeasurementPhotoWidget>
    with PhotoManagerMixin {
  late List<File> _photos;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.initialPhotos);
  }

  Future<void> _ajouterPhoto() async {
    if (_photos.length >= widget.maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${widget.maxPhotos} photos atteint'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final file = await showPhotoPickerDialog(
      context,
      '/sdcard/DCIM/MesurementPhotos',
    );

    if (file != null && mounted) {
      setState(() {
        _photos.add(file);
      });
      widget.onPhotosChanged(_photos);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Photo ajoutée'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _supprimerPhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onPhotosChanged(_photos);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Photo supprimée'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _afficherPhoto(File photo) {
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
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (widget.recommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Recommandé',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            
            // Compteur photos
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '${_photos.length}/${widget.maxPhotos} photos',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),

            // Grille de photos
            if (_photos.isNotEmpty) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _afficherPhoto(_photos[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _photos[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Bouton supprimer
                      Positioned(
                        top: -8,
                        right: -8,
                        child: GestureDetector(
                          onTap: () => _supprimerPhoto(index),
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
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
            ],

            // Bouton ajouter
            if (_photos.length < widget.maxPhotos)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _ajouterPhoto,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Ajouter une photo'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
