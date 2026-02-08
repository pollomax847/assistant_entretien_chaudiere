// widgets/_photo_manager.dart (externe)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/photo_service.dart';
import '../models/_photo_categories.dart';

class PhotoData {
  final String path;
  final String categoryId;

  PhotoData({required this.path, required this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'categoryId': categoryId,
    };
  }

  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      path: map['path'],
      categoryId: map['categoryId'],
    );
  }
}

class PhotoManager extends StatefulWidget {
  final List<PhotoData> photos;
  final Function(List<PhotoData>) onPhotosChanged;
  final bool isRequired;
  final String clientId;
  final String typeReleve;

  const PhotoManager({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
    required this.clientId,
    required this.typeReleve,
    this.isRequired = true,
  });

  @override
  State<PhotoManager> createState() => _PhotoManagerState();
}

class _PhotoManagerState extends State<PhotoManager> {
  final PhotoService _photoService = PhotoService();
  late List<PhotoData> _currentPhotos;
  String _selectedCategoryId = PhotoCategories.categories.first.id;

  @override
  void initState() {
    super.initState();
    _currentPhotos = List.from(widget.photos);
  }

  Future<void> _ajouterPhoto(ImageSource source) async {
    String? photoPath;
    if (source == ImageSource.camera) {
      photoPath = await _photoService.prendrePhoto(
        clientId: widget.clientId,
        typeReleve: widget.typeReleve,
        categoryId: _selectedCategoryId,
      );
    } else {
      photoPath = await _photoService.choisirPhoto(
        clientId: widget.clientId,
        typeReleve: widget.typeReleve,
        categoryId: _selectedCategoryId,
      );
    }

    setState(() {
      _currentPhotos.add(PhotoData(
        path: photoPath!,
        categoryId: _selectedCategoryId,
      ));
    });
    widget.onPhotosChanged(_currentPhotos);
  }

  Future<void> _supprimerPhoto(int index) async {
    final photoPath = _currentPhotos[index].path;
    await _photoService.supprimerPhoto(photoPath);
    setState(() {
      _currentPhotos.removeAt(index);
    });
    widget.onPhotosChanged(_currentPhotos);
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: const InputDecoration(
        labelText: 'Catégorie de photo',
        border: OutlineInputBorder(),
      ),
      items: PhotoCategories.categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.nom),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCategoryId = newValue;
          });
        }
      },
    );
  }

  Widget _buildPhotoGrid() {
    return Column(
      children: PhotoCategories.categories.map((category) {
        final categoryPhotos = _currentPhotos
            .where((photo) => photo.categoryId == category.id)
            .toList();

        if (categoryPhotos.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.nom,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryPhotos.length,
                itemBuilder: (context, index) {
                  final photoIndex =
                      _currentPhotos.indexOf(categoryPhotos[index]);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _showPhotoDetails(
                              categoryPhotos[index], category),
                          child: Image.file(
                            File(categoryPhotos[index].path),
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _supprimerPhoto(photoIndex),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _showPhotoDetails(PhotoData photo, PhotoCategory category) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.nom,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Image.file(
                File(photo.path),
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                'Pourquoi cette photo ?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(category.pourquoi),
              const SizedBox(height: 8),
              Text(
                'Utilisation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(category.utilisation),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCategorySelector(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _ajouterPhoto(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre une photo'),
            ),
            ElevatedButton.icon(
              onPressed: () => _ajouterPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Choisir une photo'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_currentPhotos.isEmpty)
          Center(
            child: Text(
              'Aucune photo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ),
        if (_currentPhotos.isNotEmpty) _buildPhotoGrid(),
      ],
    );
  }
}
