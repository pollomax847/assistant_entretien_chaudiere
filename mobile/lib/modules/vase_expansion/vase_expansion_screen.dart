import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pdf_generator_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/mixins/mixins.dart';

class VaseExpansionScreen extends StatefulWidget {
  const VaseExpansionScreen({super.key});

  @override
  State<VaseExpansionScreen> createState() => _VaseExpansionScreenState();
}

class _VaseExpansionScreenState extends State<VaseExpansionScreen>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  bool _conforme = false;
  final _formKey = GlobalKey<FormState>();
  final _hauteurController = TextEditingController();
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  double? _pressionRecommandee;
  String? _recommandation;

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _chargerDonnees();
  }

  @override
  void dispose() {
    _introController.dispose();
    _hauteurController.dispose();
    super.dispose();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hauteurController.text = prefs.getString('hauteurBatiment') ?? '';
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hauteurBatiment', _hauteurController.text);
    if (_pressionRecommandee != null) {
      await prefs.setString('pressionRecommandee', _pressionRecommandee.toString());
    }
  }

  void _calculerPression() {
    if (!_formKey.currentState!.validate()) return;

    try {
      double hauteur = double.parse(_hauteurController.text);

      // Formule selon cahier des charges :
      // Pression recommandée (bar) = (hauteur bâtiment ÷ 10) + 0,3 bar
      double pression = (hauteur / 10) + 0.3;

      // Détermination de la recommandation
      String recommandation;
      if (pression < 1.0) {
        recommandation = 'Pression faible - Vérifier le dimensionnement du vase';
      } else if (pression > 4.0) {
        recommandation = 'Pression élevée - Consulter un professionnel pour le dimensionnement';
      } else {
        recommandation = 'Pression dans la plage normale - Vérification sur site recommandée';
      }

      setState(() {
        _pressionRecommandee = pression;
        _recommandation = recommandation;
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
    if (_pressionRecommandee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun résultat à exporter')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final technicien = prefs.getString('technicien') ?? 'Technicien';
      final entreprise = prefs.getString('entreprise') ?? 'Entreprise';

      final pdfFile = await PdfGeneratorService.generateVaseExpansionPdf(
        technicien: technicien,
        entreprise: entreprise,
        dateCalcul: DateTime.now(),
        hauteurInstallation: double.parse(_hauteurController.text),
        pressionCalculee: _pressionRecommandee!,
        recommandation: _recommandation!,
        conforme: _conforme,
        observations: null,
      );

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Rapport de calcul vase d\'expansion',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF généré et partagé avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la génération du PDF: $e')),
      );
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
        title: const Text('Vase d\'expansion'),
        actions: [
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
                          'Calculateur Vase d\'expansion',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Calculez la pression recommandée pour le vase d\'expansion de votre installation de chauffage.',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Formule: Pression recommandée = (hauteur bâtiment ÷ 10) + 0,3 bar',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Une vérification manométrique sur site est toujours recommandée pour confirmer ces valeurs.',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                0,
              ),

              const SizedBox(height: 16),

              // Saisie de la hauteur
              wrapSection(
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paramètres du bâtiment',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hauteurController,
                          decoration: const InputDecoration(
                            labelText: 'Hauteur du bâtiment (mètres)',
                            suffixText: 'm',
                            helperText: 'Hauteur totale du bâtiment depuis le niveau du vase d\'expansion',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Champ requis';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Nombre valide requis';
                            }
                            double hauteur = double.parse(value);
                            if (hauteur <= 0) {
                              return 'La hauteur doit être positive';
                            }
                            if (hauteur > 100) {
                              return 'Hauteur maximale recommandée: 100m';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                1,
              ),

              const SizedBox(height: 16),

              // Bouton Calculer
              wrapSection(
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _calculerPression,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculer la pression'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
                2,
              ),

              const SizedBox(height: 16),

              // Résultats
              if (_pressionRecommandee != null) ...[
                wrapSection(
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Résultat du calcul',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          _buildResultRow(
                            'Pression recommandée',
                            '${_pressionRecommandee!.toStringAsFixed(1)} bar',
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getRecommendationColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(_getRecommendationIcon(), color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _recommandation!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  3,
                ),

                const SizedBox(height: 16),

                // Informations complémentaires
                wrapSection(
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informations complémentaires',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '• La pression pré-charge du vase doit être vérifiée manométriquement sur site',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Pour les bâtiments de grande hauteur, consultez les normes en vigueur',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Un vase sous-dimensionné peut causer des problèmes de sécurité',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Un vase sur-dimensionné peut réduire l\'efficacité du système',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  4,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRecommendationColor() {
    if (_recommandation == null) return Colors.grey;

    if (_recommandation!.contains('faible') || _recommandation!.contains('élevée')) {
      return Colors.orange;
    } else if (_recommandation!.contains('professionnel')) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  IconData _getRecommendationIcon() {
    if (_recommandation == null) return Icons.info;

    if (_recommandation!.contains('faible') || _recommandation!.contains('élevée')) {
      return Icons.warning;
    } else if (_recommandation!.contains('professionnel')) {
      return Icons.error;
    } else {
      return Icons.check_circle;
    }
  }
}