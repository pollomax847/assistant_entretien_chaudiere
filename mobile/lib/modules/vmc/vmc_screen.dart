import 'package:flutter/material.dart';
import 'vmc_calculator.dart';

class VMCScreen extends StatefulWidget {
  const VMCScreen({super.key});

  @override
  State<VMCScreen> createState() => _VMCScreenState();
}

class _VMCScreenState extends State<VMCScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nbBouchesController = TextEditingController(text: '4');
  final _debitMesureController = TextEditingController(text: '80');
  final _debitMSController = TextEditingController(text: '1.5');

  String _typeVMC = 'simple_flux';
  bool _modulesFenetre = true;
  bool _etalonnagePortes = true;

  Map<String, dynamic>? _resultats;

  @override
  void initState() {
    super.initState();
    _verifierConformite();
  }

  @override
  void dispose() {
    _nbBouchesController.dispose();
    _debitMesureController.dispose();
    _debitMSController.dispose();
    super.dispose();
  }

  void _verifierConformite() {
    if (_formKey.currentState?.validate() ?? false) {
      final nbBouches = int.tryParse(_nbBouchesController.text) ?? 0;
      final debitMesure = double.tryParse(_debitMesureController.text) ?? 0.0;
      final debitMS = double.tryParse(_debitMSController.text) ?? 0.0;

      final resultats = VMCCalculator.verifierConformite(
        typeVMC: _typeVMC,
        nbBouches: nbBouches,
        debitMesure: debitMesure,
        debitMS: debitMS,
        modulesFenetre: _modulesFenetre,
        etalonnagePortes: _etalonnagePortes,
      );

      setState(() {
        _resultats = resultats;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final typesVMC = VMCCalculator.getTypesVMC();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification VMC'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vérification VMC',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vérification de la conformité des installations VMC selon les normes en vigueur.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Type d'installation
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type d\'installation',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _typeVMC,
                        decoration: const InputDecoration(
                          labelText: 'Type de VMC',
                          prefixIcon: Icon(Icons.air),
                        ),
                        items: typesVMC.map((type) {
                          return DropdownMenuItem<String>(
                            value: type['value'],
                            child: Text(type['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _typeVMC = value!;
                          });
                          _verifierConformite();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mesures
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mesures',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nbBouchesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de bouches',
                          prefixIcon: Icon(Icons.numbers),
                          suffixText: 'bouches',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nombre de bouches';
                          }
                          final nb = int.tryParse(value);
                          if (nb == null || nb <= 0) {
                            return 'Nombre de bouches invalide';
                          }
                          return null;
                        },
                        onChanged: (_) => _verifierConformite(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _debitMesureController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Débit total mesuré',
                          prefixIcon: Icon(Icons.speed),
                          suffixText: 'm³/h',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le débit mesuré';
                          }
                          final debit = double.tryParse(value);
                          if (debit == null || debit <= 0) {
                            return 'Débit invalide';
                          }
                          return null;
                        },
                        onChanged: (_) => _verifierConformite(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _debitMSController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Débit en m/s',
                          prefixIcon: Icon(Icons.trending_up),
                          suffixText: 'm/s',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le débit en m/s';
                          }
                          final debit = double.tryParse(value);
                          if (debit == null || debit <= 0) {
                            return 'Débit invalide';
                          }
                          return null;
                        },
                        onChanged: (_) => _verifierConformite(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Vérifications visuelles
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vérifications visuelles',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Modules aux fenêtres'),
                        subtitle: const Text('Présence et conformité'),
                        value: _modulesFenetre,
                        onChanged: (value) {
                          setState(() {
                            _modulesFenetre = value;
                          });
                          _verifierConformite();
                        },
                        secondary: const Icon(Icons.window),
                      ),
                      SwitchListTile(
                        title: const Text('Étalonnage des portes'),
                        subtitle: const Text('Vérification effectuée'),
                        value: _etalonnagePortes,
                        onChanged: (value) {
                          setState(() {
                            _etalonnagePortes = value;
                          });
                          _verifierConformite();
                        },
                        secondary: const Icon(Icons.door_front_door),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Résultats
              if (_resultats != null) ...[
                Card(
                  color: _resultats!['conforme']
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _resultats!['conforme']
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: _resultats!['conforme']
                                  ? Colors.green
                                  : Colors.red,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _resultats!['conforme']
                                    ? 'Installation CONFORME'
                                    : 'Installation NON CONFORME',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: _resultats!['conforme']
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Détails des mesures
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _buildResultRow(
                                'Débit par bouche',
                                '${_resultats!['debitParBouche'].toStringAsFixed(1)} m³/h',
                                _resultats!['debitParBoucheConforme'],
                                'Plage: ${_resultats!['normeMin']}-${_resultats!['normeMax']} m³/h',
                              ),
                              const Divider(),
                              _buildResultRow(
                                'Débit en m/s',
                                '${_debitMSController.text} m/s',
                                _resultats!['debitMSConforme'],
                                'Plage: 0.8-2.5 m/s',
                              ),
                              const Divider(),
                              _buildResultRow(
                                'Modules fenêtres',
                                _resultats!['modulesFenetreConformes'] ? 'Conformes' : 'Non conformes',
                                _resultats!['modulesFenetreConformes'],
                                '',
                              ),
                              const Divider(),
                              _buildResultRow(
                                'Étalonnage portes',
                                _resultats!['etalonnagePortesOk'] ? 'Vérifié' : 'Non vérifié',
                                _resultats!['etalonnagePortesOk'],
                                '',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Messages détaillés
                        Text(
                          'Détail des vérifications',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...(_resultats!['messages'] as List<String>).map((message) {
                          final isSuccess = message.startsWith('✅');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  isSuccess ? Icons.check : Icons.close,
                                  color: isSuccess ? Colors.green : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    message.replaceAll('✅ ', '').replaceAll('❌ ', ''),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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

  Widget _buildResultRow(String label, String value, bool isValid, String note) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        if (note.isNotEmpty) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}
