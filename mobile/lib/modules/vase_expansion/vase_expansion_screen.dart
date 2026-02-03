import 'package:flutter/material.dart';

/// Écran pour le calcul et l'aide au dimensionnement
/// d'un vase d'expansion pour une installation de chauffage.
///
/// - Calcul simple : pression recommandée en fonction de la hauteur (HMT).
/// - Calcul avancé : estimation du volume du vase d'expansion à partir
///   du volume d'eau, de la dilatation et des pressions mini/maxi.
class VaseExpansionScreen extends StatefulWidget {
  const VaseExpansionScreen({super.key});

  @override
  State<VaseExpansionScreen> createState() => _VaseExpansionScreenState();
}

class _VaseExpansionScreenState extends State<VaseExpansionScreen> {
  // Hauteur d'installation (HMT) en mètres, valeur par défaut pratique
  final _hauteurController = TextEditingController(text: '10');
  double? _pression; // pression recommandée en bar

  // Contrôleurs pour le calcul avancé
  final _volumeEauController = TextEditingController(); // L
  final _deltaVexpController = TextEditingController(); // fraction (ex: 0.04)
  final _pmaxController = TextEditingController(); // bar
  final _pminController = TextEditingController(); // bar
  double? _vaseAvanceL; // résultat en litres (L)

  // --- UI helpers -------------------------------------------------------
  Widget _numberField(TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Affiche la boîte de dialogue du calcul avancé
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
                _numberField(_volumeEauController, 'Volume total d\'eau (L)', 'Ex: 200'),
                const SizedBox(height: 8),
                _numberField(_deltaVexpController, 'Variation relative de volume', 'Ex: 0.04 pour 4%'),
                const SizedBox(height: 8),
                _numberField(_pmaxController, 'Pression max (bar)', 'Ex: 3.0'),
                const SizedBox(height: 8),
                _numberField(_pminController, 'Pression min (bar)', 'Ex: 1.0'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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

  // Calcul avancé : retourne null si paramètres invalides.
  // Formule utilisée (avec volumes en m3) :
  // V_vase = (V_eau * deltaV) / ( (pmax/pmin) - 1 )
  // Ici on retourne le résultat en litres (L) pour être plus convivial.
  void _calculerAvance() {
    final vEauL = double.tryParse(_volumeEauController.text) ?? 0.0;
    final deltaV = double.tryParse(_deltaVexpController.text) ?? 0.0;
    final pmax = double.tryParse(_pmaxController.text) ?? 0.0;
    final pmin = double.tryParse(_pminController.text) ?? 0.0;

    if (vEauL > 0 && deltaV > 0 && pmax > 0 && pmin > 0 && pmax > pmin) {
      // Conversion L -> m3 pour la formule
      final vEauM3 = vEauL / 1000.0;
      final resultM3 = (vEauM3 * deltaV) / ((pmax / pmin) - 1);
      // Convertir en litres pour affichage
      _vaseAvanceL = resultM3 * 1000.0;
    } else {
      _vaseAvanceL = null;
    }
  }

  void _showResultAvance() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Résultat du calcul avancé'),
          content: _vaseAvanceL != null
              ? Text('Volume recommandé : ${_vaseAvanceL!.toStringAsFixed(2)} L')
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

  // Calcul simple de la pression recommandée en bar
  void _calculerPression() {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('Calcul de la pression recommandée', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _hauteurController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Hauteur de l\'installation (HMT) en mètres',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(),
                hintText: 'Ex: 10',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculer'),
                  onPressed: _calculerPression,
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.science),
                  label: const Text('Calcul avancé'),
                  onPressed: _showAdvancedDialog,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_pression != null)
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pression recommandée : ${_pression!.toStringAsFixed(2)} bar', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      const Text('Remarque : tenir compte des pertes et caractéristiques constructeur.'),
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
