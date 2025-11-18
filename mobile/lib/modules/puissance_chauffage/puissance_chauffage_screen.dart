import 'package:flutter/material.dart';
import 'puissance_calculator.dart';

class PuissanceChauffageScreen extends StatefulWidget {
  const PuissanceChauffageScreen({super.key});

  @override
  State<PuissanceChauffageScreen> createState() => _PuissanceChauffageScreenState();
}

class _PuissanceChauffageScreenState extends State<PuissanceChauffageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surfaceController = TextEditingController(text: '100');
  final _hauteurController = TextEditingController(text: '2.5');
  
  String _isolation = 'bonne';
  String _zone = 'H2';
  String _typeEmetteur = 'radiateur';
  
  double? _puissanceCalculee;
  double? _puissanceParM2;
  Map<String, dynamic>? _verification;

  @override
  void initState() {
    super.initState();
    _calculer();
  }

  @override
  void dispose() {
    _surfaceController.dispose();
    _hauteurController.dispose();
    super.dispose();
  }

  void _calculer() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final surface = double.parse(_surfaceController.text);
        final hauteur = double.parse(_hauteurController.text);

        final puissance = PuissanceChauffageCalculator.calculerPuissance(
          surface: surface,
          hauteur: hauteur,
          isolation: _isolation,
          zone: _zone,
          typeEmetteur: _typeEmetteur,
        );

        final puissanceParM2 = PuissanceChauffageCalculator.calculerPuissanceParM2(
          puissanceTotale: puissance,
          surface: surface,
        );

        final verification = PuissanceChauffageCalculator.verifierCoherence(
          puissance: puissance,
          surface: surface,
          typeEmetteur: _typeEmetteur,
        );

        setState(() {
          _puissanceCalculee = puissance;
          _puissanceParM2 = puissanceParM2;
          _verification = verification;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de calcul: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puissance Chauffage'),
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
                        'Calculateur de Puissance de Chauffage',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cet outil vous permet d\'estimer la puissance de chauffage nécessaire pour maintenir une température confortable dans votre habitation.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Paramètres de base
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paramètres de base',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _surfaceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Surface habitable (m²)',
                                prefixIcon: Icon(Icons.square_foot),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer la surface';
                                }
                                final surface = double.tryParse(value);
                                if (surface == null || surface <= 0) {
                                  return 'Surface invalide';
                                }
                                return null;
                              },
                              onChanged: (_) => _calculer(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _hauteurController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Hauteur sous plafond (m)',
                                prefixIcon: Icon(Icons.height),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer la hauteur';
                                }
                                final hauteur = double.tryParse(value);
                                if (hauteur == null || hauteur <= 0) {
                                  return 'Hauteur invalide';
                                }
                                return null;
                              },
                              onChanged: (_) => _calculer(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Niveau d'isolation
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Niveau d\'isolation',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _isolation,
                        decoration: const InputDecoration(
                          labelText: 'Isolation du bâtiment',
                          prefixIcon: Icon(Icons.home),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'excellente',
                            child: Text('Excellente (BBC, RT2012+)'),
                          ),
                          DropdownMenuItem(
                            value: 'bonne',
                            child: Text('Bonne (RT2005)'),
                          ),
                          DropdownMenuItem(
                            value: 'moyenne',
                            child: Text('Moyenne (1980-2000)'),
                          ),
                          DropdownMenuItem(
                            value: 'faible',
                            child: Text('Faible (avant 1980)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isolation = value!;
                          });
                          _calculer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Zone climatique
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zone climatique',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _zone,
                        decoration: const InputDecoration(
                          labelText: 'Zone climatique française',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'H1',
                            child: Text('H1 (Nord, Est)'),
                          ),
                          DropdownMenuItem(
                            value: 'H2',
                            child: Text('H2 (Ouest, Centre)'),
                          ),
                          DropdownMenuItem(
                            value: 'H3',
                            child: Text('H3 (Sud)'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _zone = value!;
                          });
                          _calculer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Type d'émetteur
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type d\'émetteur',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Radiateurs'),
                            subtitle: const Text('Radiateurs classiques'),
                            value: 'radiateur',
                            groupValue: _typeEmetteur,
                            onChanged: (value) {
                              setState(() {
                                _typeEmetteur = value!;
                              });
                              _calculer();
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Plancher chauffant'),
                            subtitle: const Text('Plus efficace (-10%)'),
                            value: 'plancher',
                            groupValue: _typeEmetteur,
                            onChanged: (value) {
                              setState(() {
                                _typeEmetteur = value!;
                              });
                              _calculer();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Résultats
              if (_puissanceCalculee != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Résultats',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Puissance nécessaire',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${_puissanceCalculee!.toStringAsFixed(1)} kW',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Puissance par m²',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${_puissanceParM2!.toStringAsFixed(0)} W/m²',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_verification != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _verification!['coherent'] 
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _verification!['coherent'] 
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _verification!['coherent'] 
                                      ? Icons.check_circle
                                      : Icons.warning,
                                  color: _verification!['coherent'] 
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _verification!['message'],
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
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
}
