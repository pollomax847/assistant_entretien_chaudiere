// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pdf_generator_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/mixins/mixins.dart';

class PuissanceChauffageExpertScreen extends StatefulWidget {
  const PuissanceChauffageExpertScreen({super.key});

  @override
  State<PuissanceChauffageExpertScreen> createState() => _PuissanceChauffageExpertScreenState();
}

class _PuissanceChauffageExpertScreenState extends State<PuissanceChauffageExpertScreen>
    with
        SingleTickerProviderStateMixin,
        AnimationStyleMixin,
        ControllerDisposeMixin,
        SnackBarMixin,
        SharedPreferencesMixin {
  bool _isExpertMode = false;
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  // Données générales
  late final _surfaceController = registerController(TextEditingController(text: '100'));
  late final _hauteurController = registerController(TextEditingController(text: '2.5'));
  late final _nbOccupantsController = registerController(TextEditingController(text: '4'));
  late final _tempExterieureController = registerController(TextEditingController(text: '-5'));
  late final _tempInterieureController = registerController(TextEditingController(text: '19'));

  // Coefficients d'isolation (valeurs par défaut)
  late final _coeffMurController = registerController(TextEditingController(text: '0.36'));
  late final _coeffToitController = registerController(TextEditingController(text: '0.22'));
  late final _coeffPlancherController = registerController(TextEditingController(text: '0.25'));
  late final _coeffFenetresController = registerController(TextEditingController(text: '2.5'));

  // Surfaces des éléments
  late final _surfaceMurController = registerController(TextEditingController(text: '150'));
  late final _surfaceToitController = registerController(TextEditingController(text: '100'));
  late final _surfacePlancherController = registerController(TextEditingController(text: '100'));
  late final _surfaceFenetresController = registerController(TextEditingController(text: '20'));

  // Résultats
  double? _deperditionsTotales;
  double? _puissanceChauffage;
  double? _puissanceAvecSecurite;
  String? _typeAppareilRecommande;
  Map<String, double>? _detailDeperditions;

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _chargerDonnees();
  }

  @override
  void dispose() {
    _introController.dispose();
    disposeControllers();
    super.dispose();
  }

  Future<void> _chargerDonnees() async {
    _surfaceController.text = await loadString('surface_habitable') ?? '100';
    _hauteurController.text = await loadString('hauteur_sous_plafond') ?? '2.5';
    _nbOccupantsController.text = await loadString('nb_occupants') ?? '4';
    _tempExterieureController.text = await loadString('temp_exterieure') ?? '-5';
    _tempInterieureController.text = await loadString('temp_interieure') ?? '19';

    _coeffMurController.text = await loadString('coeff_mur') ?? '0.36';
    _coeffToitController.text = await loadString('coeff_toit') ?? '0.22';
    _coeffPlancherController.text = await loadString('coeff_plancher') ?? '0.25';
    _coeffFenetresController.text = await loadString('coeff_fenetres') ?? '2.5';

    _surfaceMurController.text = await loadString('surface_mur') ?? '150';
    _surfaceToitController.text = await loadString('surface_toit') ?? '100';
    _surfacePlancherController.text = await loadString('surface_plancher') ?? '100';
    _surfaceFenetresController.text = await loadString('surface_fenetres') ?? '20';
    if (mounted) setState(() {});
  }

  Future<void> _sauvegarderDonnees() async {
    await saveString('surface_habitable', _surfaceController.text);
    await saveString('hauteur_sous_plafond', _hauteurController.text);
    await saveString('nb_occupants', _nbOccupantsController.text);
    await saveString('temp_exterieure', _tempExterieureController.text);
    await saveString('temp_interieure', _tempInterieureController.text);

    await saveString('coeff_mur', _coeffMurController.text);
    await saveString('coeff_toit', _coeffToitController.text);
    await saveString('coeff_plancher', _coeffPlancherController.text);
    await saveString('coeff_fenetres', _coeffFenetresController.text);

    await saveString('surface_mur', _surfaceMurController.text);
    await saveString('surface_toit', _surfaceToitController.text);
    await saveString('surface_plancher', _surfacePlancherController.text);
    await saveString('surface_fenetres', _surfaceFenetresController.text);
  }

  void _calculerPuissance() {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Récupération des valeurs
      // ignore: unused_local_variable
      double surface = double.parse(_surfaceController.text);
      // ignore: unused_local_variable
      double hauteur = double.parse(_hauteurController.text);
      double tempExt = double.parse(_tempExterieureController.text);
      double tempInt = double.parse(_tempInterieureController.text);
      int nbOccupants = int.parse(_nbOccupantsController.text);

      // Coefficients U
      double uMur = double.parse(_coeffMurController.text);
      double uToit = double.parse(_coeffToitController.text);
      double uPlancher = double.parse(_coeffPlancherController.text);
      double uFenetres = double.parse(_coeffFenetresController.text);

      // Surfaces
      double sMur = double.parse(_surfaceMurController.text);
      double sToit = double.parse(_surfaceToitController.text);
      double sPlancher = double.parse(_surfacePlancherController.text);
      double sFenetres = double.parse(_surfaceFenetresController.text);

      // Calcul de la différence de température
      double deltaT = tempInt - tempExt;

      // Calcul des déperditions par élément
      double deperditionsMur = uMur * sMur * deltaT;
      double deperditionsToit = uToit * sToit * deltaT;
      double deperditionsPlancher = uPlancher * sPlancher * deltaT;
      double deperditionsFenetres = uFenetres * sFenetres * deltaT;

      // Déperditions totales par transmission
      double deperditionsTransmission = deperditionsMur + deperditionsToit +
                                      deperditionsPlancher + deperditionsFenetres;

      // Déperditions par renouvellement d'air (30 m³/h par occupant)
      // double volumeHabitable = surface * hauteur; // not used
      double debitRenouvellement = nbOccupants * 30; // m³/h
      double deperditionsRenouvellement = 0.34 * debitRenouvellement * deltaT;

      // Déperditions totales
      double deperditionsTotales = deperditionsTransmission + deperditionsRenouvellement;

      // Puissance de chauffage nécessaire
      double puissanceChauffage = deperditionsTotales;

      // Puissance avec sécurité (+15%)
      double puissanceAvecSecurite = puissanceChauffage * 1.15;

      // Détermination du type d'appareil recommandé
      String typeAppareil;
      if (puissanceAvecSecurite < 10) {
        typeAppareil = 'Chauffe-eau solaire + appoint électrique';
      } else if (puissanceAvecSecurite < 25) {
        typeAppareil = 'Chaudière gaz à condensation petite puissance';
      } else if (puissanceAvecSecurite < 50) {
        typeAppareil = 'Chaudière gaz à condensation moyenne puissance';
      } else if (puissanceAvecSecurite < 100) {
        typeAppareil = 'Chaudière gaz à condensation grande puissance';
      } else if (puissanceAvecSecurite < 200) {
        typeAppareil = 'Installation collective ou industrielle';
      } else {
        typeAppareil = 'Étude thermique spécialisée recommandée';
      }

      setState(() {
        _deperditionsTotales = deperditionsTotales;
        _puissanceChauffage = puissanceChauffage;
        _puissanceAvecSecurite = puissanceAvecSecurite;
        _typeAppareilRecommande = typeAppareil;
        _detailDeperditions = {
          'Murs': deperditionsMur,
          'Toit': deperditionsToit,
          'Plancher': deperditionsPlancher,
          'Fenêtres': deperditionsFenetres,
          'Renouvellement d\'air': deperditionsRenouvellement,
        };
      });

      _sauvegarderDonnees();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calcul effectué avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de calcul: $e')),
      );
    }
  }

  Future<void> _genererPDF() async {
    if (_puissanceChauffage == null || _detailDeperditions == null) {
      showWarning('Aucun résultat à exporter');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final technicien = prefs.getString('technicien') ?? 'Technicien';
      final entreprise = prefs.getString('entreprise') ?? 'Entreprise';

      final pdfFile = await PdfGeneratorService.generatePuissanceChauffagePdf(
        technicien: technicien,
        entreprise: entreprise,
        dateCalcul: DateTime.now(),
        surface: double.parse(_surfaceController.text),
        hauteur: double.parse(_hauteurController.text),
        nbOccupants: int.parse(_nbOccupantsController.text),
        tempExterieure: double.parse(_tempExterieureController.text),
        tempInterieure: double.parse(_tempInterieureController.text),
        deperditions: _detailDeperditions!,
        puissanceChauffage: _puissanceChauffage!,
        puissanceAvecSecurite: _puissanceAvecSecurite!,
        typeAppareilRecommande: _typeAppareilRecommande!,
        observations: null,
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(pdfFile.path)],
          text: 'Rapport de calcul puissance chauffage',
        ),
      );

      showSuccess('PDF généré et partagé avec succès');
    } catch (e) {
      showError('Erreur lors de la génération du PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget wrapSection(Widget child, int index) {
      final fade = buildStaggeredFade(_introController, index);
      final slide = buildStaggeredSlide(fade);
      return buildFadeSlide(fade: fade, slide: slide, child: child);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isExpertMode ? 'Dimensionnement Thermique Expert' : 'Calcul Puissance Simple'),
        backgroundColor: Colors.deepOrange[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isExpertMode ? Icons.science : Icons.calculate),
            onPressed: () => setState(() => _isExpertMode = !_isExpertMode),
            tooltip: _isExpertMode ? 'Mode Simple' : 'Mode Expert',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _genererPDF,
            tooltip: 'Générer PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              wrapSection(
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculateur de Puissance Chauffage',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Calculez la puissance de chauffage nécessaire selon les normes thermiques en vigueur.',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Méthode: Calcul des déperditions thermiques selon NF EN 12831',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                0,
              ),

              const SizedBox(height: 16),

              // Données générales
              wrapSection(
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Données générales',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _surfaceController,
                                decoration: const InputDecoration(
                                  labelText: 'Surface habitable (m²)',
                                  suffixText: 'm²',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Champ requis';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Nombre valide requis';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _hauteurController,
                                decoration: const InputDecoration(
                                  labelText: 'Hauteur sous plafond (m)',
                                  suffixText: 'm',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Champ requis';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Nombre valide requis';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _nbOccupantsController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre d\'occupants',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Champ requis';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Nombre entier requis';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                1,
              ),

              const SizedBox(height: 16),

              // Températures
              wrapSection(
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Températures de calcul',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _tempExterieureController,
                                decoration: const InputDecoration(
                                  labelText: 'Température extérieure (°C)',
                                  suffixText: '°C',
                                ),
                                keyboardType: TextInputType.numberWithOptions(signed: true),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Champ requis';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Nombre valide requis';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _tempInterieureController,
                                decoration: const InputDecoration(
                                  labelText: 'Température intérieure (°C)',
                                  suffixText: '°C',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Champ requis';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Nombre valide requis';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                2,
              ),

              const SizedBox(height: 16),

              if (_isExpertMode)
                wrapSection(
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coefficients d\'isolation (U - W/m².K)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _coeffMurController,
                                  decoration: const InputDecoration(
                                    labelText: 'Murs',
                                    suffixText: 'W/m².K',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _coeffToitController,
                                  decoration: const InputDecoration(
                                    labelText: 'Toit',
                                    suffixText: 'W/m².K',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _coeffPlancherController,
                                  decoration: const InputDecoration(
                                    labelText: 'Plancher',
                                    suffixText: 'W/m².K',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _coeffFenetresController,
                                  decoration: const InputDecoration(
                                    labelText: 'Fenêtres',
                                    suffixText: 'W/m².K',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  3,
                ),

              const SizedBox(height: 16),

              if (_isExpertMode)
                wrapSection(
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Surfaces des éléments (m²)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _surfaceMurController,
                                  decoration: const InputDecoration(
                                    labelText: 'Murs',
                                    suffixText: 'm²',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _surfaceToitController,
                                  decoration: const InputDecoration(
                                    labelText: 'Toit',
                                    suffixText: 'm²',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _surfacePlancherController,
                                  decoration: const InputDecoration(
                                    labelText: 'Plancher',
                                    suffixText: 'm²',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _surfaceFenetresController,
                                  decoration: const InputDecoration(
                                    labelText: 'Fenêtres',
                                    suffixText: 'm²',
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  4,
                ),

              const SizedBox(height: 16),

              // Bouton Calculer
              wrapSection(
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _calculerPuissance,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculer la puissance'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
                5,
              ),

              const SizedBox(height: 16),

              // Résultats
              if (_puissanceChauffage != null) ...[
                wrapSection(
                  Card(
                    color: Colors.deepOrange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Résultats du dimensionnement',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 20),

                          // Résumé principal
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.deepOrange.shade200),
                            ),
                            child: Column(
                              children: [
                                _buildResultRow(
                                  'Déperditions totales',
                                  '${_deperditionsTotales!.toStringAsFixed(1)} W',
                                  Icons.thermostat,
                                ),
                                const Divider(),
                                _buildResultRow(
                                  'Puissance chauffage nécessaire',
                                  '${_puissanceChauffage!.toStringAsFixed(1)} W',
                                  Icons.bolt,
                                  isHighlight: true,
                                ),
                                const Divider(),
                                _buildResultRow(
                                  'Puissance avec sécurité (+15%)',
                                  '${_puissanceAvecSecurite!.toStringAsFixed(1)} W',
                                  Icons.security,
                                ),
                                const Divider(),
                                _buildResultRow(
                                  'Type d\'appareil recommandé',
                                  _typeAppareilRecommande!,
                                  Icons.device_thermostat,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Détail des déperditions
                          Text(
                            'Détail des déperditions thermiques',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: _detailDeperditions!.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key),
                                      Text('${entry.value.toStringAsFixed(1)} W'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Note technique
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue.shade700),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Calcul selon NF EN 12831. Une étude thermique complète sur site est recommandée pour un dimensionnement précis.',
                                    style: TextStyle(color: Colors.blue.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  6,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: isHighlight ? Theme.of(context).colorScheme.primary : null),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}