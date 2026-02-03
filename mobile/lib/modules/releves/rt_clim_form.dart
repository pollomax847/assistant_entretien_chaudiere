import 'package:flutter/material.dart';
import 'package:chauffageexpert/services/pdf_generator.dart';
import 'package:chauffageexpert/services/json_exporter.dart';
import 'package:chauffageexpert/modules/releves/releve_technique_model.dart';
import 'package:chauffageexpert/modules/releves/widgets/common_form_widgets.dart';

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
              CommonFormWidgets.buildHeader(
                icon: Icons.ac_unit,
                title: 'RELEVÉ TECHNIQUE CLIM',
                color: Colors.teal,
                context: context,
              ),
              CommonFormWidgets.buildSection(
                title: 'Client',
                color: Colors.teal,
                children: [
                _buildTextField('numClient', 'Numéro client (gazelle)'),
                _buildTextField('nomClient', 'Nom du client'),
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('telMobile', 'Téléphone mobile', keyboardType: TextInputType.phone),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Caractéristiques Électriques',
                color: Colors.teal,
                children: [
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
              CommonFormWidgets.buildSection(
                title: 'Installation Groupe Extérieur',
                color: Colors.teal,
                children: [
                _buildTextField('hauteurFixationExt', 'Hauteur fixation (m)', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Groupe sur chaise'),
                  value: _groupeSurChaise,
                  onChanged: (v) => setState(() => _groupeSurChaise = v),
                ),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Installation Unité Intérieur',
                color: Colors.teal,
                children: [
                _buildTextField('surfaceClim', 'Surface à climatiser (m2)', keyboardType: TextInputType.number),
                _buildTextField('puissanceUnite', 'Puissance unité (kW)', keyboardType: TextInputType.number),
                _buildTextField('longRaccordement', 'Long. raccordement (m)', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Besoin pompe de relevage'),
                  value: _pompeRelevageInt,
                  onChanged: (v) => setState(() => _pompeRelevageInt = v),
                ),
              ]),
              CommonFormWidgets.buildSubmitButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performExports();
                  }
                },
                label: 'ENREGISTRER LE RELEVÉ CLIM',
                backgroundColor: Colors.teal,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
      final pdfFile = await PDFGeneratorService.instance.genererReleveTechnique(donnees: sections, typeReleve: 'clim');
      if (mounted) CommonFormWidgets.showSuccessSnackBar(context, 'PDF généré: ${pdfFile.path}');
    } catch (e) {
      if (mounted) CommonFormWidgets.showErrorSnackBar(context, 'Erreur génération PDF');
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
      if (mounted) CommonFormWidgets.showSuccessSnackBar(context, 'JSON exporté: ${jsonFile.path}');
    } catch (e) {
      if (mounted) CommonFormWidgets.showErrorSnackBar(context, 'Erreur export JSON');
    }
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text}) {
    return CommonFormWidgets.buildTextField(
      controller: _controllers[key]!,
      label: label,
      keyboardType: keyboardType,
    );
  }
}