// ChauffageExpert/lib/features/calculs/plancher_chauffant.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlancherChauffantScreen extends StatefulWidget {
  const PlancherChauffantScreen({super.key});

  @override
  State<PlancherChauffantScreen> createState() =>
      _PlancherChauffantScreenState();
}

class _PlancherChauffantScreenState extends State<PlancherChauffantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surfaceCtrl = TextEditingController();
  final _puissanceCtrl = TextEditingController();
  final _temperatureDepartCtrl = TextEditingController();
  final _temperatureRetourCtrl = TextEditingController();
  final _temperatureAmbienteCtrl = TextEditingController();
  final _epaisseurRevCtrl = TextEditingController();
  final _conductiviteRevCtrl = TextEditingController();
  bool _isLoading = false;
  double? _debit;
  double? _espacement;
  double? _longueurTubes;

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  @override
  void dispose() {
    _surfaceCtrl.dispose();
    _puissanceCtrl.dispose();
    _temperatureDepartCtrl.dispose();
    _temperatureRetourCtrl.dispose();
    _temperatureAmbienteCtrl.dispose();
    _epaisseurRevCtrl.dispose();
    _conductiviteRevCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSavedValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _surfaceCtrl.text = prefs.getString('plancher_surface') ?? '';
      _puissanceCtrl.text = prefs.getString('plancher_puissance') ?? '';
      _temperatureDepartCtrl.text =
          prefs.getString('plancher_temperature_depart') ?? '';
      _temperatureRetourCtrl.text =
          prefs.getString('plancher_temperature_retour') ?? '';
      _temperatureAmbienteCtrl.text =
          prefs.getString('plancher_temperature_ambiente') ?? '';
      _epaisseurRevCtrl.text =
          prefs.getString('plancher_epaisseur_revetement') ?? '';
      _conductiviteRevCtrl.text =
          prefs.getString('plancher_conductivite_revetement') ?? '';
    });
  }

  Future<void> _saveValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('plancher_surface', _surfaceCtrl.text);
    await prefs.setString('plancher_puissance', _puissanceCtrl.text);
    await prefs.setString(
        'plancher_temperature_depart', _temperatureDepartCtrl.text);
    await prefs.setString(
        'plancher_temperature_retour', _temperatureRetourCtrl.text);
    await prefs.setString(
        'plancher_temperature_ambiente', _temperatureAmbienteCtrl.text);
    await prefs.setString(
        'plancher_epaisseur_revetement', _epaisseurRevCtrl.text);
    await prefs.setString(
        'plancher_conductivite_revetement', _conductiviteRevCtrl.text);
  }

  Future<void> _calculerPlancher() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final surface = double.parse(_surfaceCtrl.text);
        final puissance = double.parse(_puissanceCtrl.text);
        final temperatureDepart = double.parse(_temperatureDepartCtrl.text);
        final temperatureRetour = double.parse(_temperatureRetourCtrl.text);
        final temperatureAmbiente = double.parse(_temperatureAmbienteCtrl.text);
        final epaisseurRev = double.parse(_epaisseurRevCtrl.text);
        final conductiviteRev = double.parse(_conductiviteRevCtrl.text);

        // Calcul du débit
        final deltaT = temperatureDepart - temperatureRetour;
        final debit = puissance /
            (4185 * deltaT); // 4185 J/kg.K est la capacité thermique de l'eau

        // Calcul de l'espacement des tubes
        final resistanceThermique = epaisseurRev / conductiviteRev;
        final fluxThermique = puissance / surface;
        final espacement =
            0.2 * (1 + resistanceThermique * fluxThermique / 100);

        // Calcul de la longueur totale des tubes
        final longueurTubes = surface / espacement;

        setState(() {
          _debit = debit;
          _espacement = espacement;
          _longueurTubes = longueurTubes;
        });

        await _saveValues();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plancher Chauffant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _surfaceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Surface (m²)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la surface';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _puissanceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Puissance (W)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la puissance';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureDepartCtrl,
                decoration: const InputDecoration(
                  labelText: 'Température départ (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la température de départ';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureRetourCtrl,
                decoration: const InputDecoration(
                  labelText: 'Température retour (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la température de retour';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureAmbienteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Température ambiante (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la température ambiante';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _epaisseurRevCtrl,
                decoration: const InputDecoration(
                  labelText: 'Épaisseur du revêtement (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'épaisseur du revêtement';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conductiviteRevCtrl,
                decoration: const InputDecoration(
                  labelText: 'Conductivité du revêtement (W/m.K)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la conductivité du revêtement';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _calculerPlancher,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calculer'),
              ),
              if (_debit != null &&
                  _espacement != null &&
                  _longueurTubes != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Résultats',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text('Débit requis: ${_debit!.toStringAsFixed(2)} L/s'),
                        Text(
                            'Espacement des tubes: ${_espacement!.toStringAsFixed(2)} m'),
                        Text(
                            'Longueur totale des tubes: ${_longueurTubes!.toStringAsFixed(2)} m'),
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
}
