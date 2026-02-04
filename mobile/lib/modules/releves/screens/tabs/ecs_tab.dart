import 'package:flutter/material.dart';
import '../../models/sections/ecs_section.dart';

/// Tab Écran - ECS (Eau Chaude Sanitaire)
class EcsTab extends StatefulWidget {
  final EcsSection? initialData;
  final Function(EcsSection) onUpdate;

  const EcsTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EcsTabState createState() => _EcsTabState();
}

class _EcsTabState extends State<EcsTab> {
  late TextEditingController _debitLController;
  late TextEditingController _debitM3hController;
  late TextEditingController _tempFroideController;
  late TextEditingController _tempChaudeConsigneController;
  late TextEditingController _tempChaudeMesureeController;
  late TextEditingController _puissanceController;
  late TextEditingController _commentaireController;

  String? _typeEcs;
  bool? _integreChaudiere;
  bool? _thermostat;
  bool? _reducteurPression;
  bool? _crepine;
  bool? _filtresSanitaires;
  bool? _clapet;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData;
    _debitLController = TextEditingController(text: data?.debitSimultaneL ?? '');
    _debitM3hController =
        TextEditingController(text: data?.debitSimultaneM3h ?? '');
    _tempFroideController =
        TextEditingController(text: data?.temperatureFroide?.toString() ?? '');
    _tempChaudeConsigneController = TextEditingController(
        text: data?.temperatureChaudeConsigne?.toString() ?? '');
    _tempChaudeMesureeController = TextEditingController(
        text: data?.temperatureChaudeMesuree?.toString() ?? '');
    _puissanceController =
        TextEditingController(text: data?.puissanceInstantanee ?? '');
    _commentaireController = TextEditingController(text: data?.commentaire ?? '');

    _typeEcs = data?.typeEcs;
    _integreChaudiere = data?.integreChaudiere;
    _thermostat = data?.thermostat;
    _reducteurPression = data?.reducteurPression;
    _crepine = data?.crepine;
    _filtresSanitaires = data?.filtresSanitaires;
    _clapet = data?.clapet;
  }

  @override
  void dispose() {
    _debitLController.dispose();
    _debitM3hController.dispose();
    _tempFroideController.dispose();
    _tempChaudeConsigneController.dispose();
    _tempChaudeMesureeController.dispose();
    _puissanceController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = EcsSection(
      typeEcs: _typeEcs,
      integreChaudiere: _integreChaudiere,
      debitSimultaneL:
          _debitLController.text.isEmpty ? null : _debitLController.text,
      debitSimultaneM3h:
          _debitM3hController.text.isEmpty ? null : _debitM3hController.text,
      temperatureFroide: _tempFroideController.text.isEmpty
          ? null
          : double.tryParse(_tempFroideController.text),
      temperatureChaudeConsigne: _tempChaudeConsigneController.text.isEmpty
          ? null
          : double.tryParse(_tempChaudeConsigneController.text),
      temperatureChaudeMesuree: _tempChaudeMesureeController.text.isEmpty
          ? null
          : double.tryParse(_tempChaudeMesureeController.text),
      thermostat: _thermostat,
      reducteurPression: _reducteurPression,
      crepine: _crepine,
      filtresSanitaires: _filtresSanitaires,
      clapet: _clapet,
      puissanceInstantanee:
          _puissanceController.text.isEmpty ? null : _puissanceController.text,
      commentaire:
          _commentaireController.text.isEmpty ? null : _commentaireController.text,
    );
    widget.onUpdate(section);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Configuration ECS', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _typeEcs,
          decoration: const InputDecoration(
            labelText: 'Type ECS',
            border: OutlineInputBorder(),
          ),
          items: [
            'Instantanée',
            'Ballon séparé',
            'Micro-accumulation',
            'Mixte',
            'Intégrée chaudière',
          ]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() => _typeEcs = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Intégrée chaudière'),
          value: _integreChaudiere ?? false,
          onChanged: (val) {
            setState(() => _integreChaudiere = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Débits et Températures',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _debitLController,
          decoration: const InputDecoration(
            labelText: 'Débit simultané (L/min)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _debitM3hController,
          decoration: const InputDecoration(
            labelText: 'Débit simultané (m³/h)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _tempFroideController,
          decoration: const InputDecoration(
            labelText: 'Température froide (°C)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _tempChaudeConsigneController,
          decoration: const InputDecoration(
            labelText: 'Température chaude consigne (°C)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _tempChaudeMesureeController,
          decoration: const InputDecoration(
            labelText: 'Température chaude mesurée (°C)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Accessoires', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Thermostat'),
          value: _thermostat ?? false,
          onChanged: (val) {
            setState(() => _thermostat = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Réducteur pression'),
          value: _reducteurPression ?? false,
          onChanged: (val) {
            setState(() => _reducteurPression = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Crépine'),
          value: _crepine ?? false,
          onChanged: (val) {
            setState(() => _crepine = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Filtres sanitaires'),
          value: _filtresSanitaires ?? false,
          onChanged: (val) {
            setState(() => _filtresSanitaires = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Clapet'),
          value: _clapet ?? false,
          onChanged: (val) {
            setState(() => _clapet = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _puissanceController,
          decoration: const InputDecoration(
            labelText: 'Puissance instantanée (kW)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _commentaireController,
          decoration: const InputDecoration(
            labelText: 'Commentaires',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => _saveData(),
        ),
      ],
    );
  }
}
