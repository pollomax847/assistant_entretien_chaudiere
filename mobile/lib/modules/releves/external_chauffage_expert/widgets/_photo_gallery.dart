// widgets/_photo_gallery.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '_photo_annotation.dart';

class PhotoData {
  final String path;
  final String category;
  final String? note;
  final DateTime dateTime;
  List<Annotation> annotations;

  PhotoData({
    required this.path,
    required this.category,
    this.note,
    required this.dateTime,
    List<Annotation>? annotations,
  }) : annotations = annotations ?? [];

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'category': category,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
      'annotations': annotations.map((e) => e.toMap()).toList(),
    };
  }

  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      path: map['path'],
      category: map['category'],
      note: map['note'],
      dateTime: DateTime.parse(map['dateTime']),
      annotations: (map['annotations'] as List?)
              ?.map((e) => Annotation.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  PhotoData copyWith({
    String? path,
    String? category,
    String? note,
    DateTime? dateTime,
    List<Annotation>? annotations,
  }) {
    return PhotoData(
      path: path ?? this.path,
      category: category ?? this.category,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      annotations: annotations ?? List.from(this.annotations),
    );
  }
}

class PhotoGallery extends StatefulWidget {
  final String interventionId;
  final List<PhotoData>? initialPhotos;
  final Function(List<PhotoData>) onPhotosChanged;
  final Function(PhotoData)? onPhotoSelected;

  const PhotoGallery({
    super.key,
    required this.interventionId,
    this.initialPhotos,
    required this.onPhotosChanged,
    this.onPhotoSelected,
  });

  @override
  PhotoGalleryState createState() => PhotoGalleryState();
}

class PhotoGalleryState extends State<PhotoGallery> {
  final ImagePicker _picker = ImagePicker();
  List<PhotoData> _photos = [];
  final Map<String, String> _categories = {
    'avant': 'Avant intervention',
    'apres': 'Après intervention',
    'equipement': 'Équipement',
    'piece': 'Pièce',
    'defaut': 'Défaut constaté',
    'autre': 'Autre',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialPhotos != null) {
      _photos = List.from(widget.initialPhotos!);
    }
  }

  Future<void> _chargerPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final photosString = prefs.getString('photos_${widget.interventionId}');
    if (photosString != null) {
      // Charger les photos depuis les préférences
      // À implémenter selon votre format de stockage
    }
    setState(() {});
  }

  Future<void> _prendrePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final newPhoto = PhotoData(
        path: photo.path,
        category: _categories.entries.first.key,
        dateTime: DateTime.now(),
      );
      setState(() {
        _photos.add(newPhoto);
      });
      widget.onPhotosChanged(_photos);
      await _sauvegarderPhotos();
    }
  }

  Future<void> _selectionnerPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      final newPhoto = PhotoData(
        path: photo.path,
        category: _categories.entries.first.key,
        dateTime: DateTime.now(),
      );
      setState(() {
        _photos.add(newPhoto);
      });
      widget.onPhotosChanged(_photos);
      await _sauvegarderPhotos();
    }
  }

  Future<void> _sauvegarderPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final photosMap = _photos.map((photo) => photo.toMap()).toList();
    await prefs.setString(
        'photos_${widget.interventionId}', photosMap.toString());
  }

  Future<void> _ajouterNote(int index) async {
    final TextEditingController noteController = TextEditingController(
      text: _photos[index].note,
    );

    final String? newNote = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une note'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            hintText: 'Saisissez votre note ici',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, noteController.text),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (newNote != null) {
      setState(() {
        _photos[index] = PhotoData(
          path: _photos[index].path,
          category: _photos[index].category,
          note: newNote,
          dateTime: _photos[index].dateTime,
          annotations: _photos[index].annotations,
        );
      });
      await _sauvegarderPhotos();
    }
  }

  void _afficherPhotoDetail(int index) {
    final photo = _photos[index];
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(_categories[photo.category] ?? 'Photo'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pop(context);
                    _editerPhoto(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.pop(context);
                    _supprimerPhoto(index);
                  },
                ),
              ],
            ),
            Expanded(
              child: PhotoAnnotation(
                imagePath: photo.path,
                annotations: photo.annotations,
                onAnnotationsChanged: (annotations) {
                  setState(() {
                    _photos[index] = photo.copyWith(annotations: annotations);
                  });
                  widget.onPhotosChanged(_photos);
                  _sauvegarderPhotos();
                },
                isEditing: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editerPhoto(int index) {
    // TODO: Implémenter l'édition de photo
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _prendrePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre une photo'),
            ),
            ElevatedButton.icon(
              onPressed: _selectionnerPhoto,
              icon: const Icon(Icons.photo_library),
              label: const Text('Galerie'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_photos.isNotEmpty)
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
              final photo = _photos[index];
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.onPhotoSelected != null) {
                        widget.onPhotoSelected!(photo);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(photo.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => _supprimerPhoto(index),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                  if (photo.annotations.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.push_pin,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${photo.annotations.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  void _supprimerPhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
    widget.onPhotosChanged(_photos);
    _sauvegarderPhotos();
  }
}
