import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
// import 'package:vibration/vibration.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:charts_flutter_new/charts_flutter_new.dart' as charts;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:convert';

class EnhancedTopGazScreen extends StatefulWidget {
  const EnhancedTopGazScreen({super.key});

  @override
  State<EnhancedTopGazScreen> createState() => _EnhancedTopGazScreenState();
}

class _EnhancedTopGazScreenState extends State<EnhancedTopGazScreen>
    with TickerProviderStateMixin {
  // Contrôleurs
  final _indexDebutController = TextEditingController();
  final _indexFinController = TextEditingController();
  final _observationsController = TextEditingController();

  // Timer et chronométrage avancé
  Timer? _timer;
  int _centiseconds = 0; // Centièmes de seconde pour fluidité
  bool _chronometerActive = false;
  bool _testEnCours = false;
  int _dureeCible = 36; // 36 secondes par défaut (comme top-gaz)

  // Animation du chronomètre
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  // Résultats avancés
  double? _consommation;
  double? _puissanceCalculee;
  double? _puissanceNette;
  double? _debitHoraire;
  String? _typeAppareil;
  String? _evaluationAnomalie;

  // Types de gaz (inspiré de top-gaz)
  final Map<String, double> _typesGaz = {
    'Gaz naturel H': 9.6, // kWh/m³
    'Gaz naturel B': 10.0,
    'Gaz naturel L': 6.5,
    'Propane': 12.8,
    'Butane': 12.8,
  };
  String _typeGazSelectionne = 'Gaz naturel H';

  // Rendement et paramètres
  double _rendement = 0.85; // 85% par défaut
  bool _sonsActives = true;
  bool _vibrationsActives = true;
  // Graphiques désactivés pour le test web

  // Historique des tests
  List<Map<String, dynamic>> _historiqueTests = [];

  // Données de test
  DateTime? _heureDebut;
  DateTime? _heureFin;
  String _technicien = '';

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
    _initialiserAnimation();
  }

  void _initialiserAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150), // Fluide comme top-gaz
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _indexDebutController.dispose();
    _indexFinController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _technicien = prefs.getString('technicienNom') ?? '';
      _typeGazSelectionne = prefs.getString('typeGazDefaut') ?? 'Gaz naturel H';
      _rendement = prefs.getDouble('rendementDefaut') ?? 0.85;
      _dureeCible = prefs.getInt('dureeCible') ?? 36;
      _sonsActives = prefs.getBool('sonsActives') ?? true;
      _vibrationsActives = prefs.getBool('vibrationsActives') ?? true;

      // Charger historique
      String? historiqueJson = prefs.getString('historiqueTests');
      if (historiqueJson != null) {
        _historiqueTests = List<Map<String, dynamic>>.from(
          json.decode(historiqueJson)
        );
      }
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('typeGazDefaut', _typeGazSelectionne);
    await prefs.setDouble('rendementDefaut', _rendement);
    await prefs.setInt('dureeCible', _dureeCible);
    await prefs.setBool('sonsActives', _sonsActives);
    await prefs.setBool('vibrationsActives', _vibrationsActives);
    await prefs.setString('historiqueTests', json.encode(_historiqueTests));
  }

  void _demarrerTest() {
    setState(() {
      _testEnCours = true;
      _chronometerActive = true;
      _heureDebut = DateTime.now();
      _centiseconds = 0;
    });

    // Démarrer l'animation
    _animationController.forward(from: 0.0);

    // Timer haute précision (50ms comme top-gaz)
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _centiseconds += 5; // 5 centièmes = 50ms

        // Calcul du progrès pour l'animation
        double progress = _centiseconds / (_dureeCible * 100);
        if (progress >= 1.0) {
          _arreterTestAutomatique();
        }
      });
    });

    // Feedback sonore et vibration
    // Feedback désactivé sur le web

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Test démarré - Durée cible: ${_dureeCible}s')),
    );
  }

  void _arreterTestAutomatique() {
    _arreterTest();
    _calculerConsommation();

    // Feedback de fin
    // Feedback désactivé sur le web
  }

  void _arreterTest() {
    _timer?.cancel();
    setState(() {
      _chronometerActive = false;
      _heureFin = DateTime.now();
    });

    _animationController.stop();
  }

  void _calculerConsommation() {
    try {
      double indexDebut = double.parse(_indexDebutController.text);
      double indexFin = double.parse(_indexFinController.text);

      if (indexFin <= indexDebut) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'index de fin doit être supérieur à l\'index de début')),
        );
        return;
      }

      // Calcul de la consommation en m³
      _consommation = indexFin - indexDebut;

      // Durée en secondes
      double dureeSecondes = _centiseconds / 100.0;

      // Calcul du débit horaire (m³/h)
      _debitHoraire = (_consommation! / dureeSecondes) * 3600;

      // PCS du gaz sélectionné
      double pcsGaz = _typesGaz[_typeGazSelectionne]!;

      // Puissance brute (kW) = débit × PCS
      _puissanceCalculee = _debitHoraire! * pcsGaz;

      // Puissance nette = puissance brute × rendement
      _puissanceNette = _puissanceCalculee! * _rendement;

      // Détermination du type d'appareil
      _determinerTypeAppareil();

      // Détection d'anomalies
      _detecterAnomalies();

      // Sauvegarder dans l'historique
      _ajouterHistorique();

      setState(() {});
      _sauvegarderResultats();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de calcul: $e')),
      );
    }
  }

  void _determinerTypeAppareil() {
    double puissance = _puissanceNette ?? 0;

    if (puissance < 10) {
      _typeAppareil = 'Chauffe-eau gaz';
    } else if (puissance < 25) {
      _typeAppareil = 'Chaudière petite puissance';
    } else if (puissance < 50) {
      _typeAppareil = 'Chaudière moyenne puissance';
    } else if (puissance < 100) {
      _typeAppareil = 'Chaudière grande puissance';
    } else {
      _typeAppareil = 'Installation industrielle';
    }
  }

  void _detecterAnomalies() {
    if (_puissanceNette == null) return;

    double puissance = _puissanceNette!;

    // Seuils d'anomalie basés sur les normes
    if (puissance < 5) {
      _evaluationAnomalie = '⚠️ Puissance très faible - Vérifier l\'étanchéité';
    } else if (puissance > 200) {
      _evaluationAnomalie = '⚠️ Puissance très élevée - Risque de surconsommation';
    } else if (_consommation! < 0.01) {
      _evaluationAnomalie = '❌ Aucune consommation détectée - Problème technique';
    } else {
      _evaluationAnomalie = '✅ Test normal - Puissance dans les normes';
    }
  }

  void _ajouterHistorique() {
    Map<String, dynamic> test = {
      'date': DateTime.now().toIso8601String(),
      'technicien': _technicien,
      'typeGaz': _typeGazSelectionne,
      'indexDebut': double.parse(_indexDebutController.text),
      'indexFin': double.parse(_indexFinController.text),
      'duree': _centiseconds / 100.0,
      'consommation': _consommation,
      'debitHoraire': _debitHoraire,
      'puissanceBrute': _puissanceCalculee,
      'puissanceNette': _puissanceNette,
      'rendement': _rendement,
      'typeAppareil': _typeAppareil,
      'evaluation': _evaluationAnomalie,
      'observations': _observationsController.text,
    };

    _historiqueTests.insert(0, test);

    // Garder seulement les 20 derniers tests
    if (_historiqueTests.length > 20) {
      _historiqueTests = _historiqueTests.sublist(0, 20);
    }
  }

  Future<void> _sauvegarderResultats() async {
    final prefs = await SharedPreferences.getInstance();

    if (_consommation != null && _puissanceCalculee != null) {
      await prefs.setString('dernierTest_consommation', _consommation.toString());
      await prefs.setString('dernierTest_puissance', _puissanceNette.toString());
      await prefs.setString('dernierTest_type', _typeAppareil ?? '');
      await prefs.setString('dernierTest_date', DateTime.now().toIso8601String());
      await prefs.setString('dernierTest_evaluation', _evaluationAnomalie ?? '');
    }

    await _sauvegarderDonnees();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Résultats sauvegardés')),
    );
  }

  void _reinitialiserTest() {
    _timer?.cancel();
    setState(() {
      _testEnCours = false;
      _chronometerActive = false;
      _centiseconds = 0;
      _consommation = null;
      _puissanceCalculee = null;
      _puissanceNette = null;
      _debitHoraire = null;
      _typeAppareil = null;
      _evaluationAnomalie = null;
      _heureDebut = null;
      _heureFin = null;
    });

    _animationController.reset();
  }

  Future<void> _exporterHistorique() async {
    if (_historiqueTests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun historique à exporter')),
      );
      return;
    }

    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/historique_tests_gaz.csv');

      String csvContent = 'Date,Technicien,Type Gaz,Index Début,Index Fin,Durée(s),Consommation(m³),Débit(h),Puissance Brute(kW),Puissance Nette(kW),Rendement,Type Appareil,Évaluation,Observations\n';

      for (var test in _historiqueTests) {
        csvContent += '${test['date']},${test['technicien']},${test['typeGaz']},${test['indexDebut']},${test['indexFin']},${test['duree']},${test['consommation']},${test['debitHoraire']},${test['puissanceBrute']},${test['puissanceNette']},${test['rendement']},${test['typeAppareil']},${test['evaluation']},${test['observations']}\n';
      }

      await file.writeAsString(csvContent);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Historique des tests de compteur gaz',
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'export: $e')),
      );
    }
  }

  String _formatTemps() {
    int secondes = _centiseconds ~/ 100;
    int centiemes = _centiseconds % 100;
    return '${secondes.toString().padLeft(2, '0')}.${centiemes.toString().padLeft(2, '0')}s';
  }

  double _getProgress() {
    return min(_centiseconds / (_dureeCible * 100.0), 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test Compteur Gaz Avancé'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Test', icon: Icon(Icons.timer)),
              Tab(text: 'Historique', icon: Icon(Icons.history)),
              Tab(text: 'Paramètres', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTestTab(),
            _buildHistoriqueTab(),
            _buildParametresTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chronomètre analogique animé (inspiré de top-gaz)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Chronomètre de Test',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cercle de progression
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return CircularProgressIndicator(
                              value: _getProgress(),
                              strokeWidth: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _chronometerActive ? Colors.blue : Colors.green,
                              ),
                            );
                          },
                        ),
                        // Affichage digital
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTemps(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              'Cible: ${_dureeCible}s',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _testEnCours ? null : _demarrerTest,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Démarrer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: !_chronometerActive ? null : _arreterTest,
                        icon: const Icon(Icons.stop),
                        label: const Text('Arrêter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Configuration du test
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configuration du Test',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _typeGazSelectionne,
                    decoration: const InputDecoration(
                      labelText: 'Type de gaz',
                      border: OutlineInputBorder(),
                    ),
                    items: _typesGaz.keys.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text('$type (${_typesGaz[type]} kWh/m³)'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _typeGazSelectionne = value!),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _indexDebutController,
                          decoration: const InputDecoration(
                            labelText: 'Index début (m³)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _indexFinController,
                          decoration: const InputDecoration(
                            labelText: 'Index fin (m³)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _rendement.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      labelText: 'Rendement (%)',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      double? r = double.tryParse(value);
                      if (r != null && r > 0 && r <= 1) {
                        setState(() => _rendement = r);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Résultats
          if (_consommation != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Résultats du Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildResultRow('Consommation', '${_consommation!.toStringAsFixed(3)} m³'),
                    _buildResultRow('Débit horaire', '${_debitHoraire!.toStringAsFixed(2)} m³/h'),
                    _buildResultRow('Puissance brute', '${_puissanceCalculee!.toStringAsFixed(1)} kW'),
                    _buildResultRow('Puissance nette', '${_puissanceNette!.toStringAsFixed(1)} kW'),
                    _buildResultRow('Type d\'appareil', _typeAppareil!),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _evaluationAnomalie!.contains('✅') ? Colors.green.shade50 :
                               _evaluationAnomalie!.contains('⚠️') ? Colors.orange.shade50 :
                               Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _evaluationAnomalie!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Observations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Observations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _observationsController,
                    decoration: const InputDecoration(
                      hintText: 'Notes sur le test, conditions, anomalies...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _calculerConsommation,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculer'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _reinitialiserTest,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réinitialiser'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoriqueTab() {
    if (_historiqueTests.isEmpty) {
      return const Center(
        child: Text('Aucun test enregistré'),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: _exporterHistorique,
            icon: const Icon(Icons.share),
            label: const Text('Exporter CSV'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _historiqueTests.length,
            itemBuilder: (context, index) {
              var test = _historiqueTests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ExpansionTile(
                  title: Text(
                    '${DateTime.parse(test['date']).toString().substring(0, 16)} - ${test['puissanceNette'].toStringAsFixed(1)} kW'
                  ),
                  subtitle: Text('${test['typeGaz']} - ${test['typeAppareil']}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildResultRow('Technicien', test['technicien']),
                          _buildResultRow('Consommation', '${test['consommation'].toStringAsFixed(3)} m³'),
                          _buildResultRow('Débit', '${test['debitHoraire'].toStringAsFixed(2)} m³/h'),
                          _buildResultRow('Puissance nette', '${test['puissanceNette'].toStringAsFixed(1)} kW'),
                          _buildResultRow('Évaluation', test['evaluation']),
                          if (test['observations'].isNotEmpty)
                            _buildResultRow('Observations', test['observations']),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParametresTab() {
    return SingleChildScrollView(
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
                    'Paramètres par défaut',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _typeGazSelectionne,
                    decoration: const InputDecoration(
                      labelText: 'Type de gaz par défaut',
                      border: OutlineInputBorder(),
                    ),
                    items: _typesGaz.keys.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text('$type (${_typesGaz[type]} kWh/m³)'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _typeGazSelectionne = value!),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _dureeCible,
                    decoration: const InputDecoration(
                      labelText: 'Durée cible (secondes)',
                      border: OutlineInputBorder(),
                    ),
                    items: [30, 36, 60, 120].map((duree) {
                      return DropdownMenuItem(
                        value: duree,
                        child: Text('$duree secondes'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _dureeCible = value!),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: (_rendement * 100).toStringAsFixed(0),
                    decoration: const InputDecoration(
                      labelText: 'Rendement par défaut (%)',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      double? r = double.tryParse(value);
                      if (r != null && r > 0 && r <= 100) {
                        setState(() => _rendement = r / 100);
                      }
                    },
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
                  const Text(
                    'Feedbacks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Sons actifs'),
                    subtitle: const Text('Jouer des sons lors des tests'),
                    value: _sonsActives,
                    onChanged: (value) => setState(() => _sonsActives = value),
                  ),
                  SwitchListTile(
                    title: const Text('Vibrations actives'),
                    subtitle: const Text('Vibrer lors des tests'),
                    value: _vibrationsActives,
                    onChanged: (value) => setState(() => _vibrationsActives = value),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: _sauvegarderDonnees,
            icon: const Icon(Icons.save),
            label: const Text('Sauvegarder les paramètres'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}