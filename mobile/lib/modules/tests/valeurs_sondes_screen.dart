import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValeursSondesScreen extends StatefulWidget {
  const ValeursSondesScreen({super.key});

  @override
  State<ValeursSondesScreen> createState() => _ValeursSondesScreenState();
}

class _ValeursSondesScreenState extends State<ValeursSondesScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _conformite = {};
  
  bool _isLoading = false;
  String _resultats = '';

  // Types de sondes et leurs plages de valeurs normales
  final Map<String, Map<String, dynamic>> _typesSondes = {
    'Sonde de température départ': {
      'unite': '°C',
      'min': 40.0,
      'max': 80.0,
      'description': 'Température de départ chauffage',
    },
    'Sonde de température retour': {
      'unite': '°C',
      'min': 30.0,
      'max': 70.0,
      'description': 'Température de retour chauffage',
    },
    'Sonde de température extérieure': {
      'unite': '°C',
      'min': -20.0,
      'max': 40.0,
      'description': 'Température extérieure',
    },
    'Sonde de température ECS': {
      'unite': '°C',
      'min': 45.0,
      'max': 65.0,
      'description': 'Température eau chaude sanitaire',
    },
    'Sonde de pression circuit': {
      'unite': 'bar',
      'min': 1.0,
      'max': 3.0,
      'description': 'Pression circuit de chauffage',
    },
    'Sonde de pression gaz': {
      'unite': 'mbar',
      'min': 18.0,
      'max': 25.0,
      'description': 'Pression gaz naturel',
    },
    'Sonde de débit': {
      'unite': 'l/min',
      'min': 5.0,
      'max': 50.0,
      'description': 'Débit circuit hydraulique',
    },
    'Sonde CO fumées': {
      'unite': 'ppm',
      'min': 0.0,
      'max': 100.0,
      'description': 'Monoxyde de carbone dans les fumées',
    },
    'Sonde O2 fumées': {
      'unite': '%',
      'min': 2.0,
      'max': 12.0,
      'description': 'Oxygène dans les fumées',
    },
    'Sonde tirage': {
      'unite': 'Pa',
      'min': -20.0,
      'max': -5.0,
      'description': 'Tirage conduit de fumées',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _chargerDonnees();
  }

  void _initializeControllers() {
    for (String sonde in _typesSondes.keys) {
      _controllers[sonde] = TextEditingController();
      _conformite[sonde] = true;
    }
  }

  Future<void> _chargerDonnees() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    
    for (String sonde in _typesSondes.keys) {
      final valeur = prefs.getString('sonde_$sonde');
      if (valeur != null) {
        _controllers[sonde]!.text = valeur;
      }
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    
    for (String sonde in _typesSondes.keys) {
      await prefs.setString('sonde_$sonde', _controllers[sonde]!.text);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Données sauvegardées avec succès')),
    );
  }

  void _analyserConformite() {
    setState(() => _isLoading = true);
    
    List<String> resultats = [];
    int conformes = 0;
    int total = 0;

    for (String sonde in _typesSondes.keys) {
      final text = _controllers[sonde]!.text;
      if (text.isNotEmpty) {
        final valeur = double.tryParse(text);
        if (valeur != null) {
          total++;
          final config = _typesSondes[sonde]!;
          final min = config['min'] as double;
          final max = config['max'] as double;
          
          final conforme = valeur >= min && valeur <= max;
          _conformite[sonde] = conforme;
          
          if (conforme) {
            conformes++;
            resultats.add('✅ $sonde: $valeur ${config['unite']} - CONFORME');
          } else {
            resultats.add('❌ $sonde: $valeur ${config['unite']} - NON CONFORME '
                '(attendu: $min-$max ${config['unite']})');
          }
        }
      }
    }

    resultats.insert(0, 'ANALYSE DE CONFORMITÉ DES SONDES');
    resultats.insert(1, '');
    resultats.insert(2, 'Résumé: $conformes/$total sondes conformes');
    resultats.insert(3, '');

    if (conformes == total && total > 0) {
      resultats.insert(4, '🎉 TOUTES LES SONDES SONT CONFORMES');
    } else if (conformes == 0 && total > 0) {
      resultats.insert(4, '⚠️ AUCUNE SONDE N\'EST CONFORME - INTERVENTION REQUISE');
    } else if (total > 0) {
      resultats.insert(4, '⚠️ CERTAINES SONDES NÉCESSITENT UNE VÉRIFICATION');
    }

    setState(() {
      _resultats = resultats.join('\n');
      _isLoading = false;
    });
  }

  void _reinitialiser() {
    setState(() {
      for (var controller in _controllers.values) {
        controller.clear();
      }
      for (String sonde in _conformite.keys) {
        _conformite[sonde] = true;
      }
      _resultats = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valeurs des Sondes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _sauvegarderDonnees,
            tooltip: 'Sauvegarder',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reinitialiser,
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructions
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contrôle des Sondes',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Saisissez les valeurs mesurées pour chaque sonde. '
                            'L\'analyse déterminera automatiquement la conformité '
                            'selon les plages de valeurs normales.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Formulaire des sondes
                  ...(_typesSondes.entries.map((entry) => 
                    _buildSondeField(entry.key, entry.value)
                  )).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _analyserConformite,
                          icon: const Icon(Icons.analytics),
                          label: const Text('Analyser la Conformité'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _reinitialiser,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Effacer'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Résultats
                  if (_resultats.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Résultats de l\'Analyse',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _resultats,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Informations techniques
                  Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informations Techniques',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Les plages de valeurs sont indicatives et peuvent varier selon l\'installation\n'
                            '• Vérifiez toujours les spécifications du fabricant\n'
                            '• En cas de non-conformité, contrôlez l\'étalonnage des sondes\n'
                            '• Certaines valeurs peuvent dépendre des conditions d\'exploitation',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSondeField(String nom, Map<String, dynamic> config) {
    final controller = _controllers[nom]!;
    final conforme = _conformite[nom]!;
    final hasValue = controller.text.isNotEmpty;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      nom,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (hasValue)
                    Icon(
                      conforme ? Icons.check_circle : Icons.error,
                      color: conforme ? Colors.green : Colors.red,
                      size: 20,
                    ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              Text(
                config['description'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Valeur mesurée',
                        suffixText: config['unite'],
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final valeur = double.tryParse(value);
                          if (valeur != null) {
                            setState(() {
                              _conformite[nom] = valeur >= config['min'] && valeur <= config['max'];
                            });
                          }
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plage normale:',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${config['min']} - ${config['max']} ${config['unite']}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
