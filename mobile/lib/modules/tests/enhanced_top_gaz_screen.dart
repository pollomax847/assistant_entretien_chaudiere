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

  // Index inputs
  final TextEditingController _indexBeforeController = TextEditingController();
  final TextEditingController _indexAfterController = TextEditingController();

  // Gas types with PCS values (kWh/m³) and pressure info
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

  // Results
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
    // Validate index before input
    if (_indexBeforeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer l\'index AVANT')),
      );
      return;
    }

    setState(() {
      _isTestRunning = true;
      _countdown = 36;
      _testResult = '';
      _flameExtinguished = false;
      _gazCutOff = false;
      _gasFlow = null;
      _power = null;
      _efficiency = null;
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

      // Calculate consumption in m³
      double consumption = indexAfter - indexBefore;

      // Calculate gas flow in m³/h (assuming 36 seconds test)
      _gasFlow = consumption * (3600.0 / 36.0);

      // Calculate power in kW using PCS
      double pcs = _gasTypes[_selectedGasType]!['pcs'];
      _power = _gasFlow! * pcs;

      // Calculate efficiency (assuming 90% default)
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
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gas type selection
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
                      value: _selectedGasType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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

            const SizedBox(height: 16),

            // Index inputs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Relevé des index',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _indexBeforeController,
                            decoration: const InputDecoration(
                              labelText: 'Index AVANT (m³)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.start),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            enabled: !_isTestRunning,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _indexAfterController,
                            decoration: const InputDecoration(
                              labelText: 'Index APRÈS (m³)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.stop),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            enabled: !_isTestRunning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Analog timer (simplified circular progress)
            Card(
              elevation: 6,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isTestRunning
                        ? [Colors.orange[50]!, Colors.orange[100]!]
                        : [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    if (_isTestRunning) ...[
                      const Text(
                        'TEST EN COURS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _countdown <= 10 ? Colors.red : Colors.orange,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$_countdown',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'secondes restantes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!_flameExtinguished) ...[
                        ElevatedButton.icon(
                          onPressed: _stopFlame,
                          icon: const Icon(Icons.local_fire_department),
                          label: const Text('Flamme éteinte'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ] else if (!_gazCutOff) ...[
                        ElevatedButton.icon(
                          onPressed: _confirmGazCutOff,
                          icon: const Icon(Icons.block),
                          label: const Text('Gaz coupé'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ] else ...[
                      const Text(
                        'Prêt pour le test',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _startTest,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Démarrer le test'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Calculate button
            if (!_isTestRunning)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _calculateResults,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculer les résultats'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Results
            if (_gasFlow != null && _power != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.assessment, size: 32),
                          const SizedBox(width: 16),
                          Text(
                            'Résultats du test',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildResultRow('Type de gaz', _selectedGasType),
                      _buildResultRow('Débit gaz', '${_gasFlow!.toStringAsFixed(3)} m³/h'),
                      _buildResultRow('Puissance', '${_power!.toStringAsFixed(1)} kW'),
                      _buildResultRow('Rendement', '${_efficiency!.toStringAsFixed(1)}%'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Share results
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Partager'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Save to history
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Sauvegarder'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Test result message
            if (_testResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _testResult.contains('✅') ? Colors.green[50] : Colors.red[50],
                    border: Border.all(
                      color: _testResult.contains('✅') ? Colors.green : Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Résultat du test de sécurité',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _testResult.contains('✅') ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _testResult,
                        style: TextStyle(
                          fontSize: 14,
                          color: _testResult.contains('✅') ? Colors.green[700] : Colors.red[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Reset button
            Center(
              child: ElevatedButton.icon(
                onPressed: _resetTest,
                icon: const Icon(Icons.refresh),
                label: const Text('Nouveau test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}