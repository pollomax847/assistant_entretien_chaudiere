import 'package:flutter/material.dart';
import 'dart:io';
import 'widgets/photo_gallery_widget.dart';

class RTChaudiereForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDataChanged;

  const RTChaudiereForm({super.key, this.onDataChanged});

  @override
  State<RTChaudiereForm> createState() => _RTChaudiereFormState();
}

class _RTChaudiereFormState extends State<RTChaudiereForm> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _photos = [];

  // --- CONTROLLERS ---
  final Map<String, TextEditingController> _controllers = {
    'numClient': TextEditingController(),
    'nomClient': TextEditingController(),
    'adresseFact': TextEditingController(),
    'surface': TextEditingController(),
    'anneeConst': TextEditingController(),
    'nbRadiateurs': TextEditingController(),
    'consoFuel': TextEditingController(),
    'tension': TextEditingController(),
    'puissanceAbo': TextEditingController(),
    'distTableau': TextEditingController(),
  };

  // --- STATES ---
  bool _appartement = false;
  bool _reperageAmiante = false;
  bool _tableauConforme = false;
  bool _besoinTableauSupp = false;
  bool _chauffageSeul = true;
  bool _avecBallon = false;
  bool _plancherChauffant = false;
  String _typeEmetteur = 'Radiateur fonte';
  String _typeGaz = 'Gaz naturel';

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildHeader(),
          _buildSection('Client', [
            _buildTextField('numClient', 'Numéro client (Gazelle)'),
            _buildTextField('nomClient', 'Nom du client'),
            _buildTextField('adresseFact', 'Adresse de facturation', maxLines: 2),
          ]),
          _buildSection('Description de l\'habitation', [
            SwitchListTile(
              title: const Text('Appartement'),
              value: _appartement,
              onChanged: (v) => setState(() => _appartement = v),
            ),
            SwitchListTile(
              title: const Text('Repérage amiante établi'),
              value: _reperageAmiante,
              onChanged: (v) => setState(() => _reperageAmiante = v),
            ),
            _buildTextField('surface', 'Surface à chauffer (m²)', keyboardType: TextInputType.number),
            _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
          ]),
          _buildSection('Système Actuel', [
            SwitchListTile(
              title: const Text('Chauffage seul'),
              value: _chauffageSeul,
              onChanged: (v) => setState(() => _chauffageSeul = v),
            ),
            SwitchListTile(
              title: const Text('Avec ballon ECS'),
              value: _avecBallon,
              onChanged: (v) => setState(() => _avecBallon = v),
            ),
            _buildTextField('nbRadiateurs', 'Nombre de radiateurs', keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: _typeEmetteur,
              decoration: const InputDecoration(labelText: 'Type d\'émetteur', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
              items: ['Radiateur fonte', 'Radiateur acier', 'Plancher chauffant'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _typeEmetteur = v!),
            ),
            SwitchListTile(
              title: const Text('Plancher chauffant'),
              value: _plancherChauffant,
              onChanged: (v) => setState(() => _plancherChauffant = v),
            ),
          ]),
          _buildSection('Type d\'Énergie', [
            DropdownButtonFormField<String>(
              value: _typeGaz,
              decoration: const InputDecoration(labelText: 'Type de gaz', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
              items: ['Gaz naturel', 'Propane', 'Fioul'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _typeGaz = v!),
            ),
            _buildTextField('consoFuel', 'Consommation annuelle (L ou m³)', keyboardType: TextInputType.number),
          ]),
          _buildSection('Caractéristiques Électriques', [
            SwitchListTile(
              title: const Text('Tableau électrique conforme'),
              value: _tableauConforme,
              onChanged: (v) => setState(() => _tableauConforme = v),
            ),
            _buildTextField('tension', 'Mesure de la tension (V)', keyboardType: TextInputType.number),
            _buildTextField('puissanceAbo', 'Puissance abonnement (kVA)', keyboardType: TextInputType.number),
            _buildTextField('distTableau', 'Distance tableau (m)', keyboardType: TextInputType.number),
            CheckboxListTile(
              title: const Text('Besoin d\'un tableau supplémentaire'),
              value: _besoinTableauSupp,
              onChanged: (v) => setState(() => _besoinTableauSupp = v!),
            ),
          ]),
          const SizedBox(height: 24),
          // --- PHOTOS ---
          PhotoGalleryWidget(
            title: 'Photos du relevé',
            subtitle: 'Chaudière, radiateurs, raccordements...',
            maxPhotos: 10,
            onPhotosChanged: (photos) {
              _photos.clear();
              _photos.addAll(photos);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Column(
        children: [
          Icon(Icons.local_fire_department, size: 40, color: Colors.deepOrange),
          SizedBox(height: 8),
          Text('RELEVÉ TECHNIQUE CHAUDIÈRE', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Divider(thickness: 1, color: Colors.deepOrange),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
        children: children,
      ),
    );
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}