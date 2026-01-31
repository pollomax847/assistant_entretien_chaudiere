import 'package:flutter/material.dart';


class VaseExpansionScreen extends StatefulWidget {
  const VaseExpansionScreen({super.key});

  @override
  State<VaseExpansionScreen> createState() => _VaseExpansionScreenState();
}

class _VaseExpansionScreenState extends State<VaseExpansionScreen> {
  final _hauteurController = TextEditingController(text: '10');
  double? _pression;

  void _calculer() {
    final hauteur = double.tryParse(_hauteurController.text) ?? 0.0;
    _pression = (hauteur / 10) + 0.3;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vase d'expansion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calcul de la pression recommandée', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _hauteurController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hauteur du bâtiment (m)',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate),
              label: const Text('Calculer'),
              onPressed: _calculer,
            ),
            const SizedBox(height: 24),
            if (_pression != null)
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pression recommandée : ${_pression!.toStringAsFixed(2)} bar', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text('Formule utilisée :', style: Theme.of(context).textTheme.titleMedium),
            const Text('Pression (bar) = (hauteur bâtiment / 10) + 0.3'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hauteurController.dispose();
    super.dispose();
  }
}
