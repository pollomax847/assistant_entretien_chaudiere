import 'package:flutter/material.dart';
import 'package:chauffageexpert/utils/app_utils.dart';
import 'dart:math' as math;
import 'dart:convert';

class GestionPiecesScreen extends StatefulWidget {
  const GestionPiecesScreen({super.key});

  @override
  State<GestionPiecesScreen> createState() => _GestionPiecesScreenState();
}

class _GestionPiecesScreenState extends State<GestionPiecesScreen>
    with SharedPreferencesMixin, JsonStorageMixin, CalculationMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _hauteurController = TextEditingController(text: '2.5');
  final _uMursPieceController = TextEditingController();
  final _uToitPieceController = TextEditingController();
  final _uFenetresPieceController = TextEditingController();
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

  // Paramètres d'enveloppe (U-values en W/m²K) et ventilation
  double _uMurs = 0.5; // valeur par défaut
  double _uToit = 0.25;
  double _uFenetres = 2.8;
  double _windowFraction = 0.15; // part moyenne de fenêtres par surface
  double _ventilationAch = 0.5; // air changes per hour
  double _safetyMargin = 1.2; // marge multiplicative (ex: 1.2 = +20%)

  // Résultat
  double? _puissanceTotale;
  List<Map<String, double>> _breakdowns = [];

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final piecesData = await loadListFromJson('pieces');
    setState(() {
      _pieces = piecesData;
      _isolationMurs = loadString('isolationMurs').then((v) => v ?? 'Standard') as String? ?? 'Standard';
      _isolationCombles = loadString('isolationCombles').then((v) => v ?? 'Standard') as String? ?? 'Standard';
    });
    
    // Charger les autres paramètres
    _isolationSol = await loadBool('isolationSol') ?? true;
    _plancherChauffant = await loadBool('plancherChauffant') ?? false;
    _typeVitrage = await loadString('typeVitrage') ?? 'Double';
    _typeVentilation = await loadString('typeVentilation') ?? 'VMC simple flux';
    _tempInt = await loadDouble('tempInt') ?? 19.0;
    _tempExt = await loadDouble('tempExt') ?? 0.0;
    _uMurs = await loadDouble('uMurs') ?? 0.5;
    _uToit = await loadDouble('uToit') ?? 0.25;
    _uFenetres = await loadDouble('uFenetres') ?? 2.8;
    _windowFraction = await loadDouble('windowFraction') ?? 0.15;
    _ventilationAch = await loadDouble('ventilationAch') ?? 0.5;
    _safetyMargin = await loadDouble('safetyMargin') ?? 1.2;
    
    if (mounted) setState(() {});
  }

  Future<void> _sauvegarderDonnees() async {
    await saveListAsJson('pieces', _pieces);
    await saveString('isolationMurs', _isolationMurs);
    await saveString('isolationCombles', _isolationCombles);
    await saveBool('isolationSol', _isolationSol);
    await saveBool('plancherChauffant', _plancherChauffant);
    await saveString('typeVitrage', _typeVitrage);
    await saveString('typeVentilation', _typeVentilation);
    await saveDouble('tempInt', _tempInt);
    await saveDouble('tempExt', _tempExt);
    await saveDouble('uMurs', _uMurs);
    await saveDouble('uToit', _uToit);
    await saveDouble('uFenetres', _uFenetres);
    await saveDouble('windowFraction', _windowFraction);
    await saveDouble('ventilationAch', _ventilationAch);
    await saveDouble('safetyMargin', _safetyMargin);
  }

  // legacy helper removed — calculations now use U‑values + ventilation

  void _ajouterPiece() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        final piece = {
          'nom': _nomController.text,
          'surface': double.parse(_surfaceController.text),
          'hauteur': double.parse(_hauteurController.text),
        };
        final uM = double.tryParse(_uMursPieceController.text);
        final uT = double.tryParse(_uToitPieceController.text);
        final uW = double.tryParse(_uFenetresPieceController.text);
        if (uM != null) piece['uMurs'] = uM;
        if (uT != null) piece['uToit'] = uT;
        if (uW != null) piece['uFenetres'] = uW;
        _pieces.add(piece);
        _nomController.clear();
        _surfaceController.clear();
        _hauteurController.text = '2.5';
        _uMursPieceController.clear();
        _uToitPieceController.clear();
        _uFenetresPieceController.clear();
      });
      _sauvegarderDonnees();
    }
  }

  void _supprimerPiece(int index) {
    setState(() {
      if (index >= 0 && index < _pieces.length) {
        _pieces.removeAt(index);
        if (index < _breakdowns.length) _breakdowns.removeAt(index);
        _puissanceTotale = null;
      }
    });
    _sauvegarderDonnees();
  }

  void _calculerPuissance() {
    final deltaT = _tempInt - _tempExt;
    final List<Map<String, double>> newBreakdowns = [];
    double totalW = 0.0;

    for (final piece in _pieces) {
      final surface = (piece['surface'] as num).toDouble();
      final hauteur = (piece['hauteur'] as num).toDouble();

      final uM = (piece['uMurs'] != null)
          ? (piece['uMurs'] as num).toDouble()
          : _uMurs;
      final uT = (piece['uToit'] != null)
          ? (piece['uToit'] as num).toDouble()
          : _uToit;
      final uW = (piece['uFenetres'] != null)
          ? (piece['uFenetres'] as num).toDouble()
          : _uFenetres;

      final perimeterApprox = 4.0 * math.sqrt(surface);
      final wallArea = perimeterApprox * hauteur;
      final roofArea = surface;
      final windowArea = surface * _windowFraction;

      final wallsW = uM * wallArea * deltaT;
      final roofW = uT * roofArea * deltaT;
      final windowsW = uW * windowArea * deltaT;

      final volume = surface * hauteur;
      final ventW = 0.335 * _ventilationAch * volume * deltaT;

      final pieceTotalW = (wallsW + roofW + windowsW + ventW) * _safetyMargin;
      totalW += pieceTotalW;

      newBreakdowns.add({
        'walls': wallsW / 1000.0,
        'roof': roofW / 1000.0,
        'windows': windowsW / 1000.0,
        'vent': ventW / 1000.0,
        'total': pieceTotalW / 1000.0,
      });
    }

    setState(() {
      _breakdowns = newBreakdowns;
      _puissanceTotale = totalW / 1000.0;
    });
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
            Text('Ajouter une pièce',
                style: Theme.of(context).textTheme.titleLarge),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nomController,
                          decoration:
                              const InputDecoration(labelText: 'Nom de la pièce'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Nom requis';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _surfaceController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Surface (m²)'),
                          validator: (v) {
                            if (v == null || double.tryParse(v) == null) return 'Surface ?';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _hauteurController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Hauteur (m)'),
                          validator: (v) {
                            if (v == null || double.tryParse(v) == null) return 'Hauteur ?';
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _ajouterPiece(),
                        tooltip: 'Ajouter',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Optional per-piece U-values
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _uMursPieceController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'U murs (option)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _uToitPieceController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'U toit (option)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _uFenetresPieceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'U fenêtres (option)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Liste des pièces',
                style: Theme.of(context).textTheme.titleMedium),
            for (final entry in _pieces.asMap().entries)
              ListTile(
                title: Text(entry.value['nom']),
                subtitle: Text(
                    'Surface: ${entry.value['surface']} m², Hauteur: ${entry.value['hauteur']} m'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _supprimerPiece(entry.key),
                ),
              ),
            const Divider(height: 32),
            // Paramètres de l'enveloppe et ventilation (explicatif simple)
            Text('Paramètres enveloppe & ventilation (estimation)',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _uMurs.toString(),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'U murs (W/m²K)'),
                    onChanged: (v) => _uMurs = double.tryParse(v) ?? _uMurs,
                    onFieldSubmitted: (_) => _sauvegarderDonnees(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _uToit.toString(),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'U toit (W/m²K)'),
                    onChanged: (v) => _uToit = double.tryParse(v) ?? _uToit,
                    onFieldSubmitted: (_) => _sauvegarderDonnees(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _uFenetres.toString(),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'U fenêtres (W/m²K)'),
                    onChanged: (v) =>
                        _uFenetres = double.tryParse(v) ?? _uFenetres,
                    onFieldSubmitted: (_) => _sauvegarderDonnees(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _windowFraction.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Part fenêtres (ex: 0.15)'),
                    onChanged: (v) =>
                        _windowFraction = double.tryParse(v) ?? _windowFraction,
                    onFieldSubmitted: (_) => _sauvegarderDonnees(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _ventilationAch.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'ACH (air changes/hour)'),
                    onChanged: (v) =>
                        _ventilationAch = double.tryParse(v) ?? _ventilationAch,
                    onFieldSubmitted: (_) => _sauvegarderDonnees(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _safetyMargin.toString(),
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Marge (ex: 1.2)'),
                    onChanged: (v) =>
                        _safetyMargin = double.tryParse(v) ?? _safetyMargin,
                    onFieldSubmitted: (_) => _sauvegarderDonnees(),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Configuration Isolation',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _isolationMurs,
                    decoration:
                        const InputDecoration(labelText: 'Isolation murs'),
                    items: const [
                      DropdownMenuItem(
                          value: 'Non isolé', child: Text('Non isolé')),
                      DropdownMenuItem(
                          value: 'Standard', child: Text('Standard')),
                      DropdownMenuItem(
                          value: 'Renforcée', child: Text('Renforcée')),
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
                    initialValue: _isolationCombles,
                    decoration:
                        const InputDecoration(labelText: 'Isolation combles'),
                    items: const [
                      DropdownMenuItem(
                          value: 'Non isolé', child: Text('Non isolé')),
                      DropdownMenuItem(
                          value: 'Standard', child: Text('Standard')),
                      DropdownMenuItem(
                          value: 'Renforcée', child: Text('Renforcée')),
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
            Text('Fenêtres & Ventilation',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _typeVitrage,
                    decoration:
                        const InputDecoration(labelText: 'Type vitrage'),
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
                    initialValue: _typeVentilation,
                    decoration:
                        const InputDecoration(labelText: 'Type ventilation'),
                    items: const [
                      DropdownMenuItem(value: 'Aucune', child: Text('Aucune')),
                      DropdownMenuItem(
                          value: 'Naturelle', child: Text('Naturelle')),
                      DropdownMenuItem(
                          value: 'VMC simple flux',
                          child: Text('VMC simple flux')),
                      DropdownMenuItem(
                          value: 'VMC double flux',
                          child: Text('VMC double flux')),
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
                    decoration: const InputDecoration(
                        labelText: 'Température intérieure (°C)'),
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
                    decoration: const InputDecoration(
                        labelText: 'Température extérieure (°C)'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Puissance thermique totale : ${_puissanceTotale!.toStringAsFixed(2)} kW',
                              style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Hypothèses et formule'),
                                  content: const SingleChildScrollView(
                                    child: Text(
                                        'Calcul estimatif (non certifié) :\n'
                                        '- Pertes par transmission = U × surface (m²) × ΔT\n'
                                        '- Murs : périmètre approximé = 4·√(surface) × hauteur\n'
                                        "- Fenêtres : surface × part fenêtres × U_fenêtre\n"
                                        "- Ventilation : Qv ≈ 0.335 × ACH × volume × ΔT\n"
                                        "- Résultat en kW et marge multiplicative appliquée\n\n"
                                        'Ces formules sont simplifiées pour être compréhensibles. Pour un calcul normatif (EN 12831), il faut des U‑valeurs réelles, périmètres exacts, ponts thermiques et règles de projet.'),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Fermer')),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Détail par pièce (kW)'),
                      const SizedBox(height: 8),
                      ..._pieces.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final piece = entry.value;
                        final bd =
                            idx < _breakdowns.length ? _breakdowns[idx] : null;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${piece['nom']} — Surface: ${piece['surface']} m²',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                if (bd != null) ...[
                                  Text(
                                      'Murs : ${bd['walls']!.toStringAsFixed(3)} kW'),
                                  Text(
                                      'Toit : ${bd['roof']!.toStringAsFixed(3)} kW'),
                                  Text(
                                      'Fenêtres : ${bd['windows']!.toStringAsFixed(3)} kW'),
                                  Text(
                                      'Ventilation : ${bd['vent']!.toStringAsFixed(3)} kW'),
                                  const SizedBox(height: 6),
                                  Text(
                                      'Total pièce : ${bd['total']!.toStringAsFixed(3)} kW',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ] else ...[
                                  const Text('Détail indisponible'),
                                ]
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      const Text(
                          'Note : valeurs estimées selon les hypothèses choisies.'),
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

