// widgets/_photo_annotation.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/_pictogrammes.dart';

class Annotation {
  final String pictogrammeId;
  final Offset position;
  final String? note;
  final double scale;

  Annotation({
    required this.pictogrammeId,
    required this.position,
    this.note,
    this.scale = 1.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'pictogrammeId': pictogrammeId,
      'position': {'dx': position.dx, 'dy': position.dy},
      'note': note,
      'scale': scale,
    };
  }

  factory Annotation.fromMap(Map<String, dynamic> map) {
    return Annotation(
      pictogrammeId: map['pictogrammeId'],
      position: Offset(
        map['position']['dx'],
        map['position']['dy'],
      ),
      note: map['note'],
      scale: map['scale'] ?? 1.0,
    );
  }

  Annotation copyWith({
    String? pictogrammeId,
    Offset? position,
    String? note,
    double? scale,
  }) {
    return Annotation(
      pictogrammeId: pictogrammeId ?? this.pictogrammeId,
      position: position ?? this.position,
      note: note ?? this.note,
      scale: scale ?? this.scale,
    );
  }
}

class PhotoAnnotation extends StatefulWidget {
  final String imagePath;
  final List<Annotation> annotations;
  final Function(List<Annotation>) onAnnotationsChanged;
  final bool isEditing;
  final List<PictogrammeData> selectedPictogrammes;

  const PhotoAnnotation({
    super.key,
    required this.imagePath,
    required this.annotations,
    required this.onAnnotationsChanged,
    this.isEditing = false,
    this.selectedPictogrammes = const [],
  });

  @override
  PhotoAnnotationState createState() => PhotoAnnotationState();
}

class PhotoAnnotationState extends State<PhotoAnnotation> {
  List<Annotation> _annotations = [];
  Annotation? _selectedAnnotation;

  @override
  void initState() {
    super.initState();
    _annotations = List.from(widget.annotations);
  }

  void _ajouterAnnotation(Offset position, PictogrammeData pictogramme) {
    final annotation = Annotation(
      pictogrammeId: pictogramme.id,
      position: position,
      scale: 1.0,
    );
    setState(() {
      _annotations.add(annotation);
      _selectedAnnotation = annotation;
    });
    widget.onAnnotationsChanged(_annotations);
    _afficherDialogueNote(_annotations.length - 1);
  }

  void _afficherDialogueNote(int index) {
    final TextEditingController noteController = TextEditingController(
      text: _annotations[index].note,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Description ou commentaire',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Taille : '),
                Expanded(
                  child: Slider(
                    value: _annotations[index].scale,
                    min: 0.5,
                    max: 3.0,
                    divisions: 25,
                    label: _annotations[index].scale.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _annotations[index] = _annotations[index].copyWith(
                          scale: value,
                        );
                      });
                      widget.onAnnotationsChanged(_annotations);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _annotations[index] = _annotations[index].copyWith(
                  note: noteController.text,
                );
              });
              widget.onAnnotationsChanged(_annotations);
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _supprimerAnnotation(int index) {
    setState(() {
      _annotations.removeAt(index);
      _selectedAnnotation = null;
    });
    widget.onAnnotationsChanged(_annotations);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: widget.isEditing && widget.selectedPictogrammes.isNotEmpty
          ? (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              _ajouterAnnotation(
                localPosition,
                widget.selectedPictogrammes.first,
              );
            }
          : null,
      child: Stack(
        children: [
          Image.file(File(widget.imagePath)),
          ..._annotations.asMap().entries.map((entry) {
            final index = entry.key;
            final annotation = entry.value;
            final pictogramme = Pictogrammes.getById(annotation.pictogrammeId);
            if (pictogramme == null) return const SizedBox();

            final isSelected = _selectedAnnotation == annotation;
            final size = 48.0 * annotation.scale;

            return Positioned(
              left: annotation.position.dx - (size / 2),
              top: annotation.position.dy - (size / 2),
              child: GestureDetector(
                onTapDown: widget.isEditing
                    ? (details) {
                        setState(() {
                          _selectedAnnotation = annotation;
                        });
                      }
                    : null,
                onPanUpdate: widget.isEditing && isSelected
                    ? (details) {
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;
                        final localPosition = box.globalToLocal(
                          details.globalPosition,
                        );
                        setState(() {
                          final index = _annotations.indexOf(annotation);
                          _annotations[index] = annotation.copyWith(
                            position: localPosition,
                          );
                        });
                        widget.onAnnotationsChanged(_annotations);
                      }
                    : null,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: pictogramme.couleur.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Colors.white,
                            width: 2,
                          )
                        : null,
                  ),
                  child: IconButton(
                    icon: Icon(
                      pictogramme.icone,
                      color: Colors.white,
                      size: size * 0.5,
                    ),
                    onPressed: () {
                      if (widget.isEditing) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(pictogramme.nom),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (annotation.note != null) ...[
                                  const Text(
                                    'Note :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(annotation.note!),
                                  const SizedBox(height: 16),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Modifier'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _afficherDialogueNote(index);
                                      },
                                    ),
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Supprimer'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _supprimerAnnotation(index);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (annotation.note != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(pictogramme.nom),
                            content: Text(annotation.note!),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Fermer'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
