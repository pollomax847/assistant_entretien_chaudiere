import 'package:flutter/material.dart';
import 'package:chauffageexpert/services/pdf_generator.dart';
import 'package:chauffageexpert/services/json_exporter.dart';
import 'package:chauffageexpert/modules/releves/releve_technique_model.dart';
import 'package:chauffageexpert/modules/releves/mixins/reglementation_gaz_mixin.dart';
import 'package:chauffageexpert/modules/releves/widgets/common_form_widgets.dart';

class RTPACForm extends StatefulWidget {
  const RTPACForm({super.key});

  @override
  State<RTPACForm> createState() => _RTPACFormState();
}

class _RTPACFormState extends State<RTPACForm> with ReglementationGazMixin {
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
  // ignore: unused_field
  final bool _uiEmplacementChaudiere = true;
  bool _vanne3Voies = false;
  bool _ballonDecouplage = false;
  String _typeEmetteur = 'Radiateur fonte';
  // Réglementation Gaz (maintenant dans ReglementationGazMixin)

  @override
  void initState() {
    super.initState();
    loadReglementationQuestions();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    disposeReglementationControllers();
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
              CommonFormWidgets.buildHeader(
                icon: Icons.heat_pump,
                title: 'RELEVÉ TECHNIQUE PAC',
                color: Colors.indigo,
                context: context,
              ),
              CommonFormWidgets.buildSection(
                title: 'Client',
                color: Colors.indigo,
                children: [
                _buildTextField('numClient', 'Numéro client (gazelle)'),
                _buildTextField('nomClient', 'Nom du client'),
                _buildTextField('adresseFact', 'Adresse de facturation', maxLines: 2),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Description de l\'habitation',
                color: Colors.indigo,
                children: [
                _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Repérage amiante établi'),
                  value: _amiante,
                  onChanged: (v) => setState(() => _amiante = v),
                ),
                _buildTextField('surfaceChauffer', 'Surface à chauffer (m2)', keyboardType: TextInputType.number),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Réglementation Gaz',
                color: Colors.indigo,
                children: [buildSectionReglementation(showAllFields: false)],
              ),
              CommonFormWidgets.buildSection(
                title: 'Volumes & Émetteurs',
                color: Colors.indigo,
                children: [
                DropdownButtonFormField<String>(
                  initialValue: _typeEmetteur,
                  decoration: const InputDecoration(labelText: 'Type d\'émetteur zone 1', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: ['Radiateur fonte', 'Radiateur acier', 'Plancher chauffant'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _typeEmetteur = v!),
                ),
                _buildTextField('nbRadiateurs', 'Nombre total de radiateurs', keyboardType: TextInputType.number),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Système Actuel',
                color: Colors.indigo,
                children: [
                SwitchListTile(
                  title: const Text('Production ECS indépendante'),
                  value: _ecsIndependante,
                  onChanged: (v) => setState(() => _ecsIndependante = v),
                ),
                _buildTextField('consoFuel', 'Consommation Fuel annuelle (L)', keyboardType: TextInputType.number),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Caractéristiques Électriques',
                color: Colors.indigo,
                children: [
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
              CommonFormWidgets.buildSection(
                title: 'Hydraulique',
                color: Colors.indigo,
                children: [
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
              CommonFormWidgets.buildSection(
                title: 'Dimensionnement',
                color: Colors.indigo,
                children: [
                _buildTextField('deperditionTotale', 'Déperdition totale (kW)', keyboardType: TextInputType.number),
                _buildTextField('tauxCouverture', 'Taux de couverture (%)', keyboardType: TextInputType.number),
              ]),
              CommonFormWidgets.buildSubmitButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _performExports();
                  }
                },
                label: 'ENREGISTRER LE RELEVÉ PAC',
                backgroundColor: Colors.indigo,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performExports() async {
    await saveReglementationToPrefs();

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
      final pdfFile = await PDFGeneratorService.instance.genererReleveTechnique(donnees: sections, typeReleve: 'pac');
      if (mounted) CommonFormWidgets.showSuccessSnackBar(context, 'PDF généré: ${pdfFile.path}');
    } catch (e) {
      if (mounted) CommonFormWidgets.showErrorSnackBar(context, 'Erreur génération PDF');
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
      vasoPresent: vasoPresent,
      vasoConforme: vasoConforme,
      vasoObservation: vasoObservation,
      roaiPresent: roaiPresent,
      roaiConforme: roaiConforme,
      roaiObservation: roaiObservation,
      typeHotte: typeHotte,
      ventilationConforme: ventilationConforme,
      ventilationObservation: ventilationObservation,
      vmcPresent: vmcPresent,
      vmcConforme: vmcConforme,
      vmcObservation: vmcObservation,
      detecteurCO: detecteurCO,
      detecteurGaz: detecteurGaz,
      detecteursConformes: detecteursConformes,
      distanceFenetre: distanceFenetreController.text,
    );

    try {
      final jsonFile = await JSONExporter.exportReleveTechniqueJson(releve, 'pac');
      if (mounted) CommonFormWidgets.showSuccessSnackBar(context, 'JSON exporté: ${jsonFile.path}');
    } catch (e) {
      if (mounted) CommonFormWidgets.showErrorSnackBar(context, 'Erreur export JSON');
    }
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return CommonFormWidgets.buildTextField(
      controller: _controllers[key]!,
      label: label,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
