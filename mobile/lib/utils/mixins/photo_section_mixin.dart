import 'package:flutter/material.dart';
import 'package:assistant_entreiten_chaudiere/modules/releves/widgets/photo_gallery_widget.dart';
import 'package:assistant_entreiten_chaudiere/modules/releves/widgets/categorized_photo_widget.dart';
import 'package:assistant_entreiten_chaudiere/modules/releves/models/photo_category.dart';
import 'dart:io';

/// Mixin pour gérer les sections photo dans les formulaires
/// Supporte 3 ou 4 photos selon le type de relevé
mixin PhotoSectionMixin<T extends StatefulWidget> on State<T> {
  
  /// Construit la section photos pour Chaudière (3 photos)
  Widget buildChaudierePhotosSection() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.orange[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.camera_alt, color: Colors.orange),
        title: const Text(
          '📸 Annexes - Photos Obligatoires (3)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
        ),
        subtitle: const Text('Plaque | Vue ext. | Vue lointaine'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildPhotoDescription(
                  '1️⃣ Plaque de Raccordement',
                  'Tuyauterie, vannes, connexions (Page 5 PDF)',
                  Icons.plumbing,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '2️⃣ Vue Extérieure',
                  'Façade de la maison (Page 5 PDF)',
                  Icons.house,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '3️⃣ Vue Éloignée',
                  'Contexte général de l\'installation',
                  Icons.image_search,
                ),
                const SizedBox(height: 16),
                const PhotoGalleryWidget(maxPhotos: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la section photos pour Climatisation (4 photos)
  Widget buildClimPhotosSection() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.cyan[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.camera_alt, color: Colors.cyan),
        title: const Text(
          '📸 Annexes - Photos Obligatoires (4)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.cyan),
        ),
        subtitle: const Text('Groupe ext. | TGBT | Groupe int. | Alt.'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildPhotoDescription(
                  '1️⃣ Emplacement Groupe Extérieur',
                  'Installation unité externe (Page 1 PDF)',
                  Icons.cloud,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '2️⃣ TGBT (Tableau Électrique)',
                  'Tableau général basse tension & compteur (Page 3 PDF)',
                  Icons.electrical_services,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '3️⃣ Emplacement Groupe Intérieur',
                  'Unité intérieure dans la maison (Page 4 PDF)',
                  Icons.home_work,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '4️⃣ Groupe Extérieur 2 (Angle Alt.)',
                  'Vue alternative du groupe extérieur (Page 3 PDF)',
                  Icons.collections,
                ),
                const SizedBox(height: 16),
                const PhotoGalleryWidget(maxPhotos: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la section photos pour PAC (4 photos)
  Widget buildPACPhotosSection() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.indigo[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.camera_alt, color: Colors.indigo),
        title: const Text(
          '📸 Annexes - Photos Obligatoires (4)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
        ),
        subtitle: const Text('TGBT | TGBT 2 | Groupe ext. | Groupe int.'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildPhotoDescription(
                  '1️⃣ TGBT (Tableau Principal)',
                  'Tableau électrique principal sur panneau (Page 4 PDF)',
                  Icons.electrical_services,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '2️⃣ TGBT 2 (Extension)',
                  'Extension du tableau ou disjoncteurs supplémentaires (Page 5 PDF)',
                  Icons.dashboard,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '3️⃣ Emplacement Groupe Extérieur',
                  'Cuve et espace de stockage PAC (Page 6 PDF)',
                  Icons.apartment,
                ),
                const SizedBox(height: 12),
                _buildPhotoDescription(
                  '4️⃣ Emplacement Groupe Intérieur',
                  'UI bleue actuelle à remplacer par PAC (Page 7 PDF)',
                  Icons.hvac,
                ),
                const SizedBox(height: 16),
                const PhotoGalleryWidget(maxPhotos: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: Construit une description de photo
  Widget _buildPhotoDescription(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une alerte pour photos obligatoires
  Widget buildPhotoRequirementAlert() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Photos obligatoires',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                Text(
                  'Le relevé doit être accompagné de toutes les photos requises',
                  style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit section Annexes avec Photos Catégorisées pour Chaudière
  Widget buildChaudierePhotosCategorized({
    ValueChanged<Map<String, File?>>? onPhotosChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.orange[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.photo, color: Colors.orange),
        title: const Text(
          '📷 Annexes - Photos Chaudière (3)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange),
        ),
        subtitle: const Text('Catégorisée et obligatoire'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: CategorizedPhotoWidget(
              categories: PhotoCategoriesByType.forChaudiere(),
              onPhotosChanged: onPhotosChanged,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit section Annexes avec Photos Catégorisées pour PAC
  Widget buildPACPhotosCategorized({
    ValueChanged<Map<String, File?>>? onPhotosChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.indigo[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.photo, color: Colors.indigo),
        title: const Text(
          '📷 Annexes - Photos PAC (4)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
        ),
        subtitle: const Text('Catégorisée et obligatoire'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: CategorizedPhotoWidget(
              categories: PhotoCategoriesByType.forPAC(),
              onPhotosChanged: onPhotosChanged,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit section Annexes avec Photos Catégorisées pour Clim
  Widget buildClimPhotosCategorized({
    ValueChanged<Map<String, File?>>? onPhotosChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.cyan[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.photo, color: Colors.cyan),
        title: const Text(
          '📷 Annexes - Photos Clim (4)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.cyan),
        ),
        subtitle: const Text('Catégorisée et obligatoire'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: CategorizedPhotoWidget(
              categories: PhotoCategoriesByType.forClim(),
              onPhotosChanged: onPhotosChanged,
            ),
          ),
        ],
      ),
    );
  }
}
