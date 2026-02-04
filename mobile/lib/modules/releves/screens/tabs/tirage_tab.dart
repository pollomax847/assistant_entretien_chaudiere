import 'package:flutter/material.dart';
import '../../models/sections/tirage_section.dart';

/// Tab Écran - Tirage et mesures gaz
class TirageTab extends StatefulWidget {
  final TirageSection? initialData;
  final Function(TirageSection) onUpdate;

  const TirageTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _TirageTabState createState() => _TirageTabState();
}

class _TirageTabState extends State<TirageTab> {
  late TextEditingController _tirageController;
  late TextEditingController _coController;
  late TextEditingController _co2Controller;
  late TextEditingController _o2Controller;
  late TextEditingController _tempFumeesController;
  late TextEditingController _typeEvacuationController;
  late TextEditingController _commentaireController;

  bool? _tirageConforme;
  bool? _coConforme;
  bool? _co2Conforme;
  bool? _extracteurMotorise;
  bool? _daaf;
  bool? _detectionGaz;
  bool? _ramonageOk;
  bool? _nettoyageOk;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData;
    _tirageController = TextEditingController(text: data?.tirage?.toString() ?? '');
    _coController = TextEditingController(text: data?.co?.toString() ?? '');
    _co2Controller = TextEditingController(text: data?.co2?.toString() ?? '');
    _o2Controller = TextEditingController(text: data?.o2?.toString() ?? '');
    _tempFumeesController =
        TextEditingController(text: data?.temperatureFumees?.toString() ?? '');
    _typeEvacuationController =
        TextEditingController(text: data?.typeEvacuation ?? '');
    _commentaireController = TextEditingController(text: data?.commentaire ?? '');

    _tirageConforme = data?.tirageConforme;
    _coConforme = data?.coConforme;
    _co2Conforme = data?.co2Conforme;
    _extracteurMotorise = data?.extracteurMotorise;
    _daaf = data?.daaf;
    _detectionGaz = data?.detectionGaz;
    _ramonageOk = data?.ramonageOk;
    _nettoyageOk = data?.nettoyageOk;
  }

  @override
  void dispose() {
    _tirageController.dispose();
    _coController.dispose();
    _co2Controller.dispose();
    _o2Controller.dispose();
    _tempFumeesController.dispose();
    _typeEvacuationController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = TirageSection(
      tirage: _tirageController.text.isEmpty
          ? null
          : double.tryParse(_tirageController.text),
      co:
          _coController.text.isEmpty ? null : double.tryParse(_coController.text),
      co2:
          _co2Controller.text.isEmpty ? null : double.tryParse(_co2Controller.text),
      o2: _o2Controller.text.isEmpty ? null : double.tryParse(_o2Controller.text),
      temperatureFumees: _tempFumeesController.text.isEmpty
          ? null
          : double.tryParse(_tempFumeesController.text),
      tirageConforme: _tirageConforme,
      coConforme: _coConforme,
      co2Conforme: _co2Conforme,
      typeEvacuation: _typeEvacuationController.text.isEmpty
          ? null
          : _typeEvacuationController.text,
      extracteurMotorise: _extracteurMotorise,
      daaf: _daaf,
      detectionGaz: _detectionGaz,
      ramonageOk: _ramonageOk,
      nettoyageOk: _nettoyageOk,
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
        Text('Mesures de Tirage et Gaz',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _tirageController,
          decoration: const InputDecoration(
            labelText: 'Tirage (hPa)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _coController,
          decoration: const InputDecoration(
            labelText: 'CO (ppm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _co2Controller,
          decoration: const InputDecoration(
            labelText: 'CO₂ (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _o2Controller,
          decoration: const InputDecoration(
            labelText: 'O₂ (%)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _tempFumeesController,
          decoration: const InputDecoration(
            labelText: 'Température fumées (°C)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Conformité', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Tirage conforme'),
          value: _tirageConforme ?? false,
          onChanged: (val) {
            setState(() => _tirageConforme = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('CO conforme'),
          value: _coConforme ?? false,
          onChanged: (val) {
            setState(() => _coConforme = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('CO₂ conforme'),
          value: _co2Conforme ?? false,
          onChanged: (val) {
            setState(() => _co2Conforme = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _typeEvacuationController,
          decoration: const InputDecoration(
            labelText: 'Type évacuation',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Accessoires Sécurité',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Extracteur motorisé'),
          value: _extracteurMotorise ?? false,
          onChanged: (val) {
            setState(() => _extracteurMotorise = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('DAAF'),
          value: _daaf ?? false,
          onChanged: (val) {
            setState(() => _daaf = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Détection gaz'),
          value: _detectionGaz ?? false,
          onChanged: (val) {
            setState(() => _detectionGaz = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Maintenance', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Ramonage OK'),
          value: _ramonageOk ?? false,
          onChanged: (val) {
            setState(() => _ramonageOk = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Nettoyage OK'),
          value: _nettoyageOk ?? false,
          onChanged: (val) {
            setState(() => _nettoyageOk = val);
            _saveData();
          },
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
