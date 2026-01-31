import 'package:flutter/material.dart';

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

  void _calculer() {
    final debit = double.tryParse(_debitController.text) ?? 0.0; // L/min
    final tFroid = double.tryParse(_tempEauFroideController.text) ?? 15;
    final tChaude = double.tryParse(_tempEauChaudeController.text) ?? 55;
    setState(() {
      _puissanceInstantanee = (debit / 60) * 4.18 * (tChaude - tFroid) / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text('Calculer'),
              onPressed: _calculer,
            ),
            const SizedBox(height: 24),
            if (_puissanceInstantanee != null)
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Puissance instantanée nécessaire : [200C${_puissanceInstantanee!.toStringAsFixed(2)} kW', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('Formule utilisée :', style: Theme.of(context).textTheme.titleMedium),
            const Text('Puissance (kW) = [Débit (L/min) / 60] × 4,18 × (Tchaude - Tfroid) / 1000'),
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
    super.dispose();
  }
}
