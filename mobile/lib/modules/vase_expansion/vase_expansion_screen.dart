import 'package:flutter/material.dart';


class VaseExpansionScreen extends StatefulWidget {
  const VaseExpansionScreen({super.key});

  @override
  State<VaseExpansionScreen> createState() => _VaseExpansionScreenState();
}

class _VaseExpansionScreenState extends State<VaseExpansionScreen> {
  final _hauteurController = TextEditingController(text: '10');
  double? _pression;

  // Contrôleurs pour le calcul avancé
  final _volumeEauController = TextEditingController();
  final _deltaVexpController = TextEditingController();
  final _pmaxController = TextEditingController();
  final _pminController = TextEditingController();
  double? _vaseAvance;

  void _showAdvancedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Calcul avancé du vase d\'expansion'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _volumeEauController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Volume total d\'eau (L)',
                  ),
                ),
                TextField(
                  controller: _deltaVexpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Variation relative de volume (ex: 0.04 pour 4%)',
                  ),
                ),
                TextField(
                  controller: _pmaxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pression max (bar)',
                  ),
                ),
                TextField(
                  controller: _pminController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pression min (bar)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _calculerAvance();
                setState(() {});
                Navigator.of(context).pop();
                _showResultAvance();
              },
              child: const Text('Calculer'),
            ),
          ],
        );
      },
    );
  }

  void _calculerAvance() {
    final vEau = double.tryParse(_volumeEauController.text) ?? 0.0;
    final deltaV = double.tryParse(_deltaVexpController.text) ?? 0.0;
    final pmax = double.tryParse(_pmaxController.text) ?? 0.0;
    final pmin = double.tryParse(_pminController.text) ?? 0.0;
    if (vEau > 0 && deltaV > 0 && pmax > 0 && pmin > 0 && pmax > pmin) {
      // Conversion L -> m3 pour la formule
      final vEauM3 = vEau / 1000.0;
      _vaseAvance = (vEauM3 * deltaV) / ((pmax / pmin) - 1);
    } else {
      _vaseAvance = null;
    }
  }

  void _showResultAvance() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Résultat du calcul avancé'),
          content: _vaseAvance != null
              ? Text('Volume du vase d\'expansion recommandé : ${_vaseAvance!.toStringAsFixed(2)} L')
              : const Text('Paramètres invalides ou manquants.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

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
                labelText: 'Hauteur de l\'installation (HMT) en mètres',
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
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.science),
              label: const Text('Calcul avancé'),
              onPressed: _showAdvancedDialog,
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
    _volumeEauController.dispose();
    _deltaVexpController.dispose();
    _pmaxController.dispose();
    _pminController.dispose();
    super.dispose();
  }
}
