// screens/_releve_chaudiere_p_a_c_screen.dart
import 'package:flutter/material.dart';
import './gallery.dart';
import '../services/releve_service.dart';

class ReleveChaudierePACScreen extends StatefulWidget {
  const ReleveChaudierePACScreen({super.key});

  @override
  ReleveChaudierePACScreenState createState() =>
      ReleveChaudierePACScreenState();
}

class ReleveChaudierePACScreenState extends State<ReleveChaudierePACScreen> {
  final _formKey = GlobalKey<FormState>();
  List<PhotoData> photos = []; // Changed from String to PhotoData

  // Contrôleurs pour les champs de formulaire
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _numeroSerieController = TextEditingController();
  final _puissanceController = TextEditingController();
  final _dateInstallationController = TextEditingController();
  final _observationsController = TextEditingController();

  void _onPhotosChanged(List<PhotoData> newPhotos) {
    setState(() {
      photos = newPhotos;
    });
  }

  Future<void> _sauvegarderReleve() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'marque': _marqueController.text,
        'modele': _modeleController.text,
        'numeroSerie': _numeroSerieController.text,
        'puissance': _puissanceController.text,
        'dateInstallation': _dateInstallationController.text,
        'observations': _observationsController.text,
        'photos': photos,
      };

      await ReleveService.sauvegarderReleve(
        id: DateTime.now().toString(),
        data: data,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relevé sauvegardé')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Chaudière/PAC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _sauvegarderReleve,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Informations Générales
                const Text(
                  'Informations Générales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _marqueController,
                  decoration: const InputDecoration(
                    labelText: 'Marque *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _modeleController,
                  decoration: const InputDecoration(
                    labelText: 'Modèle *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _numeroSerieController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de série *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _puissanceController,
                  decoration: const InputDecoration(
                    labelText: 'Puissance (kW) *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Champ requis' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateInstallationController,
                  decoration: const InputDecoration(
                    labelText: 'Date d\'installation',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _dateInstallationController.text =
                          '${date.day}/${date.month}/${date.year}';
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Section Photos
                const Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                PhotoGallery(
                  interventionId:
                      DateTime.now().toString(), // À remplacer par l'ID réel
                  onPhotosChanged: _onPhotosChanged,
                ),
                const SizedBox(height: 16),

                // Section Observations
                const Text(
                  'Observations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observationsController,
                  decoration: const InputDecoration(
                    labelText: 'Observations et remarques',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // Bouton de sauvegarde
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sauvegarderReleve,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Sauvegarder le relevé'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _marqueController.dispose();
    _modeleController.dispose();
    _numeroSerieController.dispose();
    _puissanceController.dispose();
    _dateInstallationController.dispose();
    _observationsController.dispose();
    super.dispose();
  }
}
