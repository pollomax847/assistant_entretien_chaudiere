import 'package:flutter/material.dart';
import 'package:chauffageexpert/services/pdf_generator.dart';
import 'package:chauffageexpert/services/json_exporter.dart';
import 'package:chauffageexpert/modules/releves/releve_technique_model.dart';

class RTClimForm extends StatefulWidget {
  const RTClimForm({super.key});

  @override
  State<RTClimForm> createState() => _RTClimFormState();
}

class _RTClimFormState extends State<RTClimForm> {
  final _formKey = GlobalKey<FormState>();

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
  // ignore: unused_field
  final bool _isAppartement = false;
  bool _tableauConforme = false;
  // ignore: unused_field
  final bool _diff30ma = true;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique Climatisation'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildHeader(),
              _buildSection('Client', [
                _buildTextField('numClient', 'Numéro client (gazelle)'),
                _buildTextField('nomClient', 'Nom du client'),
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('telMobile', 'Téléphone mobile', keyboardType: TextInputType.phone),
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
                  initialValue: _typeRaccordement,
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performExports();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('ENREGISTRER LE RELEVÉ CLIM', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
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

  Future<void> _performExports() async {
    final Map<String, Map<String, String>> sections = {
      'Client': {
        'Numéro client': _controllers['numClient']?.text ?? '',
        'Nom client': _controllers['nomClient']?.text ?? '',
        'Email': _controllers['email']?.text ?? '',
        'Téléphone': _controllers['telMobile']?.text ?? '',
      },
      'Électrique': {
        'Tableau conforme': _tableauConforme ? 'Oui' : 'Non',
        'Distance tableau': _controllers['distTableau']?.text ?? '',
        'Puissance abo': _controllers['puissanceAbo']?.text ?? '',
        'Tension (V)': _controllers['tension']?.text ?? '',
      },
      'Installation': {
        'Surface clim': _controllers['surfaceClim']?.text ?? '',
        'Puissance unité': _controllers['puissanceUnite']?.text ?? '',
        'Long. raccordement': _controllers['longRaccordement']?.text ?? '',
      },
    };

    try {
      final pdfFile = await PDFGeneratorService.genererReleveTechnique(donnees: sections, typeReleve: 'clim');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF généré: ${pdfFile.path}')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur génération PDF')));
    }

    final diagnosticGazMap = await JSONExporter.collectDiagnosticGaz();
    final releve = ReleveTechnique(
      clientNumber: _controllers['numClient']?.text,
      clientName: _controllers['nomClient']?.text,
      clientEmail: _controllers['email']?.text,
      clientPhone: _controllers['telMobile']?.text,
      surface: _controllers['surfaceClim']?.text,
      anneeConstruction: _controllers['anneeConst']?.text,
      diagnosticGaz: diagnosticGazMap,
    );

    try {
      final jsonFile = await JSONExporter.exportReleveTechniqueJson(releve, 'clim');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('JSON exporté: ${jsonFile.path}')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur export JSON')));
    }
  }
}
