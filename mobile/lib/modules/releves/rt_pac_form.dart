import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chauffage_expert/services/pdf_generator.dart';
import 'package:chauffage_expert/services/json_exporter.dart';
import 'package:chauffage_expert/modules/releves/releve_technique_model.dart';

class RTPACForm extends StatefulWidget {
  const RTPACForm({super.key});

  @override
  State<RTPACForm> createState() => _RTPACFormState();
}

class _RTPACFormState extends State<RTPACForm> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  final Map<String, TextEditingController> _controllers = {
    'numClient': TextEditingController(),
    'nomClient': TextEditingController(),
    'adresseFact': TextEditingController(),
    'surfaceChauffer': TextEditingController(),
    'anneeConst': TextEditingController(),
    'nbRadiateurs': TextEditingController(),
    'consoFuel': TextEditingController(),
    'tension': TextEditingController(),
    'puissanceAbo': TextEditingController(),
    'distTableau': TextEditingController(),
    'deperditionTotale': TextEditingController(),
    'tauxCouverture': TextEditingController(),
  };

  // --- STATES ---
  bool _amiante = false;
  bool _ecsIndependante = false;
  bool _tableauConforme = false;
  bool _besoinTableauSupp = false;
  bool _uiEmplacementChaudiere = true;
  bool _vanne3Voies = false;
  bool _ballonDecouplage = false;
  String _typeEmetteur = 'Radiateur fonte';
  // Réglementation Gaz
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
        title: const Text('Relevé Technique PAC'),
        backgroundColor: Colors.indigo,
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
              ]),
              _buildSection('Description de l\'habitation', [
                _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Repérage amiante établi'),
                  value: _amiante,
                  onChanged: (v) => setState(() => _amiante = v),
                ),
                _buildTextField('surfaceChauffer', 'Surface à chauffer (m2)', keyboardType: TextInputType.number),
              ]),
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
                      ],
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _roaiPresent,
                        decoration: const InputDecoration(labelText: 'Robinet ROAI présent'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _roaiPresent = v!),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _typeHotte,
                        decoration: const InputDecoration(labelText: 'Type hotte'),
                        items: const [DropdownMenuItem(value: 'Non', child: Text('Pas de hotte')), DropdownMenuItem(value: 'SimpleFlux', child: Text('Hotte simple flux')), DropdownMenuItem(value: 'DoubleFlux', child: Text('Hotte double flux'))],
                        onChanged: (v) => setState(() => _typeHotte = v!),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _vmcPresent,
                        decoration: const InputDecoration(labelText: 'VMC présente'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _vmcPresent = v!),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _detecteurCO,
                        decoration: const InputDecoration(labelText: 'Détecteur CO présent'),
                        items: const [DropdownMenuItem(value: 'Oui', child: Text('Oui')), DropdownMenuItem(value: 'Non', child: Text('Non')), DropdownMenuItem(value: 'NC', child: Text('NC'))],
                        onChanged: (v) => setState(() => _detecteurCO = v!),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _distanceFenetreController,
                        decoration: const InputDecoration(labelText: 'Distance fenêtres (cm)'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ]),
              _buildSection('Volumes & Émetteurs', [
                DropdownButtonFormField<String>(
                  value: _typeEmetteur,
                  decoration: const InputDecoration(labelText: 'Type d\'émetteur zone 1', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: ['Radiateur fonte', 'Radiateur acier', 'Plancher chauffant'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _typeEmetteur = v!),
                ),
                _buildTextField('nbRadiateurs', 'Nombre total de radiateurs', keyboardType: TextInputType.number),
              ]),
              _buildSection('Système Actuel', [
                SwitchListTile(
                  title: const Text('Production ECS indépendante'),
                  value: _ecsIndependante,
                  onChanged: (v) => setState(() => _ecsIndependante = v),
                ),
                _buildTextField('consoFuel', 'Consommation Fuel annuelle (L)', keyboardType: TextInputType.number),
              ]),
              _buildSection('Caractéristiques Électriques', [
                SwitchListTile(
                  title: const Text('Tableau électrique conforme'),
                  value: _tableauConforme,
                  onChanged: (v) => setState(() => _tableauConforme = v),
                ),
                _buildTextField('tension', 'Mesure de la tension (V)', keyboardType: TextInputType.number),
                _buildTextField('puissanceAbo', 'Puissance abonnement (kVA)', keyboardType: TextInputType.number),
                CheckboxListTile(
                  title: const Text('Besoin d\'un tableau supplémentaire'),
                  value: _besoinTableauSupp,
                  onChanged: (v) => setState(() => _besoinTableauSupp = v!),
                ),
              ]),
              _buildSection('Hydraulique', [
                CheckboxListTile(
                  title: const Text('Vanne 3 voies'),
                  value: _vanne3Voies,
                  onChanged: (v) => setState(() => _vanne3Voies = v!),
                ),
                CheckboxListTile(
                  title: const Text('Présence ballon découplage/tampon'),
                  value: _ballonDecouplage,
                  onChanged: (v) => setState(() => _ballonDecouplage = v!),
                ),
              ]),
              _buildSection('Dimensionnement', [
                _buildTextField('deperditionTotale', 'Déperdition totale (kW)', keyboardType: TextInputType.number),
                _buildTextField('tauxCouverture', 'Taux de couverture (%)', keyboardType: TextInputType.number),
              ]),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performExports();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('ENREGISTRER LE RELEVÉ PAC', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _performExports() async {
    await _saveReglementationToPrefs();

    final Map<String, Map<String, String>> sections = {
      'Client': {
        'Numéro client': _controllers['numClient']?.text ?? '',
        'Nom client': _controllers['nomClient']?.text ?? '',
        'Adresse facturation': _controllers['adresseFact']?.text ?? '',
      },
      'Habitation': {
        'Année construction': _controllers['anneeConst']?.text ?? '',
        'Surface à chauffer': _controllers['surfaceChauffer']?.text ?? '',
      },
      'PAC': {
        'Type émetteur': _typeEmetteur,
        'Nb radiateurs': _controllers['nbRadiateurs']?.text ?? '',
      },
    };

    try {
      final pdfFile = await PDFGeneratorService.genererReleveTechnique(donnees: sections, typeReleve: 'pac');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF généré: ${pdfFile.path}')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur génération PDF')));
    }

    final diagnosticGazMap = await JSONExporter.collectDiagnosticGaz();
    final releve = ReleveTechnique(
      clientNumber: _controllers['numClient']?.text,
      clientName: _controllers['nomClient']?.text,
      chantierAddress: _controllers['adresseFact']?.text,
      anneeConstruction: _controllers['anneeConst']?.text,
      surface: _controllers['surfaceChauffer']?.text,
      equipementType: _typeEmetteur,
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
    );

    try {
      final jsonFile = await JSONExporter.exportReleveTechniqueJson(releve, 'pac');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('JSON exporté: ${jsonFile.path}')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur export JSON')));
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Column(
        children: [
          Icon(Icons.heat_pump, size: 50, color: Colors.indigo),
          SizedBox(height: 10),
          Text('RELEVÉ TECHNIQUE PAC', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(thickness: 2, color: Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
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
