import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pdf_generator_service.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import '../../utils/mixins/form_state_mixin.dart';
import '../../utils/mixins/controller_dispose_mixin.dart';
import '../../utils/mixins/snackbar_mixin.dart';
import '../../utils/mixins/measurement_photo_storage_mixin.dart';
import 'widgets/measurement_photo_widget.dart';

class ReglementationGazScreen extends StatefulWidget {
  const ReglementationGazScreen({super.key});

  @override
  State<ReglementationGazScreen> createState() => _ReglementationGazScreenState();
}

class _ReglementationGazScreenState extends State<ReglementationGazScreen>
    with FormStateMixin, ControllerDisposeMixin, SnackBarMixin, MeasurementPhotoStorageMixin {
  Map<String, dynamic>? _qualigazCodes;
  Map<String, String> _selectedCodes = {};
  Map<String, String> _observations = {};
  Map<String, List<File>> _photosParCode = {}; // Photos par code Qualigaz

  // Données de l'installation
  late final _adresseController = registerController(TextEditingController());
  late final _nomClientController = registerController(TextEditingController());
  late final _technicienController = registerController(TextEditingController());

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
    _chargerCodesQualigaz();
  }

  Future<void> _chargerCodesQualigaz() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/qualigaz_codes.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      setState(() {
        _qualigazCodes = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement codes Qualigaz: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _chargerDonnees() async {
    final adresse = await loadFormValue('adresse_installation');
    final nomClient = await loadFormValue('nom_client');
    final technicien = await loadFormValue('technicien_reglementation');
    final codesJson = await loadFormValue('selected_qualigaz_codes');
    final observationsJson = await loadFormValue('qualigaz_observations');

    setState(() {
      _adresseController.text = adresse ?? '';
      _nomClientController.text = nomClient ?? '';
      _technicienController.text = technicien ?? '';

      // Charger les codes sélectionnés
      if (codesJson != null && codesJson.isNotEmpty) {
        _selectedCodes = Map<String, String>.from(json.decode(codesJson));
      }

      // Charger les observations
      if (observationsJson != null && observationsJson.isNotEmpty) {
        _observations = Map<String, String>.from(json.decode(observationsJson));
      }
    });
    
    // Charger les photos pour chaque code
    if (_selectedCodes.isNotEmpty) {
      for (final codeId in _selectedCodes.keys) {
        final photos = await loadMeasurementPhotos('reglementation_gaz_$codeId');
        if (photos.isNotEmpty) {
          setState(() {
            _photosParCode[codeId] = photos;
          });
        }
      }
    }
  }

  Future<void> _sauvegarderDonnees() async {
    await saveFormValue('adresse_installation', _adresseController.text);
    await saveFormValue('nom_client', _nomClientController.text);
    await saveFormValue('technicien_reglementation', _technicienController.text);
    await saveFormValue('selected_qualigaz_codes', json.encode(_selectedCodes));
    await saveFormValue('qualigaz_observations', json.encode(_observations));
    
    // Sauvegarder les photos
    await saveAllMeasurementPhotos(_photosParCode);
  }

  void _selectionnerCode(String codeId, String code) {
    setState(() {
      if (_selectedCodes[codeId] == code) {
        _selectedCodes.remove(codeId);
      } else {
        _selectedCodes[codeId] = code;
      }
    });
    _sauvegarderDonnees();
  }

  void _ajouterObservation(String codeId, String observation) {
    setState(() {
      _observations[codeId] = observation;
    });
    _sauvegarderDonnees();
  }

  String _getClassificationGlobale() {
    if (_selectedCodes.isEmpty) return 'DGI';

    final codes = _qualigazCodes?['codes_qualigaz'] ?? {};
    String classification = 'DGI';

    for (final codeId in _selectedCodes.keys) {
      final codeInfo = codes[codeId];
      if (codeInfo != null) {
        final anomalyType = codeInfo['anomaly_type'];
        if (anomalyType == 'A1') return 'A1';
        if (anomalyType == 'A2' && classification != 'A1') classification = 'A2';
      }
    }

    return classification;
  }

  Color _getColorForAnomalyType(String type) {
    switch (type) {
      case 'DGI': return Colors.green;
      case 'CNV': return Colors.blue;
      case 'A2': return Colors.orange;
      case 'A1': return Colors.red;
      default: return Colors.grey;
    }
  }

  Future<void> _genererPDF() async {
    if (_qualigazCodes == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final technicien = _technicienController.text.isNotEmpty ? _technicienController.text : 'Technicien';
      final entreprise = prefs.getString('entreprise') ?? 'Entreprise';

      final controles = {
        'codes_qualigaz': _selectedCodes,
        'observations': _observations,
        'classification_globale': _getClassificationGlobale(),
        'adresse_installation': _adresseController.text,
        'nom_client': _nomClientController.text,
      };

      final pdfFile = await PdfGeneratorService.generateReglementationGazPdf(
        technicien: technicien,
        entreprise: entreprise,
        dateControle: DateTime.now(),
        controles: controles,
        observations: 'Rapport généré avec codes Qualigaz officiels',
      );

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Rapport de contrôle régulation gaz',
      );

      if (!mounted) return;
      showSuccess('PDF généré et partagé avec succès');
    } catch (e) {
      if (!mounted) return;
      showError('Erreur lors de la génération du PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final categories = _qualigazCodes?['categories'] as Map<String, dynamic>? ?? {};
    final classificationGlobale = _getClassificationGlobale();

    return DefaultTabController(
      length: categories.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Réglementation Gaz - Qualigaz'),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getColorForAnomalyType(classificationGlobale),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                classificationGlobale,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _genererPDF,
              tooltip: 'Générer PDF',
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              const Tab(text: 'Installation'),
              ...categories.keys.map((category) => Tab(text: category)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet Installation
            _buildInstallationTab(),
            // Onglets par catégorie
            ...categories.keys.map((category) => _buildCategoryTab(category, categories[category] as List<dynamic>)),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations de l\'installation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomClientController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du client',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _adresseController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse d\'installation',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _technicienController,
                    decoration: const InputDecoration(
                      labelText: 'Technicien',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Résumé des contrôles
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résumé des contrôles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getColorForAnomalyType(_getClassificationGlobale()).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getColorForAnomalyType(_getClassificationGlobale()),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Classification globale: ${_getClassificationGlobale()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getColorForAnomalyType(_getClassificationGlobale()),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_selectedCodes.length} point(s) de contrôle sélectionné(s)',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String categoryName, List<dynamic> codeIds) {
    final codes = _qualigazCodes?['codes_qualigaz'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                categoryName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),

          ...codeIds.map((codeId) {
            final codeInfo = codes[codeId.toString()];
            if (codeInfo == null) return const SizedBox.shrink();

            final isSelected = _selectedCodes.containsKey(codeId.toString());
            final anomalyType = codeInfo['anomaly_type'] as String;
            final color = _getColorForAnomalyType(anomalyType);

            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            codeId.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            codeInfo['description'] as String,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) => _selectionnerCode(codeId.toString(), codeId.toString()),
                        ),
                      ],
                    ),

                    if (isSelected) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type d\'anomalie: $anomalyType',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: _observations[codeId.toString()] ?? '',
                              decoration: const InputDecoration(
                                labelText: 'Observations',
                                border: OutlineInputBorder(),
                                hintText: 'Détails de l\'anomalie observée...',
                              ),
                              maxLines: 3,
                              onChanged: (value) => _ajouterObservation(codeId.toString(), value),
                            ),
                            const SizedBox(height: 12),
                            MeasurementPhotoWidget(
                              title: '📸 Photos de la non-conformité',
                              initialPhotos: _photosParCode[codeId.toString()] ?? [],
                              onPhotosChanged: (photos) {
                                setState(() {
                                  _photosParCode[codeId.toString()] = photos;
                                });
                                _sauvegarderDonnees();
                              },
                              maxPhotos: 5,
                              recommended: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}