import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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
  
  // Timer et chronométrage
  Timer? _timer;
  int _secondes = 0;
  bool _chronometerActive = false;
  bool _testEnCours = false;
  
  // Résultats
  double? _consommation;
  double? _puissanceCalculee;
  String? _typeAppareil;
  
  // Données de test
  DateTime? _heureDebut;
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
      _chronometerActive = true;
      _heureDebut = DateTime.now();
      _secondes = 0;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondes++;
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test du compteur démarré')),
    );
  }

  void _arreterTest() {
    _timer?.cancel();
    setState(() {
      _chronometerActive = false;
      _heureFin = DateTime.now();
      _dureeController.text = _secondes.toString();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test du compteur arrêté')),
    );
  }

  void _calculerConsommation() {
    try {
      double indexDebut = double.parse(_indexDebutController.text);
      double indexFin = double.parse(_indexFinController.text);
      int duree = int.parse(_dureeController.text);
      
      if (indexFin <= indexDebut) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'index de fin doit être supérieur à l\'index de début')),
        );
        return;
      }
      
      if (duree <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La durée doit être supérieure à 0')),
        );
        return;
      }
      
      // Calcul de la consommation en m³
      _consommation = indexFin - indexDebut;
      
      // Calcul de la puissance en kW
      // Formule: (Consommation en m³ × PCI du gaz × 3600) / durée en secondes
      // PCI du gaz naturel ≈ 10.33 kWh/m³
      double pciGaz = 10.33; // kWh/m³
      _puissanceCalculee = (_consommation! * pciGaz * 3600) / duree;
      
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de calcul: $e')),
      );
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Résultats sauvegardés')),
    );
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

            // Chronométrage
            Card(
              color: _chronometerActive 
                  ? Colors.green.withOpacity(0.1)
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
                          Text(
                            _formatDuree(_secondes),
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontFamily: 'monospace',
                              color: _chronometerActive ? Colors.green : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_testEnCours && !_chronometerActive)
                                ElevatedButton.icon(
                                  onPressed: _demarrerTest,
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Démarrer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              if (_chronometerActive)
                                ElevatedButton.icon(
                                  onPressed: _arreterTest,
                                  icon: const Icon(Icons.stop),
                                  label: const Text('Arrêter'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

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
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Calcul basé sur PCI du gaz naturel (10,33 kWh/m³)',
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
