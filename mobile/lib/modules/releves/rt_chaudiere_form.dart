import 'package:flutter/material.dart';
import 'package:chauffageexpert/services/pdf_generator.dart';
import 'package:chauffageexpert/services/json_exporter.dart';
import 'package:chauffageexpert/modules/releves/releve_technique_model.dart';
import 'package:chauffageexpert/modules/releves/mixins/reglementation_gaz_mixin.dart';
import 'package:chauffageexpert/modules/releves/widgets/common_form_widgets.dart';

class RTChaudiereForm extends StatefulWidget {
  const RTChaudiereForm({super.key});

  @override
  State<RTChaudiereForm> createState() => _RTChaudiereFormState();
}

class _RTChaudiereFormState extends State<RTChaudiereForm> with ReglementationGazMixin {
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
  // some fields reserved for future UI use
  // ignore: unused_field
  final bool _amiante = false;
  // ignore: unused_field
  final bool _accordCoPro = false;
  bool _chauffageSeul = false;
  bool _mixteInstantanee = true;
  // ignore: unused_field
  final bool _avecBallon = false;
  // ignore: unused_field
  final bool _radiateur = true;
  // ignore: unused_field
  final bool _plancherChauffant = false;

  // Conformité (Simplified list for example)
  final Map<String, bool> _conformite = {
    'compteur20m': false,
    'organeCoupure': false,
    'volume15m3': false,
    'ameneeAir': true,
    'terre': true,
    'flexiblePerime': false,
  };

  // --- Réglementation Gaz (maintenant dans ReglementationGazMixin) ---

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
        title: const Text('Relevé Technique Chaudière'),
        elevation: 4,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CommonFormWidgets.buildHeader(
                icon: Icons.plumbing,
                title: 'RELEVÉ TECHNIQUE',
                color: Colors.blue,
                context: context,
              ),
              CommonFormWidgets.buildSection(
                title: 'Client',
                color: Colors.blue,
                initiallyExpanded: true,
                children: [
                _buildTextField('numClient', 'Numéro client (gazelle)'),
                _buildTextField('nomClient', 'Nom du client'),
                _buildTextField('adresseFact', 'Adresse de facturation', maxLines: 2),
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('telMobile', 'Téléphone mobile', keyboardType: TextInputType.phone),
              ]),
              CommonFormWidgets.buildSection(
                title: 'Environnement',
                color: Colors.blue,
                children: [
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
              CommonFormWidgets.buildSection(
                title: 'Équipement en place',
                color: Colors.blue,
                children: [
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
              CommonFormWidgets.buildSection(
                title: 'Conformité',
                color: Colors.blue,
                children: _conformite.keys.map((key) {
                return CheckboxListTile(
                  title: Text(_getConformiteLabel(key)),
                  value: _conformite[key],
                  onChanged: (v) => setState(() => _conformite[key] = v!),
                );              }).toList()),
              CommonFormWidgets.buildSection(
                title: 'Réglementation Gaz',
                color: Colors.blue,
                children: [buildSectionReglementation(showAllFields: true)],
              ),
              ),
              CommonFormWidgets.buildSubmitButton(
                onPressed: _submitForm,
                label: 'ENREGISTRER LE RELEVÉ',
                icon: Icons.save,
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return CommonFormWidgets.buildTextField(
      controller: _controllers[key]!,
      label: label,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
    await saveReglementationToPrefs();

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
      final pdfFile = await PDFGeneratorService.instance.genererReleveTechnique(donnees: sections, typeReleve: 'chaudiere');
      if (mounted) {
        CommonFormWidgets.showSuccessSnackBar(context, 'PDF généré: ${pdfFile.path}');
      }
    } catch (e) {
      if (mounted) {
        CommonFormWidgets.showErrorSnackBar(context, 'Erreur génération PDF');
      }
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
      distancePorte: distancePorteController.text,
      distanceEvacuation: distanceEvacuationController.text,
      distanceAspiration: distanceAspirationController.text,
    );

    try {
      final jsonFile = await JSONExporter.exportReleveTechniqueJson(releve, 'chaudiere');
      if (mounted) {
        CommonFormWidgets.showSuccessSnackBar(context, 'JSON exporté: ${jsonFile.path}');
      }
    } catch (e) {
      if (mounted) {
        CommonFormWidgets.showErrorSnackBar(context, 'Erreur export JSON');
      }
    }
  }
}
