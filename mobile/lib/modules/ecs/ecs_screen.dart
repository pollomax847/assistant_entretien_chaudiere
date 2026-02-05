import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pdf_generator_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/mixins/mixins.dart';

class EcsScreen extends StatefulWidget {
  const EcsScreen({super.key});

  @override
  State<EcsScreen> createState() => _EcsScreenState();
}

class _EcsScreenState extends State<EcsScreen> 
    with ControllerDisposeMixin, SnackBarMixin, SharedPreferencesMixin {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les équipements
  final List<TextEditingController> _debitControllers = [];
  final List<TextEditingController> _coeffControllers = [];

  // Températures
  late final _tempFroideController = registerController(TextEditingController(text: '10'));
  late final _tempChaudeController = registerController(TextEditingController(text: '45'));

  // Puissance chaudière
  late final _puissanceChaidiereController = registerController(TextEditingController());

  // Résultats
  double? _debitSimultaneLmin;
  double? _debitSimultaneM3h;
  double? _puissanceInstantanee;

  // Liste des équipements
  final List<String> _equipements = [];

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
    _ajouterEquipement(); // Au moins un équipement par défaut
  }

  @override
  void dispose() {
    for (var controller in _debitControllers) {
      controller.dispose();
    }
    for (var controller in _coeffControllers) {
      controller.dispose();
    }
    disposeControllers();
    super.dispose();
  }

  Future<void> _chargerDonnees() async {
    _tempFroideController.text = await loadString('tempFroide') ?? '10';
    _tempChaudeController.text = await loadString('tempChaude') ?? '45';

    // Charger les équipements sauvegardés
    int nbEquipements = await loadInt('nbEquipements') ?? 0;
    for (int i = 0; i < nbEquipements; i++) {
      if (i >= _equipements.length) {
        _ajouterEquipement();
      }
      _debitControllers[i].text = await loadString('debit_$i') ?? '';
      _coeffControllers[i].text = await loadString('coeff_$i') ?? '1.0';
    }
    if (mounted) setState(() {});
  }

  Future<void> _sauvegarderDonnees() async {
    await saveString('tempFroide', _tempFroideController.text);
    await saveString('tempChaude', _tempChaudeController.text);
    await saveInt('nbEquipements', _equipements.length);

    for (int i = 0; i < _equipements.length; i++) {
      await saveString('debit_$i', _debitControllers[i].text);
      await saveString('coeff_$i', _coeffControllers[i].text);
    }
  }

  void _ajouterEquipement() {
    setState(() {
      _equipements.add('Équipement ${_equipements.length + 1}');
      _debitControllers.add(TextEditingController());
      _coeffControllers.add(TextEditingController(text: '1.0'));
    });
  }

  void _supprimerEquipement(int index) {
    setState(() {
      _equipements.removeAt(index);
      _debitControllers.removeAt(index).dispose();
      _coeffControllers.removeAt(index).dispose();
    });
  }

  void _calculer() {
    if (!_formKey.currentState!.validate()) return;

    try {
      double tempFroide = double.parse(_tempFroideController.text);
      double tempChaude = double.parse(_tempChaudeController.text);

      // Calcul du débit simultané
      double debitSimultane = 0.0;
      for (int i = 0; i < _equipements.length; i++) {
        double debit = double.parse(_debitControllers[i].text);
        double coeff = double.parse(_coeffControllers[i].text);
        debitSimultane += debit * coeff;
      }

      // Calcul de la puissance instantanée (kW)
      // Puissance = débit (L/min) × ΔT (°C) × 70 / 1000
      double deltaT = tempChaude - tempFroide;
      double puissance = debitSimultane * deltaT * 70 / 1000; // kW

      setState(() {
        _debitSimultaneLmin = debitSimultane;
        _debitSimultaneM3h = debitSimultane * 60 / 1000; // Conversion L/min vers m³/h
        _puissanceInstantanee = puissance; // Déjà en kW
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
    if (_debitSimultaneLmin == null || _puissanceInstantanee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun résultat à exporter')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final technicien = prefs.getString('technicien') ?? 'Technicien';
      final entreprise = prefs.getString('entreprise') ?? 'Entreprise';

      // Préparer les données des équipements
      final equipements = <Map<String, dynamic>>[];
      for (int i = 0; i < _equipements.length; i++) {
        final debit = double.tryParse(_debitControllers[i].text) ?? 0;
        final coeff = double.tryParse(_coeffControllers[i].text) ?? 1.0;
        if (debit > 0) {
          equipements.add({
            'nom': _equipements[i],
            'debit': debit,
            'coefficient': coeff,
            'debitSimultane': debit * coeff,
          });
        }
      }

      final pdfFile = await PdfGeneratorService.generateEcsPdf(
        technicien: technicien,
        entreprise: entreprise,
        dateCalcul: DateTime.now(),
        equipements: equipements,
        debitTotal: _debitSimultaneLmin!,
        puissanceTotale: _puissanceInstantanee!,
        temperatureEauFroide: double.parse(_tempFroideController.text),
        temperatureEcs: double.parse(_tempChaudeController.text),
      );

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Rapport de calcul ECS',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module ECS'),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculateur ECS - Eau Chaude Sanitaire',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Calculez le débit simultané et la puissance nécessaire pour votre installation d\'eau chaude sanitaire.',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Formule: Débit simultané = Σ(débit équipement × coefficient simultanéité)',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Températures
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
                              controller: _tempFroideController,
                              decoration: const InputDecoration(
                                labelText: 'Température eau froide (°C)',
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _tempChaudeController,
                              decoration: const InputDecoration(
                                labelText: 'Température eau chaude (°C)',
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

              const SizedBox(height: 16),

              // Puissance chaudière
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Données chaudière',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _puissanceChaidiereController,
                        decoration: const InputDecoration(
                          labelText: 'Puissance chaudière (kW)',
                          suffixText: 'kW',
                          hintText: 'Ex: 30',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Équipements',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: _ajouterEquipement,
                            icon: const Icon(Icons.add),
                            tooltip: 'Ajouter un équipement',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(_equipements.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _debitControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Débit ${_equipements[index]} (L/min)',
                                    suffixText: 'L/min',
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
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _coeffControllers[index],
                                  decoration: const InputDecoration(
                                    labelText: 'Coeff simultanéité',
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
                              IconButton(
                                onPressed: () => _supprimerEquipement(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Supprimer',
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton Calculer
              Center(
                child: ElevatedButton.icon(
                  onPressed: _calculer,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Résultats
              if (_debitSimultaneLmin != null) ...[
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Résultats du calcul',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow('Débit simultané', '${_debitSimultaneLmin!.toStringAsFixed(1)} L/min'),
                        _buildResultRow('Débit simultané', '${_debitSimultaneM3h!.toStringAsFixed(2)} m³/h'),
                        _buildResultRow('Puissance instantanée', '${_puissanceInstantanee!.toStringAsFixed(1)} kW'),
                        if (_puissanceChaidiereController.text.isNotEmpty) ...[
                          const Divider(),
                          _buildResultRow('Puissance chaudière', '${_puissanceChaidiereController.text} kW'),
                          Builder(
                            builder: (context) {
                              final puissanceChaudiere = double.tryParse(_puissanceChaidiereController.text) ?? 0;
                              final ecart = _puissanceInstantanee! - puissanceChaudiere;
                              final couleur = ecart > 0 ? Colors.red : Colors.green;
                              return _buildResultRow(
                                'Écart',
                                '${ecart.toStringAsFixed(1)} kW',
                                color: couleur,
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}