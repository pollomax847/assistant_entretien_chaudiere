import 'package:flutter/material.dart';
import 'dart:io';
import '../models/photo_category.dart';
import '../../../utils/mixins/photo_manager_mixin.dart';
import '../../../utils/mixins/mixins.dart';

/// Widget pour capturer une SEULE photo catégorisée
class SinglePhotoWidget extends StatefulWidget {
  final PhotoCategory category;
  final ValueChanged<File?>? onPhotoChanged;
  final File? initialPhoto;

  const SinglePhotoWidget({
    super.key,
    required this.category,
    this.onPhotoChanged,
    this.initialPhoto,
  });

  @override
  State<SinglePhotoWidget> createState() => _SinglePhotoWidgetState();
}

class _SinglePhotoWidgetState extends State<SinglePhotoWidget>
    with PhotoManagerMixin, SingleTickerProviderStateMixin, AnimationStyleMixin {
  late File? _photo;
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: fastDuration,
  );

  @override
  void initState() {
    super.initState();
    _photo = widget.initialPhoto;
    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final file = await showPhotoPickerDialog(context, '/sdcard/DCIM/RelevelTechnique');
    if (file != null) {
      setState(() {
        _photo = file;
      });
      widget.onPhotoChanged?.call(_photo);
    }
  }

  void _removePhoto() {
    setState(() {
      _photo = null;
    });
    widget.onPhotoChanged?.call(null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Photo supprimée')),
    );
  }

  void _previewPhoto() {
    if (_photo != null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.file(_photo!, fit: BoxFit.contain),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _photo != null;

    final fade = buildStaggeredFade(_introController, 0);
    final slide = buildStaggeredSlide(fade);

    return buildFadeSlide(
      fade: fade,
      slide: slide,
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.category.icon != null) ...[
                    Icon(widget.category.icon, size: 20, color: Colors.indigo),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          widget.category.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  if (hasPhoto)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        '✓',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (hasPhoto)
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _previewPhoto,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Image.file(
                          _photo!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: FloatingActionButton.small(
                        onPressed: _removePhoto,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.delete, size: 16),
                      ),
                    ),
                  ],
                )
              else
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade50,
                  ),
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _capturePhoto,
                      icon: const Icon(Icons.camera_alt, size: 16),
                      label: const Text('Caméra', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _capturePhoto,
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Galerie', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 6),
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
  }
}
