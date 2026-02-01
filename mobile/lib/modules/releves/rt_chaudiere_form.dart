import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chauffage_expert/services/pdf_generator.dart';
import 'package:chauffage_expert/services/json_exporter.dart';
import 'package:chauffage_expert/modules/releves/releve_technique_model.dart';

class RTChaudiereForm extends StatefulWidget {
  const RTChaudiereForm({super.key});

  @override
  State<RTChaudiereForm> createState() => _RTChaudiereFormState();
}

class _RTChaudiereFormState extends State<RTChaudiereForm> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  // Client & Info
  final Map<String, TextEditingController> _controllers = {
    'numClient': TextEditingController(),
    'nomClient': TextEditingController(),
    'adresseFact': TextEditingController(),
    'email': TextEditingController(),
    'telFixe': TextEditingController(),
    'telMobile': TextEditingController(),
    'rtName': TextEditingController(),
    'nomRT': TextEditingController(),
    'technicien': TextEditingController(),
    'matricule': TextEditingController(),
    'adresseInst': TextEditingController(),
    'surface': TextEditingController(),
    'nbOccupants': TextEditingController(),
    'anneeConst': TextEditingController(),
    'pieces': TextEditingController(),
    'marqueActuelle': TextEditingController(),
    'modeleActuel': TextEditingController(),
    'puissance': TextEditingController(),
    'largeur': TextEditingController(),
    'hauteur': TextEditingController(),
    'profondeur': TextEditingController(),
  };

  // --- BOOLEANS / DROPDOWNS ---
  bool _isAppartement = false;
  bool _isPavillon = false;
  bool _amiante = false;
  bool _accordCoPro = false;
  bool _chauffageSeul = false;
  bool _mixteInstantanee = true;
  bool _avecBallon = false;
  bool _radiateur = true;
  bool _plancherChauffant = false;

  // Conformité (Simplified list for example)
  final Map<String, bool> _conformite = {
    'compteur20m': false,
    'organeCoupure': false,
    'volume15m3': false,
    'ameneeAir': true,
    'terre': true,
    'flexiblePerime': false,
  };

  // --- Réglementation Gaz (Oui/Non/NC)
  String _vasoPresent = 'NC';
  String _vasoConforme = 'NC';
  String _vasoObservation = '';
  String _roaiPresent = 'NC';
  String _roaiConforme = 'NC';
  String _roaiObservation = '';
  String _typeHotte = 'Non';
  String _ventilationConforme = 'NC';
  String _ventilationObservation = '';
  String _vmcPresent = 'NC';
  String _vmcConforme = 'NC';
  String _vmcObservation = '';
  String _detecteurCO = 'NC';
  String _detecteurGaz = 'NC';
  String _detecteursConformes = 'NC';
  final _distanceFenetreController = TextEditingController();
  final _distancePorteController = TextEditingController();
  final _distanceEvacuationController = TextEditingController();
  final _distanceAspirationController = TextEditingController();

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _distanceFenetreController.dispose();
    _distancePorteController.dispose();
    _distanceEvacuationController.dispose();
    _distanceAspirationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique Chaudière'),
        elevation: 4,
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
                _buildTextField('adresseFact', 'Adresse de facturation', maxLines: 2),
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('telMobile', 'Téléphone mobile', keyboardType: TextInputType.phone),
              ]),
              _buildSection('Environnement', [
                SwitchListTile(
                  title: const Text('Appartement'),
                  value: _isAppartement,
                  onChanged: (v) => setState(() => _isAppartement = v),
                ),
                SwitchListTile(
                  title: const Text('Pavillon'),
                  value: _isPavillon,
                  onChanged: (v) => setState(() => _isPavillon = v),
                ),
                _buildTextField('surface', 'Surface (m2)', keyboardType: TextInputType.number),
                _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
              ]),
              _buildSection('Équipement en place', [
                _buildTextField('marqueActuelle', 'Marque'),
                _buildTextField('modeleActuel', 'Modèle'),
                Row(
                  children: [
                    Expanded(child: _buildTextField('puissance', 'Puissance (W)')),
                    Expanded(child: _buildTextField('largeur', 'Largeur (cm)')),
                  ],
                ),
                CheckboxListTile(
                  title: const Text('Chauffage seul'),
                  value: _chauffageSeul,
                  onChanged: (v) => setState(() => _chauffageSeul = v!),
                ),
                CheckboxListTile(
                  title: const Text('Mixte instantanée'),
                  value: _mixteInstantanee,
                  onChanged: (v) => setState(() => _mixteInstantanee = v!),
                ),
              ]),
              _buildSection('Conformité', _conformite.keys.map((key) {
                return CheckboxListTile(
                  title: Text(_getConformiteLabel(key)),
                  value: _conformite[key],
                  onChanged: (v) => setState(() => _conformite[key] = v!),
                );
              }).toList()),
              _buildSection('Réglementation Gaz', [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Réponses: Oui / Non / NC', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _vasoPresent,
                        decoration: const InputDecoration(labelText: 'Réglette VASO présente'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _vasoPresent = v!),
                      ),
                      if (_vasoPresent == 'Oui') ...[
                        DropdownButtonFormField<String>(
                          value: _vasoConforme,
                          decoration: const InputDecoration(labelText: 'VASO conforme'),
                          items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                          onChanged: (v) => setState(() => _vasoConforme = v!),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Observations VASO'),
                          maxLines: 2,
                          onChanged: (v) => _vasoObservation = v,
                        ),
                      ],

                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _roaiPresent,
                        decoration: const InputDecoration(labelText: 'Robinet ROAI présent'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _roaiPresent = v!),
                      ),
                      if (_roaiPresent == 'Oui') ...[
                        DropdownButtonFormField<String>(
                          value: _roaiConforme,
                          decoration: const InputDecoration(labelText: 'ROAI conforme'),
                          items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                          onChanged: (v) => setState(() => _roaiConforme = v!),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Observations ROAI'),
                          maxLines: 2,
                          onChanged: (v) => _roaiObservation = v,
                        ),
                      ],

                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _typeHotte,
                        decoration: const InputDecoration(labelText: 'Type hotte'),
                        items: const [DropdownMenuItem(value: 'Non', child: Text('Pas de hotte')), DropdownMenuItem(value: 'SimpleFlux', child: Text('Hotte simple flux')), DropdownMenuItem(value: 'DoubleFlux', child: Text('Hotte double flux'))],
                        onChanged: (v) => setState(() => _typeHotte = v!),
                      ),
                      if (_typeHotte != 'Non') ...[
                        DropdownButtonFormField<String>(
                          value: _ventilationConforme,
                          decoration: const InputDecoration(labelText: 'Ventilation conforme'),
                          items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                          onChanged: (v) => setState(() => _ventilationConforme = v!),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Observations ventilation'),
                          maxLines: 2,
                          onChanged: (v) => _ventilationObservation = v,
                        ),
                      ],

                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _vmcPresent,
                        decoration: const InputDecoration(labelText: 'VMC présente'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _vmcPresent = v!),
                      ),
                      if (_vmcPresent == 'Oui') ...[
                        DropdownButtonFormField<String>(
                          value: _vmcConforme,
                          decoration: const InputDecoration(labelText: 'VMC conforme'),
                          items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                          onChanged: (v) => setState(() => _vmcConforme = v!),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Observations VMC'),
                          maxLines: 2,
                          onChanged: (v) => _vmcObservation = v,
                        ),
                      ],

                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _detecteurCO,
                        decoration: const InputDecoration(labelText: 'Détecteur CO présent'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _detecteurCO = v!),
                      ),
                      DropdownButtonFormField<String>(
                        value: _detecteurGaz,
                        decoration: const InputDecoration(labelText: 'Détecteur Gaz présent'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _detecteurGaz = v!),
                      ),
                      if (_detecteurCO == 'Oui' && _detecteurGaz == 'Oui') ...[
                        DropdownButtonFormField<String>(
                          value: _detecteursConformes,
                          decoration: const InputDecoration(labelText: 'Détecteurs conformes'),
                          items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                          onChanged: (v) => setState(() => _detecteursConformes = v!),
                        ),
                      ],

                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _distanceFenetreController,
                        decoration: const InputDecoration(labelText: 'Distance fenêtres (cm)'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _distancePorteController,
                        decoration: const InputDecoration(labelText: 'Distance portes (cm)'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _distanceEvacuationController,
                        decoration: const InputDecoration(labelText: 'Distance évacuations (cm)'),
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: _distanceAspirationController,
                        decoration: const InputDecoration(labelText: 'Distance aspirations (cm)'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('ENREGISTRER LE RELEVÉ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
      child: Column(
        children: [
          const Icon(Icons.plumbing, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            'RELEVÉ TECHNIQUE',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: title == 'Client',
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        children: children,
      ),
    );
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  String _getConformiteLabel(String key) {
    switch (key) {
      case 'compteur20m': return 'Compteur à plus de 20m';
      case 'organeCoupure': return 'Organe de coupure gaz accessible';
      case 'volume15m3': return 'Volume supérieur à 15m3';
      case 'ameneeAir': return 'Amenée d\'air conforme';
      case 'terre': return 'Présence de la terre';
      case 'flexiblePerime': return 'Flexible gaz périmé';
      default: return key;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logic to save or export data
      _performExports();
    }
  }

  Future<void> _performExports() async {
    await _saveReglementationToPrefs();

    // Construire les sections pour le PDF
    final Map<String, Map<String, String>> sections = {
      'Client': {
        'Numéro client': _controllers['numClient']?.text ?? '',
        'Nom client': _controllers['nomClient']?.text ?? '',
        'Adresse facturation': _controllers['adresseFact']?.text ?? '',
        'Email': _controllers['email']?.text ?? '',
        'Téléphone': _controllers['telMobile']?.text ?? '',
      },
      'Environnement': {
        'Appartement': _isAppartement ? 'Oui' : 'Non',
        'Pavillon': _isPavillon ? 'Oui' : 'Non',
        'Surface (m2)': _controllers['surface']?.text ?? '',
        'Année construction': _controllers['anneeConst']?.text ?? '',
      },
      'Équipement': {
        'Marque': _controllers['marqueActuelle']?.text ?? '',
        'Modèle': _controllers['modeleActuel']?.text ?? '',
        'Puissance (W)': _controllers['puissance']?.text ?? '',
      },
      'Conformité': _conformite.map((k, v) => MapEntry(_getConformiteLabel(k), v ? 'Oui' : 'Non')),
    };

    // Générer le PDF (le générateur ajoutera la section "Réglementation Gaz" depuis SharedPreferences)
    try {
      final pdfFile = await PDFGeneratorService.genererReleveTechnique(donnees: sections, typeReleve: 'chaudiere');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF généré: ${pdfFile.path}')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur génération PDF')));
    }

    // Construire le modèle ReleveTechnique et exporter en JSON
    final diagnosticGazMap = await JSONExporter.collectDiagnosticGaz();
    final releve = ReleveTechnique(
      clientNumber: _controllers['numClient']?.text,
      clientName: _controllers['nomClient']?.text,
      clientEmail: _controllers['email']?.text,
      clientPhone: _controllers['telMobile']?.text,
      chantierAddress: _controllers['adresseInst']?.text,
      equipementType: _controllers['modeleActuel']?.text,
      surface: _controllers['surface']?.text,
      occupants: _controllers['nbOccupants']?.text,
      anneeConstruction: _controllers['anneeConst']?.text,
      equipementMarque: _controllers['marqueActuelle']?.text,
      equipementAnnee: _controllers['modeleActuel']?.text,
      diagnosticGaz: diagnosticGazMap,
      // Réglementation
      vasoPresent: _vasoPresent,
      vasoConforme: _vasoConforme,
      vasoObservation: _vasoObservation,
      roaiPresent: _roaiPresent,
      roaiConforme: _roaiConforme,
      roaiObservation: _roaiObservation,
      typeHotte: _typeHotte,
      ventilationConforme: _ventilationConforme,
      ventilationObservation: _ventilationObservation,
      vmcPresent: _vmcPresent,
      vmcConforme: _vmcConforme,
      vmcObservation: _vmcObservation,
      detecteurCO: _detecteurCO,
      detecteurGaz: _detecteurGaz,
      detecteursConformes: _detecteursConformes,
      distanceFenetre: _distanceFenetreController.text,
      distancePorte: _distancePorteController.text,
      distanceEvacuation: _distanceEvacuationController.text,
      distanceAspiration: _distanceAspirationController.text,
    );

    try {
      final jsonFile = await JSONExporter.exportReleveTechniqueJson(releve, 'chaudiere');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('JSON exporté: ${jsonFile.path}')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur export JSON')));
    }
  }

  Future<void> _saveReglementationToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vasoPresent', _vasoPresent);
    await prefs.setString('vasoConforme', _vasoConforme);
    await prefs.setString('vasoObservation', _vasoObservation);

    await prefs.setString('roaiPresent', _roaiPresent);
    await prefs.setString('roaiConforme', _roaiConforme);
    await prefs.setString('roaiObservation', _roaiObservation);

    await prefs.setString('typeHotte', _typeHotte);
    await prefs.setString('ventilationConforme', _ventilationConforme);
    await prefs.setString('ventilationObservation', _ventilationObservation);

    await prefs.setString('vmcPresent', _vmcPresent);
    await prefs.setString('vmcConforme', _vmcConforme);
    await prefs.setString('vmcObservation', _vmcObservation);

    await prefs.setString('detecteurCO', _detecteurCO);
    await prefs.setString('detecteurGaz', _detecteurGaz);
    await prefs.setString('detecteursConformes', _detecteursConformes);

    await prefs.setString('distanceFenetre', _distanceFenetreController.text);
    await prefs.setString('distancePorte', _distancePorteController.text);
    await prefs.setString('distanceEvacuation', _distanceEvacuationController.text);
    await prefs.setString('distanceAspiration', _distanceAspirationController.text);
  }
}
