import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PuissanceChaudiereExpertScreen extends StatefulWidget {
  const PuissanceChaudiereExpertScreen({super.key});

  @override
  State<PuissanceChaudiereExpertScreen> createState() => _PuissanceChaudiereExpertScreenState();
}

class _PuissanceChaudiereExpertScreenState extends State<PuissanceChaudiereExpertScreen> {
  // Contrôleurs inspirés de votre projet GitHub
  final _surfaceController = TextEditingController();
  final _hauteurController = TextEditingController(text: '2.5');
  final _tempIntController = TextEditingController(text: '20');
  final _tempExtController = TextEditingController(text: '-7');
  final _isolationController = TextEditingController(text: '1.2');
  final _ventilationController = TextEditingController(text: '0.5');
  final _orientationController = TextEditingController(text: '1.0');
  
  String _typeLogement = 'Maison individuelle';
  String _anneeConstruction = '1990-2005';
  String _typeMur = 'Parpaing + isolation';
  String _typeFenetre = 'Double vitrage';
  String _typeVentilation = 'VMC simple flux';
  bool _isolationSol = true;
  bool _isolationCombles = true;
  
  double? _puissanceCalculee;
  double? _deperditionsThermiques;
  List<Map<String, dynamic>> _pieces = [];
  
  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _typeLogement = prefs.getString('typeLogement') ?? 'Maison individuelle';
      _anneeConstruction = prefs.getString('anneeConstruction') ?? '1990-2005';
      _typeMur = prefs.getString('typeMur') ?? 'Parpaing + isolation';
      _typeFenetre = prefs.getString('typeFenetre') ?? 'Double vitrage';
      _typeVentilation = prefs.getString('typeVentilation') ?? 'VMC simple flux';
      _isolationSol = prefs.getBool('isolationSol') ?? true;
      _isolationCombles = prefs.getBool('isolationCombles') ?? true;
      
      // Charger les pièces sauvegardées
      String? piecesJson = prefs.getString('pieces');
      if (piecesJson != null) {
        List<dynamic> decoded = json.decode(piecesJson);
        _pieces = decoded.cast<Map<String, dynamic>>();
      }
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('typeLogement', _typeLogement);
    await prefs.setString('anneeConstruction', _anneeConstruction);
    await prefs.setString('typeMur', _typeMur);
    await prefs.setString('typeFenetre', _typeFenetre);
    await prefs.setString('typeVentilation', _typeVentilation);
    await prefs.setBool('isolationSol', _isolationSol);
    await prefs.setBool('isolationCombles', _isolationCombles);
    await prefs.setString('pieces', json.encode(_pieces));
    
    if (_puissanceCalculee != null) {
      await prefs.setString('puissanceCalculee', _puissanceCalculee.toString());
      await prefs.setString('temperatureExterieure', _tempExtController.text);
      await prefs.setString('temperatureInterieure', _tempIntController.text);
    }
  }

  void _calculerPuissanceExpert() {
    try {
      // Calcul expert inspiré de votre algorithme GitHub
      double surface = double.parse(_surfaceController.text);
      double hauteur = double.parse(_hauteurController.text);
      double tempInt = double.parse(_tempIntController.text);
      double tempExt = double.parse(_tempExtController.text);
      double coeffIsolation = double.parse(_isolationController.text);
      double coeffVentilation = double.parse(_ventilationController.text);
      double coeffOrientation = double.parse(_orientationController.text);
      
      // Calcul du volume
      double volume = surface * hauteur;
      
      // Delta de température
      double deltaT = tempInt - tempExt;
      
      // Coefficients selon type de construction (de votre GitHub)
      Map<String, double> coeffConstruction = {
        'Avant 1975': 2.0,
        '1975-1990': 1.6,
        '1990-2005': 1.3,
        '2005-2012': 1.0,
        'Après 2012': 0.8,
      };
      
      // Coefficients selon type de mur
      Map<String, double> coeffMur = {
        'Pierre non isolée': 2.5,
        'Parpaing non isolé': 2.0,
        'Parpaing + isolation': 1.0,
        'Brique + isolation': 0.9,
        'Ossature bois': 0.7,
        'BBC/RT2012': 0.5,
      };
      
      // Coefficients selon type de fenêtre
      Map<String, double> coeffFenetre = {
        'Simple vitrage': 1.8,
        'Double vitrage': 1.2,
        'Double vitrage renforcé': 1.0,
        'Triple vitrage': 0.8,
      };
      
      // Calcul des déperditions
      double coeffGlobal = coeffConstruction[_anneeConstruction]! * 
                          coeffMur[_typeMur]! * 
                          coeffFenetre[_typeFenetre]! *
                          coeffIsolation * 
                          coeffVentilation * 
                          coeffOrientation;
      
      // Majoration pour isolation sol et combles
      if (!_isolationSol) coeffGlobal *= 1.15;
      if (!_isolationCombles) coeffGlobal *= 1.20;
      
      // Calcul final des déperditions (W)
      _deperditionsThermiques = coeffGlobal * volume * deltaT;
      
      // Puissance chaudière avec marge de sécurité (20%)
      _puissanceCalculee = (_deperditionsThermiques! * 1.2) / 1000;
      
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puissance Chaudière Expert'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _sauvegarderDonnees,
            tooltip: 'Sauvegarder',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations générales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations générales',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _surfaceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Surface totale (m²)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _hauteurController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Hauteur moyenne (m)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _typeLogement,
                      decoration: const InputDecoration(
                        labelText: 'Type de logement',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Maison individuelle',
                        'Appartement',
                        'Local commercial',
                      ].map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _typeLogement = value!;
                        });
                      },
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tempIntController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Température intérieure (°C)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _tempExtController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Température extérieure (°C)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Isolation et construction
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Isolation et construction',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _anneeConstruction,
                      decoration: const InputDecoration(
                        labelText: 'Année de construction',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Avant 1975',
                        '1975-1990',
                        '1990-2005',
                        '2005-2012',
                        'Après 2012',
                      ].map((annee) => DropdownMenuItem(
                        value: annee,
                        child: Text(annee),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _anneeConstruction = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _typeMur,
                            decoration: const InputDecoration(
                              labelText: 'Type de mur',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              'Pierre non isolée',
                              'Parpaing non isolé',
                              'Parpaing + isolation',
                              'Brique + isolation',
                              'Ossature bois',
                              'BBC/RT2012',
                            ].map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _typeMur = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _typeFenetre,
                            decoration: const InputDecoration(
                              labelText: 'Type de fenêtre',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              'Simple vitrage',
                              'Double vitrage',
                              'Double vitrage renforcé',
                              'Triple vitrage',
                            ].map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _typeFenetre = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('Isolation du sol'),
                            value: _isolationSol,
                            onChanged: (value) {
                              setState(() {
                                _isolationSol = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('Isolation des combles'),
                            value: _isolationCombles,
                            onChanged: (value) {
                              setState(() {
                                _isolationCombles = value;
                              });
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

            // Coefficients experts
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coefficients experts',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _isolationController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Coeff. isolation (0.5-2.0)',
                              border: OutlineInputBorder(),
                              helperText: '1.0 = standard',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _ventilationController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Coeff. ventilation (0.3-1.0)',
                              border: OutlineInputBorder(),
                              helperText: '0.5 = VMC standard',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bouton de calcul
            Center(
              child: ElevatedButton.icon(
                onPressed: _calculerPuissanceExpert,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculer la puissance'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                        'Résultats du calcul expert',
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
                                  'Déperditions thermiques',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${_deperditionsThermiques!.toStringAsFixed(0)} W',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
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
                                  'Puissance chaudière recommandée',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${_puissanceCalculee!.toStringAsFixed(1)} kW',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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
                                'Calcul avec marge de sécurité de 20% incluse',
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

  @override
  void dispose() {
    _surfaceController.dispose();
    _hauteurController.dispose();
    _tempIntController.dispose();
    _tempExtController.dispose();
    _isolationController.dispose();
    _ventilationController.dispose();
    _orientationController.dispose();
    super.dispose();
  }
}
