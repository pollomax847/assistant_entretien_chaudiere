import 'package:flutter/material.dart';
import 'dart:io';
import 'widgets/photo_gallery_widget.dart';

class RTClimForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDataChanged;

  const RTClimForm({super.key, this.onDataChanged});

  @override
  State<RTClimForm> createState() => _RTClimFormState();
}

class _RTClimFormState extends State<RTClimForm> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _photos = [];

  // --- CONTROLLERS ---
  final Map<String, TextEditingController> _controllers = {
    'numClient': TextEditingController(),
    'nomClient': TextEditingController(),
    'adresseFact': TextEditingController(),
    'email': TextEditingController(),
    'telMobile': TextEditingController(),
    'surface': TextEditingController(),
    'anneeConst': TextEditingController(),
    'distTableau': TextEditingController(),
    'puissanceAbo': TextEditingController(),
    'tension': TextEditingController(),
    'emplacementsDispo': TextEditingController(),
    'hauteurFixationExt': TextEditingController(),
    'surfaceClim': TextEditingController(),
    'puissanceUnite': TextEditingController(),
    'longRaccordement': TextEditingController(),
  };

  // --- STATES ---
  bool _isAppartement = false;
  bool _tableauConforme = false;
  bool _diff30ma = true;
  bool _besoinTableauSupp = false;
  bool _groupeSurChaise = false;
  bool _pompeRelevageInt = false;
  String _typeRaccordement = 'Monophasé';

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
                _buildTextField('numClient', 'Numéro client (gazelle)'),
                _buildTextField('nomClient', 'Nom du client'),
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('telMobile', 'Téléphone mobile', keyboardType: TextInputType.phone),
              ]),
              _buildSection('Description de l\'habitation', [
                SwitchListTile(
                  title: const Text('Appartement'),
                  value: _isAppartement,
                  onChanged: (v) => setState(() => _isAppartement = v),
                ),
                _buildTextField('surface', 'Surface (m2)', keyboardType: TextInputType.number),
                _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
              ]),
              _buildSection('Caractéristiques Électriques', [
                SwitchListTile(
                  title: const Text('Tableau électrique conforme'),
                  value: _tableauConforme,
                  onChanged: (v) => setState(() => _tableauConforme = v),
                ),
                _buildTextField('distTableau', 'Dist. entre tableau & instal (m/l)', keyboardType: TextInputType.number),
                _buildTextField('puissanceAbo', 'Puissance abonnement (kVA)', keyboardType: TextInputType.number),
                _buildTextField('tension', 'Mesure de la tension (V)', keyboardType: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: _typeRaccordement,
                  decoration: const InputDecoration(labelText: 'Type de raccordement', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: ['Monophasé', 'Triphasé'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _typeRaccordement = v!),
                ),
                CheckboxListTile(
                  title: const Text('Besoin d\'un tableau supplémentaire'),
                  value: _besoinTableauSupp,
                  onChanged: (v) => setState(() => _besoinTableauSupp = v!),
                ),
              ]),
              _buildSection('Installation Groupe Extérieur', [
                _buildTextField('hauteurFixationExt', 'Hauteur fixation (m)', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Groupe sur chaise'),
                  value: _groupeSurChaise,
                  onChanged: (v) => setState(() => _groupeSurChaise = v),
                ),
              ]),
              _buildSection('Installation Unité Intérieur', [
                _buildTextField('surfaceClim', 'Surface à climatiser (m2)', keyboardType: TextInputType.number),
                _buildTextField('puissanceUnite', 'Puissance unité (kW)', keyboardType: TextInputType.number),
                _buildTextField('longRaccordement', 'Long. raccordement (m)', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Besoin pompe de relevage'),
                  value: _pompeRelevageInt,
                  onChanged: (v) => setState(() => _pompeRelevageInt = v),
                ),
              ]),
          const SizedBox(height: 24),
          // --- PHOTOS (OPTIONNEL) ---
          PhotoGalleryWidget(
            title: 'Photos du relevé Clim',
            subtitle: 'Unités intérieure/extérieure, raccordements...',
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Column(
        children: [
          Icon(Icons.ac_unit, size: 50, color: Colors.teal),
          SizedBox(height: 10),
          Text('RELEVÉ TECHNIQUE CLIM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(thickness: 2, color: Colors.teal),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        children: children,
      ),
    );
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: keyboardType,
      ),
    );
  }
}