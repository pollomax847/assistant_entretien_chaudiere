import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GestionPiecesScreen extends StatefulWidget {
  const GestionPiecesScreen({super.key});

  @override
  State<GestionPiecesScreen> createState() => _GestionPiecesScreenState();
}

class _GestionPiecesScreenState extends State<GestionPiecesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _hauteurController = TextEditingController(text: '2.5');
  List<Map<String, dynamic>> _pieces = [];

  // Configuration isolation
  String _isolationMurs = 'Standard';
  String _isolationCombles = 'Standard';
  bool _isolationSol = true;
  bool _plancherChauffant = false;

  // Fenêtres & ventilation
  String _typeVitrage = 'Double';
  String _typeVentilation = 'VMC simple flux';

  // Températures
  double _tempInt = 19.0;
  double _tempExt = 0.0;

  // Résultat
  double? _puissanceTotale;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final piecesJson = prefs.getString('pieces') ?? '[]';
      _pieces = List<Map<String, dynamic>>.from(json.decode(piecesJson));
      _isolationMurs = prefs.getString('isolationMurs') ?? 'Standard';
      _isolationCombles = prefs.getString('isolationCombles') ?? 'Standard';
      _isolationSol = prefs.getBool('isolationSol') ?? true;
      _plancherChauffant = prefs.getBool('plancherChauffant') ?? false;
      _typeVitrage = prefs.getString('typeVitrage') ?? 'Double';
      _typeVentilation = prefs.getString('typeVentilation') ?? 'VMC simple flux';
      _tempInt = prefs.getDouble('tempInt') ?? 19.0;
      _tempExt = prefs.getDouble('tempExt') ?? 0.0;
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pieces', json.encode(_pieces));
    await prefs.setString('isolationMurs', _isolationMurs);
    await prefs.setString('isolationCombles', _isolationCombles);
    await prefs.setBool('isolationSol', _isolationSol);
    await prefs.setBool('plancherChauffant', _plancherChauffant);
    await prefs.setString('typeVitrage', _typeVitrage);
    await prefs.setString('typeVentilation', _typeVentilation);
    await prefs.setDouble('tempInt', _tempInt);
    await prefs.setDouble('tempExt', _tempExt);
  }

  double _coefficientG() {
    // Coefficient G selon isolation
    double g = 1.5; // valeur par défaut
    if (_isolationMurs == 'Non isolé') g = 2.0;
    if (_isolationMurs == 'Standard') g = 1.5;
    if (_isolationMurs == 'Renforcée') g = 1.0;
    if (_isolationCombles == 'Non isolé') g += 0.5;
    if (_isolationCombles == 'Renforcée') g -= 0.3;
    if (!_isolationSol) g += 0.2;
    if (_plancherChauffant) g *= 0.9;
    return g;
  }

  void _ajouterPiece() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _pieces.add({
          'nom': _nomController.text,
          'surface': double.parse(_surfaceController.text),
          'hauteur': double.parse(_hauteurController.text),
        });
        _nomController.clear();
        _surfaceController.clear();
        _hauteurController.text = '2.5';
      });
      _sauvegarderDonnees();
    }
  }

  void _supprimerPiece(int index) {
    setState(() {
      _pieces.removeAt(index);
    });
    _sauvegarderDonnees();
  }

  void _calculerPuissance() {
    double volumeTotal = 0;
    for (final piece in _pieces) {
      volumeTotal += (piece['surface'] as double) * (piece['hauteur'] as double);
    }
    final g = _coefficientG();
    final deltaT = _tempInt - _tempExt;
    _puissanceTotale = volumeTotal * g * deltaT / 1000.0;
    setState(() {});
    _sauvegarderDonnees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des Pièces & Puissance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ajouter une pièce', style: Theme.of(context).textTheme.titleLarge),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(labelText: 'Nom de la pièce'),
                      validator: (v) => v == null || v.isEmpty ? 'Nom requis' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _surfaceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Surface (m²)'),
                      validator: (v) => v == null || double.tryParse(v) == null ? 'Surface ?' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _hauteurController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Hauteur (m)'),
                      validator: (v) => v == null || double.tryParse(v) == null ? 'Hauteur ?' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _ajouterPiece,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Liste des pièces', style: Theme.of(context).textTheme.titleMedium),
            ..._pieces.asMap().entries.map((entry) => ListTile(
                  title: Text(entry.value['nom']),
                  subtitle: Text('Surface: ${entry.value['surface']} m², Hauteur: ${entry.value['hauteur']} m'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _supprimerPiece(entry.key),
                  ),
                )),
            const Divider(height: 32),
            Text('Configuration Isolation', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _isolationMurs,
                    decoration: const InputDecoration(labelText: 'Isolation murs'),
                    items: const [
                      DropdownMenuItem(value: 'Non isolé', child: Text('Non isolé')),
                      DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                      DropdownMenuItem(value: 'Renforcée', child: Text('Renforcée')),
                    ],
                    onChanged: (v) {
                      setState(() => _isolationMurs = v!);
                      _sauvegarderDonnees();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _isolationCombles,
                    decoration: const InputDecoration(labelText: 'Isolation combles'),
                    items: const [
                      DropdownMenuItem(value: 'Non isolé', child: Text('Non isolé')),
                      DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                      DropdownMenuItem(value: 'Renforcée', child: Text('Renforcée')),
                    ],
                    onChanged: (v) {
                      setState(() => _isolationCombles = v!);
                      _sauvegarderDonnees();
                    },
                  ),
                ),
              ],
            ),
            SwitchListTile(
              title: const Text('Isolation sol'),
              value: _isolationSol,
              onChanged: (v) {
                setState(() => _isolationSol = v);
                _sauvegarderDonnees();
              },
            ),
            SwitchListTile(
              title: const Text('Plancher chauffant'),
              value: _plancherChauffant,
              onChanged: (v) {
                setState(() => _plancherChauffant = v);
                _sauvegarderDonnees();
              },
            ),
            const Divider(height: 32),
            Text('Fenêtres & Ventilation', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _typeVitrage,
                    decoration: const InputDecoration(labelText: 'Type vitrage'),
                    items: const [
                      DropdownMenuItem(value: 'Simple', child: Text('Simple')),
                      DropdownMenuItem(value: 'Double', child: Text('Double')),
                      DropdownMenuItem(value: 'Triple', child: Text('Triple')),
                    ],
                    onChanged: (v) {
                      setState(() => _typeVitrage = v!);
                      _sauvegarderDonnees();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _typeVentilation,
                    decoration: const InputDecoration(labelText: 'Type ventilation'),
                    items: const [
                      DropdownMenuItem(value: 'Aucune', child: Text('Aucune')),
                      DropdownMenuItem(value: 'Naturelle', child: Text('Naturelle')),
                      DropdownMenuItem(value: 'VMC simple flux', child: Text('VMC simple flux')),
                      DropdownMenuItem(value: 'VMC double flux', child: Text('VMC double flux')),
                    ],
                    onChanged: (v) {
                      setState(() => _typeVentilation = v!);
                      _sauvegarderDonnees();
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Températures', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _tempInt.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Température intérieure (°C)'),
                    onChanged: (v) {
                      _tempInt = double.tryParse(v) ?? 19.0;
                      _sauvegarderDonnees();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _tempExt.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Température extérieure (°C)'),
                    onChanged: (v) {
                      _tempExt = double.tryParse(v) ?? 0.0;
                      _sauvegarderDonnees();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text('Calculer la puissance totale'),
              onPressed: _calculerPuissance,
            ),
            const SizedBox(height: 24),
            if (_puissanceTotale != null)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Puissance thermique totale : ${_puissanceTotale!.toStringAsFixed(2)} kW', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Formule : Puissance (kW) = Volume (surface × hauteur) × Coefficient G × ΔT / 1000'),
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
