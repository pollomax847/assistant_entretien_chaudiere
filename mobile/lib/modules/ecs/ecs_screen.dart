import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EcsScreen extends StatefulWidget {
  const EcsScreen({super.key});

  @override
  State<EcsScreen> createState() => _EcsScreenState();
}

class _EcsScreenState extends State<EcsScreen> {
  final _debitController = TextEditingController(text: '12');
  final _tempEauFroideController = TextEditingController(text: '15');
  final _tempEauChaudeController = TextEditingController(text: '55');
  double? _puissanceInstantanee;
  double? _deltaT;
  final _puissanceChaudiereController = TextEditingController(text: '25');
  double? _puissanceChaudiere;
  double _seuilOrangePercent = 90.0; // shown in UI (50-100)
  // ignore: unused_field
  double? _seuilOrange;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getDouble('seuil_orange') ?? 90.0;
    final p = prefs.getDouble('puissance_chaudiere');
    setState(() {
      _seuilOrangePercent = v;
      if (p != null) {
        _puissanceChaudiere = p;
        _puissanceChaudiereController.text = p.toStringAsFixed(1);
      }
    });
  }

  Future<void> _saveSeuil(double v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('seuil_orange', v);
  }

  Future<void> _savePuissance(double v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('puissance_chaudiere', v);
  }

  void _calculer() {
    final debit = double.tryParse(_debitController.text) ?? 0.0; // L/min
    final tFroid = double.tryParse(_tempEauFroideController.text) ?? 15;
    final tChaude = double.tryParse(_tempEauChaudeController.text) ?? 55;
    final installed = double.tryParse(_puissanceChaudiereController.text) ?? 0.0;
    final seuilPercent = _seuilOrangePercent;
    final seuil = (seuilPercent / 100.0).clamp(0.0, 1.0);
    final delta = tChaude - tFroid;
    setState(() {
      // specific heat of water: 4180 J/(kg·°C)
      // debit (L/min) / 60 -> kg/s (approx.), multiply by 4180 J/kg°C and ΔT (°C),
      // divide by 1000 to convert W to kW
      _deltaT = delta;
      _puissanceChaudiere = installed;
      _seuilOrange = seuil;
      _puissanceInstantanee = (debit / 60) * 4180 * delta / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color resultCardColor;
    String statusLabel = '';
    Color statusColor = Colors.black;
    if (_puissanceInstantanee != null && _puissanceChaudiere != null) {
      final installed = _puissanceChaudiere!;
      final needed = _puissanceInstantanee!;
      if (installed >= needed) {
        resultCardColor = Colors.green.shade50;
        statusLabel = 'Suffisante';
        statusColor = Colors.green;
      } else if (installed >= 0.9 * needed) {
        resultCardColor = Colors.orange.shade50;
        statusLabel = 'Presque suffisante';
        statusColor = Colors.orange;
      } else {
        resultCardColor = Colors.red.shade50;
        statusLabel = 'Insuffisante';
        statusColor = Colors.red;
      }
    } else {
      resultCardColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Module ECS (Eau Chaude Sanitaire)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Calcul de la puissance instantanée nécessaire', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _debitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Débit eau chaude (L/min)',
                prefixIcon: Icon(Icons.water),
                border: OutlineInputBorder(),
                helperText: 'Exemple : 12 L/min',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tempEauFroideController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Température eau froide (°C)',
                      prefixIcon: Icon(Icons.ac_unit),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _tempEauChaudeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Température eau chaude (°C)',
                      prefixIcon: Icon(Icons.waves),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _puissanceChaudiereController,
                    keyboardType: TextInputType.number,
                    onChanged: (s) {
                      final val = double.tryParse(s) ?? 0.0;
                      setState(() => _puissanceChaudiere = val);
                      _savePuissance(val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Puissance chaudière installée (kW)',
                      prefixIcon: Icon(Icons.local_fire_department),
                      border: OutlineInputBorder(),
                      helperText: 'Ex: 25',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(width: 12),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Slider.adaptive(
                              value: _seuilOrangePercent,
                              min: 50,
                              max: 100,
                              divisions: 50,
                              label: '${_seuilOrangePercent.round()}%',
                              onChanged: (v) {
                                setState(() => _seuilOrangePercent = v);
                                _saveSeuil(v);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: 'Vert = chaudière ≥ besoin\nOrange = chaudière ≥ seuil% du besoin\nRouge = chaudière insuffisante',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Text('${_seuilOrangePercent.round()}%', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text('Calculer'),
              onPressed: _calculer,
            ),
            const SizedBox(height: 24),
            if (_puissanceInstantanee != null)
              Card(
                color: resultCardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Puissance instantanée nécessaire : ${_puissanceInstantanee!.toStringAsFixed(2)} kW',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      if (_deltaT != null)
                        Text('ΔT (Tchaude - Tfroid) : ${_deltaT!.toStringAsFixed(1)} °C', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      if (_puissanceChaudiere != null)
                        Text('Chaudière installée : ${_puissanceChaudiere!.toStringAsFixed(1)} kW', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      if (_puissanceChaudiere != null)
                        Text(
                          'Statut : $statusLabel',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('Formule utilisée :', style: Theme.of(context).textTheme.titleMedium),
            const Text('Puissance (kW) = [Débit (L/min) / 60] × 4180 × (Tchaude - Tfroid) / 1000'),
            const SizedBox(height: 16),
            Text('Unités :', style: Theme.of(context).textTheme.titleMedium),
            const Text('• L/min (litres par minute)'),
            const Text('• kW (kilowatts)'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debitController.dispose();
    _tempEauFroideController.dispose();
    _tempEauChaudeController.dispose();
    _puissanceChaudiereController.dispose();
    super.dispose();
  }
}
