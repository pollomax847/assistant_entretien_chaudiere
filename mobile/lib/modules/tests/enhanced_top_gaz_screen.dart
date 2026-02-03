import 'package:flutter/material.dart';
import 'dart:async';

class EnhancedTopGazScreen extends StatefulWidget {
  const EnhancedTopGazScreen({super.key});

  @override
  State<EnhancedTopGazScreen> createState() => _EnhancedTopGazScreenState();
}

class _EnhancedTopGazScreenState extends State<EnhancedTopGazScreen> {
  bool _isTestRunning = false;
  int _countdown = 0;
  Timer? _timer;
  String _testResult = '';
  bool _flameExtinguished = false;
  bool _gazCutOff = false;

  final TextEditingController _indexBeforeController = TextEditingController();
  final TextEditingController _indexAfterController = TextEditingController();

  final Map<String, Map<String, dynamic>> _gasTypes = {
    'Gaz naturel H': {
      'pcs': 9.6,
      'pressure': '20-25 mbar',
      'description': 'Haute pression'
    },
    'Gaz naturel B': {
      'pcs': 10.0,
      'pressure': '150-300 mbar',
      'description': 'Moyenne pression'
    },
    'Gaz naturel L': {
      'pcs': 6.5,
      'pressure': '25-30 mbar',
      'description': 'Basse pression'
    },
    'Propane': {
      'pcs': 12.8,
      'pressure': '30-50 mbar',
      'description': 'GPL en bouteille'
    },
    'Butane': {
      'pcs': 12.8,
      'pressure': '30-50 mbar',
      'description': 'GPL en bouteille'
    },
  };
  String _selectedGasType = 'Gaz naturel H';

  double? _gasFlow;
  double? _power;
  double? _efficiency;

  @override
  void dispose() {
    _timer?.cancel();
    _indexBeforeController.dispose();
    _indexAfterController.dispose();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      _isTestRunning = true;
      _countdown = 36;
      _testResult = '';
      _flameExtinguished = false;
      _gazCutOff = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        setState(() {
          _isTestRunning = false;
          if (!_gazCutOff) {
            _testResult = '❌ ÉCHEC - Arrêt gaz > 36 secondes - NON CONFORME';
          }
        });
      }
    });
  }

  void _stopFlame() {
    setState(() {
      _flameExtinguished = true;
    });
  }

  void _confirmGazCutOff() {
    if (_isTestRunning && _flameExtinguished) {
      setState(() {
        _gazCutOff = true;
        _isTestRunning = false;
        _timer?.cancel();

        int timeElapsed = 36 - _countdown;
        if (timeElapsed <= 36) {
          _testResult = '✅ CONFORME - Arrêt gaz en $timeElapsed secondes';
        } else {
          _testResult = '❌ NON CONFORME - Arrêt gaz en $timeElapsed secondes (> 36s)';
        }
      });
    }
  }

  void _calculateResults() {
    if (_indexAfterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer l\'index APRÈS')),
      );
      return;
    }

    try {
      double indexBefore = double.parse(_indexBeforeController.text.replaceAll(',', '.'));
      double indexAfter = double.parse(_indexAfterController.text.replaceAll(',', '.'));

      if (indexAfter <= indexBefore) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'index APRÈS doit être supérieur à l\'index AVANT')),
        );
        return;
      }

      double consumption = indexAfter - indexBefore;
      _gasFlow = consumption * (3600.0 / 36.0);
      double pcs = _gasTypes[_selectedGasType]!['pcs'];
      _power = _gasFlow! * pcs;
      _efficiency = 90.0;

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de calcul: $e')),
      );
    }
  }

  void _resetTest() {
    _timer?.cancel();
    setState(() {
      _isTestRunning = false;
      _countdown = 0;
      _testResult = '';
      _flameExtinguished = false;
      _gazCutOff = false;
      _gasFlow = null;
      _power = null;
      _efficiency = null;
    });
    _indexAfterController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOP GAZ'),
        backgroundColor: Colors.red[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.red[700],
      body: SingleChildScrollView(
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
                      'Type de gaz',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGasType,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: _gasTypes.keys.map((type) {
                        final gasInfo = _gasTypes[type]!;
                        return DropdownMenuItem(
                          value: type,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$type (${gasInfo['pcs']} kWh/m³)'),
                              Text(
                                '${gasInfo['description']} - ${gasInfo['pressure']}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: !_isTestRunning ? (value) {
                        setState(() => _selectedGasType = value!);
                      } : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Index compteur (m³)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _indexBeforeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Index AVANT', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _indexAfterController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Index APRÈS', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _calculateResults,
                          child: const Text('Calculer'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: _resetTest, child: const Text('Réinitialiser')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Test sécurité', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_isTestRunning ? 'Test en cours ($_countdown s)' : 'Test inactif'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: !_isTestRunning ? _startTest : null,
                          child: const Text('Démarrer test'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isTestRunning ? _stopFlame : null,
                          child: const Text('Arrêter flamme'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isTestRunning ? _confirmGazCutOff : null,
                          child: const Text('Confirmer coupure gaz'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_testResult.isNotEmpty) Text(_testResult, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_gasFlow != null) Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Résultats', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Débit gaz (m³/h): ${_gasFlow!.toStringAsFixed(2)}'),
                  Text('Puissance (kW): ${_power!.toStringAsFixed(2)}'),
                  Text('Rendement estimé (%): ${_efficiency!.toStringAsFixed(1)}'),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}