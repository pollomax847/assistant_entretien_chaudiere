import 'package:flutter/material.dart';
import '../../utils/mixins/shared_preferences_mixin.dart';
import '../../utils/mixins/controller_dispose_mixin.dart';

class PuissanceExpertScreen extends StatefulWidget {
  const PuissanceExpertScreen({super.key});

  @override
  State<PuissanceExpertScreen> createState() => _PuissanceExpertScreenState();
}

class _PuissanceExpertScreenState extends State<PuissanceExpertScreen>
    with SharedPreferencesMixin, ControllerDisposeMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final _surfaceController = registerController(TextEditingController());
  late final _hauteurController = registerController(TextEditingController());
  late final _tempIntController = registerController(TextEditingController());
  late final _tempExtController = registerController(TextEditingController());
  late final _isolationController = registerController(TextEditingController(text: '1.0'));
  late final _ventilationController = registerController(TextEditingController(text: '0.5'));
  late final _orientationController = registerController(TextEditingController(text: '1.0'));

  // Variables d'état
  bool _isolationCombles = false;
  double? _puissanceCalculee;
  double? _deperditionsThermiques;

  @override
  void initState() {
    super.initState();
    _chargerPreferences();
  }

  Future<void> _chargerPreferences() async {
    _surfaceController.text = await loadString('surface') ?? '';
    _hauteurController.text = await loadString('hauteur') ?? '';
    _tempIntController.text = await loadString('tempInt') ?? '20';
    _tempExtController.text = await loadString('tempExt') ?? '-5';
    _isolationCombles = await loadBool('isolationCombles') ?? false;
    if (mounted) setState(() {});
  }

  Future<void> _sauvegarderPreferences() async {
    await saveString('surface', _surfaceController.text);
    await saveString('hauteur', _hauteurController.text);
    await saveString('tempInt', _tempIntController.text);
    await saveString('tempExt', _tempExtController.text);
    await saveBool('isolationCombles', _isolationCombles);
  }

  void _calculerPuissanceExpert() {
    if (!_formKey.currentState!.validate()) return;

    final surface = double.tryParse(_surfaceController.text);
    final hauteur = double.tryParse(_hauteurController.text);
    final tempInt = double.tryParse(_tempIntController.text) ?? 20.0;
    final tempExt = double.tryParse(_tempExtController.text) ?? -5.0;
    final coeffIsolation = double.tryParse(_isolationController.text) ?? 1.0;
    final coeffVentilation = double.tryParse(_ventilationController.text) ?? 0.5;

    if (surface == null || hauteur == null) return;

    // Calcul des déperditions thermiques
    final volume = surface * hauteur;
    final deltaT = tempInt - tempExt;

    // Déperditions par les murs (en W)
    final deperditionsMurs = surface * 4 * hauteur * coeffIsolation * deltaT * 0.04;

    // Déperditions par le toit (en W)
    final deperditionsToit = surface * coeffIsolation * deltaT * 0.05;

    // Déperditions par ventilation (en W)
    final deperditionsVentilation = volume * coeffVentilation * deltaT * 0.35;

    // Déperditions par les fenêtres (en W) - estimation 20% de la surface
    final surfaceFenetres = surface * 0.2;
    final deperditionsFenetres = surfaceFenetres * deltaT * 2.0;

    // Total des déperditions
    final totalDeperditions = deperditionsMurs + deperditionsToit + deperditionsVentilation + deperditionsFenetres;

    // Puissance avec marge de sécurité 20%
    final puissanceAvecMarge = totalDeperditions * 1.2 / 1000; // Conversion en kW

    setState(() {
      _deperditionsThermiques = totalDeperditions;
      _puissanceCalculee = puissanceAvecMarge;
    });

    _sauvegarderPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul Puissance Expert'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Caractéristiques du bâtiment
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Caractéristiques du bâtiment',
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
                                labelText: 'Surface habitable (m²)',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) return 'Champ requis';
                                if (double.tryParse(value!) == null) return 'Nombre invalide';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _hauteurController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Hauteur sous plafond (m)',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) return 'Champ requis';
                                if (double.tryParse(value!) == null) return 'Nombre invalide';
                                return null;
                              },
                            ),
                          ),
                        ],
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
                                helperText: '20°C par défaut',
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
                                helperText: '-5°C par défaut',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Isolation des combles'),
                        value: _isolationCombles,
                        onChanged: (value) {
                          setState(() {
                            _isolationCombles = value;
                          });
                        },
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
                            color: Colors.blue.withAlpha((0.1 * 255).round()),
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
      ),
    );
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
