import 'package:flutter/material.dart';
import 'dart:async';

class TopGazTestScreen extends StatefulWidget {
  const TopGazTestScreen({super.key});

  @override
  State<TopGazTestScreen> createState() => _TopGazTestScreenState();
}

class _TopGazTestScreenState extends State<TopGazTestScreen> {
  bool _isTestRunning = false;
  int _countdown = 0;
  late Timer _timer;
  String _testResult = '';
  bool _flameExtinguished = false;
  bool _gazCutOff = false;

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
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
        _timer.cancel();
        
        int timeElapsed = 36 - _countdown;
        if (timeElapsed <= 36) {
          _testResult = '✅ CONFORME - Arrêt gaz en $timeElapsed secondes';
        } else {
          _testResult = '❌ NON CONFORME - Arrêt gaz en $timeElapsed secondes (> 36s)';
        }
      });
    }
  }

  void _resetTest() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _isTestRunning = false;
      _countdown = 0;
      _testResult = '';
      _flameExtinguished = false;
      _gazCutOff = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test TOP Gaz'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête réglementaire
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[50]!, Colors.red[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.red[800], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Test d\'Arrêt de Sécurité Gaz',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'DÉLAI RÉGLEMENTAIRE : 36 SECONDES MAXIMUM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arrêté du 23/02/2018 - Art. 11 / NF DTU 61.1',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions de test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions du test',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Allumez la chaudière normalement\n'
                      '2. Appuyez sur "Démarrer le test"\n'
                      '3. Éteignez manuellement la flamme (veilleuse)\n'
                      '4. Appuyez sur "Flamme éteinte"\n'
                      '5. Dès que le gaz s\'arrête, appuyez sur "Gaz coupé"\n'
                      '6. Vérifiez le résultat',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Zone de test
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
                      Text(
                        'TEST EN COURS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
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
                              color: (_countdown <= 10 ? Colors.red : Colors.orange).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$_countdown',
                            style: const TextStyle(
                              fontSize: 36,
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
                      Text(
                        'Prêt pour le test',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
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

            // Résultats
            if (_testResult.isNotEmpty) ...[
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
                        'Résultat du test',
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _testResult.contains('✅') ? Colors.green[700] : Colors.red[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
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

            const SizedBox(height: 24),

            // Notes techniques
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes techniques',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Le système peut utiliser un thermocouple ou un système d\'ionisation\n'
                      '• Le délai de 36 secondes est un MAXIMUM réglementaire\n'
                      '• Un délai plus court est préférable pour la sécurité\n'
                      '• En cas de non-conformité, l\'installation doit être réparée immédiatement',
                      style: TextStyle(height: 1.5),
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
}
