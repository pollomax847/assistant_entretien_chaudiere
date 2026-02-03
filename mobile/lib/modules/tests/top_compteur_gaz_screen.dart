import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:chauffageexpert/utils/widgets/app_snackbar.dart';
import 'package:chauffageexpert/services/pdf_generator.dart';

class TopCompteurGazScreen extends StatefulWidget {
  const TopCompteurGazScreen({super.key});

  @override
  State<TopCompteurGazScreen> createState() => _TopCompteurGazScreenState();
}

class _TopCompteurGazScreenState extends State<TopCompteurGazScreen> {
  // Contrôleurs
  final _indexDebutController = TextEditingController();
  final _indexFinController = TextEditingController();
  final _dureeController = TextEditingController();
  final _observationsController = TextEditingController();
  
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
  
  // Timer et chronométrage (compte à rebours)
  Timer? _timer;
  int _countdown = 0;
  bool _testEnCours = false;
  String _testResult = '';
  bool _flameExtinguished = false;
  bool _gazCutOff = false;
  // Chronomètre auxiliaire
  bool _chronometerActive = false;
  int _secondes = 0;
  
  // Résultats
  double? _consommation;
  double? _puissanceCalculee;
  String? _typeAppareil;
  
  // Données de test
  // ignore: unused_field
  DateTime? _heureDebut;
  // ignore: unused_field
  DateTime? _heureFin;
  String _technicien = '';
  
  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _technicien = prefs.getString('technicienNom') ?? '';
    });
  }

  void _demarrerTest() {
    setState(() {
      _testEnCours = true;
      _heureDebut = DateTime.now();
      _countdown = 36;
      _testResult = '';
      _flameExtinguished = false;
      _gazCutOff = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        _secondes++;
      });

      if (_countdown <= 0) {
        timer.cancel();
        setState(() {
          _testEnCours = false;
          if (!_gazCutOff) {
            _testResult = '❌ ÉCHEC - Arrêt gaz > 36 secondes - NON CONFORME';
          }
        });
      }
    });

    AppSnackBar.showInfo(context, 'Test du compteur démarré');
  }

  // ignore: unused_element
  void _arreterTest() {
    _timer?.cancel();
    setState(() {
      _chronometerActive = false;
      _testEnCours = false;
      _heureFin = DateTime.now();
      int elapsed = 36 - _countdown;
      if (elapsed < 0) elapsed = 0;
      _secondes = elapsed;
      if (elapsed < 0) elapsed = 0;
      _dureeController.text = elapsed.toString();
    });

    AppSnackBar.showInfo(context, 'Test du compteur arrêté');
  }

  void _stopFlame() {
    setState(() {
      _flameExtinguished = true;
    });
  }

  void _confirmGazCutOff() {
    if (_testEnCours && _flameExtinguished) {
      setState(() {
        _gazCutOff = true;
        _testEnCours = false;
        _timer?.cancel();
        int timeElapsed = 36 - _countdown;
        if (timeElapsed < 0) timeElapsed = 0;
        _secondes = timeElapsed;
        if (timeElapsed <= 36) {
          _testResult = '✅ CONFORME - Arrêt gaz en $timeElapsed secondes';
        } else {
          _testResult = '❌ NON CONFORME - Arrêt gaz en $timeElapsed secondes (> 36s)';
        }
      });
    }
  }

  void _calculerConsommation() {
    try {
      double indexDebut = double.parse(_indexDebutController.text);
      double indexFin = double.parse(_indexFinController.text);
      int duree = int.parse(_dureeController.text);
      
      if (indexFin <= indexDebut) {
        AppSnackBar.showError(context, 'L\'index de fin doit être supérieur à l\'index de début');
        return;
      }
      
      if (duree <= 0) {
        AppSnackBar.showError(context, 'La durée doit être supérieure à 0');
        return;
      }
      
      // Calcul de la consommation en m³
      _consommation = indexFin - indexDebut;
      
      // Calcul de la puissance en kW
      // Formule: (Consommation en m³ × PCS du gaz × 3600) / durée en secondes
      double pcsGaz = _gasTypes[_selectedGasType]!['pcs']; // kWh/m³
      _puissanceCalculee = (_consommation! * pcsGaz * 3600) / duree;
      
      // Détermination du type d'appareil selon la puissance
      if (_puissanceCalculee! < 10) {
        _typeAppareil = 'Chauffe-eau gaz';
      } else if (_puissanceCalculee! < 25) {
        _typeAppareil = 'Chaudière petite puissance';
      } else if (_puissanceCalculee! < 50) {
        _typeAppareil = 'Chaudière moyenne puissance';
      } else {
        _typeAppareil = 'Chaudière grande puissance';
      }
      
      setState(() {});
      _sauvegarderResultats();
      
    } catch (e) {
      AppSnackBar.showError(context, 'Erreur de calcul: $e');
    }
  }

  Future<void> _sauvegarderResultats() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_consommation != null && _puissanceCalculee != null) {
      await prefs.setString('dernierTest_consommation', _consommation.toString());
      await prefs.setString('dernierTest_puissance', _puissanceCalculee.toString());
      await prefs.setString('dernierTest_type', _typeAppareil ?? '');
      await prefs.setString('dernierTest_date', DateTime.now().toIso8601String());
    }
    
    if (!mounted) return;
    AppSnackBar.showSuccess(context, 'Résultats sauvegardés');
  }

  void _reinitialiserTest() {
    _timer?.cancel();
    setState(() {
      _testEnCours = false;
      _chronometerActive = false;
      _secondes = 0;
      _consommation = null;
      _puissanceCalculee = null;
      _typeAppareil = null;
      _heureDebut = null;
      _heureFin = null;
    });
    
    _indexDebutController.clear();
    _indexFinController.clear();
    _dureeController.clear();
    _observationsController.clear();
  }

  String _formatDuree(int secondes) {
    int heures = secondes ~/ 3600;
    int minutes = (secondes % 3600) ~/ 60;
    int sec = secondes % 60;
    return '${heures.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Compteur Gaz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reinitialiserTest,
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations du test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations du test',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text('Technicien: $_technicien'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Text('Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sélection du type de gaz
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
                      onChanged: !_testEnCours ? (value) {
                        setState(() => _selectedGasType = value!);
                      } : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chronométrage (compte à rebours)
            Card(
              color: _chronometerActive
                  ? Colors.orange.withAlpha((0.06 * 255).round())
                  : Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chronométrage',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          if (_testEnCours) ...[
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _countdown <= 10 ? Colors.red : Colors.orange,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_countdown <= 10 ? Colors.red : Colors.orange).withAlpha((0.3 * 255).round()),
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
                            const SizedBox(height: 12),
                            Text(
                              'secondes restantes',
                              style: TextStyle(fontSize: 16, color: Colors.orange[700]),
                            ),
                            const SizedBox(height: 12),
                            if (!_flameExtinguished)
                              ElevatedButton.icon(
                                onPressed: _stopFlame,
                                icon: const Icon(Icons.local_fire_department),
                                label: const Text('Flamme éteinte'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              )
                            else if (!_gazCutOff)
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
                          ] else ...[
                            Text(
                              'Prêt pour le test',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _demarrerTest,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Démarrer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_testResult.isNotEmpty) ...[
              Card(
                elevation: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _testResult.contains('✅') ? Colors.green[50] : Colors.red[50],
                    border: Border.all(
                      color: _testResult.contains('✅') ? Colors.green : Colors.red,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Résultat du test',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _testResult.contains('✅') ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _testResult,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Relevé des index
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relevé des index du compteur',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _indexDebutController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Index début (m³)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.start),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _indexFinController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Index fin (m³)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.stop),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dureeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Durée du test (secondes)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.timer),
                        helperText: 'Rempli automatiquement par le chrono',
                      ),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Observations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Observations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _observationsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Observations du test',
                        border: OutlineInputBorder(),
                        hintText: 'Conditions particulières, anomalies observées...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bouton de calcul
            Center(
              child: ElevatedButton.icon(
                onPressed: _calculerConsommation,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculer la consommation'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Résultats
            if (_consommation != null && _puissanceCalculee != null) ...[
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
                      
                      // Grille des résultats
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildResultRow(
                              'Consommation mesurée',
                              '${_consommation!.toStringAsFixed(4)} m³',
                              Icons.local_gas_station,
                            ),
                            const Divider(),
                            _buildResultRow(
                              'Puissance calculée',
                              '${_puissanceCalculee!.toStringAsFixed(1)} kW',
                              Icons.bolt,
                              isHighlight: true,
                            ),
                            const Divider(),
                            _buildResultRow(
                              'Type d\'appareil identifié',
                              _typeAppareil!,
                              Icons.device_thermostat,
                            ),
                            const Divider(),
                            _buildResultRow(
                              'Durée du test',
                              _formatDuree(_secondes),
                              Icons.access_time,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Note explicative
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Calcul basé sur PCS du gaz naturel (9,6 kWh/m³)',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
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

  @override
  void dispose() {
    _timer?.cancel();
    _indexDebutController.dispose();
    _indexFinController.dispose();
    _dureeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }
}
