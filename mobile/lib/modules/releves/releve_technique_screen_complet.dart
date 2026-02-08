import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'type_releve.dart';
import 'rt_chaudiere_form.dart';
import 'rt_pac_form.dart';
import 'rt_clim_form.dart';
import 'services/releve_pdf_generator.dart';
import '../../utils/mixins/mixins.dart';
import 'releve_technique_adapter.dart';
import 'external_chauffage_expert/services/location_service.dart';

class ReleveTechnique {
  String nomEntreprise;
  String nomTechnicien;
  DateTime dateReleve;
  TypeReleve type;
  Map<String, dynamic> donnees;

  ReleveTechnique({
    required this.nomEntreprise,
    required this.nomTechnicien,
    required this.dateReleve,
    required this.type,
    required this.donnees,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomEntreprise': nomEntreprise,
      'nomTechnicien': nomTechnicien,
      'dateReleve': dateReleve.toIso8601String(),
      'type': type.toString(),
      'donnees': donnees,
    };
  }

  factory ReleveTechnique.fromJson(Map<String, dynamic> json) {
    return ReleveTechnique(
      nomEntreprise: json['nomEntreprise'] ?? '',
      nomTechnicien: json['nomTechnicien'] ?? '',
      dateReleve: DateTime.parse(json['dateReleve']),
      type: TypeReleve.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TypeReleve.chaudiere,
      ),
      donnees: json['donnees'] ?? {},
    );
  }
}

class ReleveTechniqueScreenComplet extends StatefulWidget {
  final TypeReleve type;

  const ReleveTechniqueScreenComplet({
    super.key,
    required this.type,
  });

  @override
  State<ReleveTechniqueScreenComplet> createState() =>
      _ReleveTechniqueScreenCompletState();
}

class _ReleveTechniqueScreenCompletState
    extends State<ReleveTechniqueScreenComplet>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomEntrepriseController = TextEditingController();
  final _nomTechnicienController = TextEditingController();
  late DateTime _dateReleve;
  final List<Map<String, dynamic>> _releves = [];
  int _currentPage = 0;
  final int _totalPages = 3;
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  @override
  void initState() {
    super.initState();
    _dateReleve = DateTime.now();
    _introController.forward();
    _chargerSauvegarde();
  }

  @override
  void dispose() {
    _introController.dispose();
    _nomEntrepriseController.dispose();
    _nomTechnicienController.dispose();
    super.dispose();
  }

  void _setPage(int nextPage) {
    setState(() => _currentPage = nextPage);
    _introController.forward(from: 0);
  }

  Widget _wrapSection(Widget child, int index) {
    final fade = buildStaggeredFade(_introController, index);
    final slide = buildStaggeredSlide(fade);
    return buildFadeSlide(fade: fade, slide: slide, child: child);
  }

  /// Récupère la position GPS actuelle et met à jour l'adresse
  Future<void> _getGPSLocation() async {
    try {
      final locationService = LocationService();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('📍 Récupération de la localisation...')),
        );
      }

      final position = await locationService.getCurrentLocation();

      final address = await locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (address == 'Adresse non trouvée' || address == 'Erreur lors de la récupération de l\'adresse') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Adresse postale introuvable')),
          );
        }
        return;
      }

      setState(() {
        _nomEntrepriseController.text = address;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Adresse postale détectée')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur: $e')),
        );
      }
    }
  }

  void _sauvegarderReleve() {
    if (_releves.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun relevé à sauvegarder')),
      );
      return;
    }

    final key = 'releve_complet_${widget.type.toString().split('.').last}';

    final flat = {
      'nomEntreprise': _nomEntrepriseController.text,
      'nomTechnicien': _nomTechnicienController.text,
      'dateReleve': _dateReleve.toIso8601String(),
      'type': widget.type.toString(),
      'donnees': _releves.last['donnees'] ?? {},
    };

    // Sauvegarder legacy + structuré via l'adapter
    ReleveTechniqueAdapter.instance.saveLegacy(key, flat).then((_) async {
      try {
        final structured = await ReleveTechniqueAdapter.instance.importLegacy(flat['donnees'] as Map<String, dynamic>);
        await ReleveTechniqueAdapter.instance.saveStructured(key, structured);
      } catch (_) {}
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relevé sauvegardé avec succès')),
        );
      }
    });
  }

  Future<void> _chargerSauvegarde() async {
    final key = 'releve_complet_${widget.type.toString().split('.').last}';
    try {
      final rt = await ReleveTechniqueAdapter.instance.loadStructured(key);
      if (rt != null) {
        setState(() {
          // remplir les champs généraux
          _nomEntrepriseController.text = rt.client?.adresseChantier ?? rt.client?.nom ?? '';
          _nomTechnicienController.text = rt.client?.nomTechnicien ?? rt.client?.nom ?? '';
          _dateReleve = rt.dateVisite ?? rt.dateCreation;
          // conserver les données legacy/plates dans la liste _releves pour compatibilité
          final legacy = ReleveTechniqueAdapter.instance.exportLegacy(rt);
          _releves.clear();
          _releves.add({'donnees': legacy});
        });
      }
    } catch (e) {
      // ignore errors silently for now
    }
  }

  Future<void> _genererPDF() async {
    if (_nomEntrepriseController.text.isEmpty || _nomTechnicienController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Veuillez remplir les informations générales')),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📄 Génération du PDF en cours...')),
      );

      // Si nous avons un relevé structuré sauvegardé, utilisons-le
      final key = 'releve_complet_${widget.type.toString().split('.').last}';
      final structured = await ReleveTechniqueAdapter.instance.loadStructured(key);
      late final ReleveTechniquePDFGenerator generator;
      if (structured != null) {
        generator = ReleveTechniquePDFGenerator.fromStructured(structured, photoPaths: const []);
      } else {
        generator = ReleveTechniquePDFGenerator(
          nomEntreprise: _nomEntrepriseController.text,
          nomTechnicien: _nomTechnicienController.text,
          dateReleve: _dateReleve,
          typeReleve: _getTitre(),
          donnees: _releves.isNotEmpty ? _releves.last['donnees'] ?? {} : {},
          photoPaths: const [], // Les photos seront capturées depuis les formulaires
        );
      }

      final pdfFile = await generator.savePDF();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ PDF généré: ${pdfFile.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur: $e')),
        );
      }
    }
  }

  Widget _buildForm() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return RTChaudiereForm(onSaved: _onFormSaved);
      case TypeReleve.pac:
        return RTPACForm(onSaved: _onFormSaved);
      case TypeReleve.clim:
        return RTClimForm(onSaved: _onFormSaved);
    }
  }

  void _onFormSaved(Map<String, dynamic> donnees) {
    setState(() {
      if (_releves.isEmpty) {
        _releves.add({'donnees': donnees});
      } else {
        _releves[_releves.length - 1] = {'donnees': donnees};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitre()),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _sauvegarderReleve,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exporterTXT(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PAGE 1: INFOS GÉNÉRALES ---
              if (_currentPage == 0) ...[
                _buildPage1(),
              ],
              // --- PAGE 2: FORMULAIRE SPÉCIFIQUE ---
              if (_currentPage == 1) ...[
                _buildPage2(),
              ],
              // --- PAGE 3: RÉSUMÉ & VALIDATION ---
              if (_currentPage == 2) ...[
                _buildPage3(),
              ],

              const SizedBox(height: 24),

              // Boutons de navigation
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentPage > 0
                        ? () => _setPage(_currentPage - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Précédent'),
                  ),
                  const Spacer(),
                  Text('Page ${_currentPage + 1}/$_totalPages',
                    style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _currentPage < _totalPages - 1
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              _setPage(_currentPage + 1);
                            }
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Suivant'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- PAGE 1: INFOS GÉNÉRALES ---
  Widget _buildPage1() {
    return Column(
      children: [
        _wrapSection(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Informations Générales',
                              style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 4),
                            Text(_getTitre(),
                              style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nomEntrepriseController,
                          decoration: const InputDecoration(
                            labelText: 'Adresse du client',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.small(
                        heroTag: 'gps_location',
                        onPressed: _getGPSLocation,
                        tooltip: 'Géolocalisation GPS',
                        child: const Icon(Icons.gps_fixed),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomTechnicienController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du technicien',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Date du relevé',
                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(DateFormat('dd MMMM yyyy', 'fr_FR').format(_dateReleve),
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _dateReleve,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _dateReleve = date;
                                });
                              }
                            },
                            child: const Text('Changer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          0,
        ),
      ],
    );
  }

  // --- PAGE 2: FORMULAIRE SPÉCIFIQUE ---
  Widget _buildPage2() {
    return Column(
      children: [
        _wrapSection(_buildForm(), 0),
      ],
    );
  }

  // --- PAGE 3: RÉSUMÉ & VALIDATION ---
  Widget _buildPage3() {
    return Column(
      children: [
        _wrapSection(
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text('Résumé et Validation',
                          style: Theme.of(context).textTheme.headlineSmall),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildSummaryItem('Entreprise', _nomEntrepriseController.text),
                  _buildSummaryItem('Technicien', _nomTechnicienController.text),
                  _buildSummaryItem('Date',
                    DateFormat('dd/MM/yyyy').format(_dateReleve)),
                  _buildSummaryItem('Type', _getTitre()),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Cliquez sur "Sauvegarder" pour finaliser',
                            style: TextStyle(color: Colors.green.shade700)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _genererPDF,
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Générer PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            minimumSize: const Size.fromHeight(45),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _sauvegarderReleve,
                          icon: const Icon(Icons.save),
                          label: const Text('Sauvegarder'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.fromHeight(45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          0,
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Expanded(
            child: Text(value,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _getTitre() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return 'Relevé Technique Chaudière Complet';
      case TypeReleve.pac:
        return 'Relevé Technique PAC Complet';
      case TypeReleve.clim:
        return 'Relevé Technique Climatisation Complet';
    }
  }

  Future<void> _exporterTXT(BuildContext context) async {
    if (_releves.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun relevé à exporter')),
      );
      return;
    }

    // Logique d'export TXT simplifiée
    String contenu = 'RELEVÉS TECHNIQUES\n\n';
    contenu += 'Entreprise: ${_nomEntrepriseController.text}\n';
    contenu += 'Technicien: ${_nomTechnicienController.text}\n';
    contenu += 'Date: ${DateFormat('dd/MM/yyyy').format(_dateReleve)}\n\n';

    for (int i = 0; i < _releves.length; i++) {
      contenu += 'Relevé ${i + 1}:\n';
      contenu += jsonEncode(_releves[i]);
      contenu += '\n\n';
    }

    // Ici on pourrait utiliser share_plus pour partager le fichier
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export simulé: ${contenu.length} caractères')),
    );
  }
}
