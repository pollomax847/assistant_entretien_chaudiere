import 'package:flutter/material.dart';
import '../../models/sections/accessoires_section.dart';

/// Tab Écran - Accessoires
class AccessoiresTab extends StatefulWidget {
  final AccessoiresSection? initialData;
  final Function(AccessoiresSection) onUpdate;

  const AccessoiresTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _AccessoiresTabState createState() => _AccessoiresTabState();
}

class _AccessoiresTabState extends State<AccessoiresTab> {
  late TextEditingController _typeFiltre;
  late TextEditingController _volumeVase;
  late TextEditingController _commentaireController;

  bool? _filtrePresent;
  bool? _preFiltre;
  bool? _desembouage;
  bool? _reducteurPression;
  bool? _crepine;
  bool? _vasExpansion;
  bool? _sonde;
  bool? _dsp;
  bool? _limiteurTemperature;
  bool? _manometrePresent;
  bool? _flexibleGaz;
  bool? _roaiPresent;
  bool? _daaf;
  bool? _detectionGaz;

  String? _typeVase;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData;
    _typeFiltre = TextEditingController(text: data?.typeFiltre ?? '');
    _volumeVase = TextEditingController(text: data?.volumeVase ?? '');
    _commentaireController = TextEditingController(text: data?.commentaire ?? '');

    _filtrePresent = data?.filtrePresent;
    _preFiltre = data?.preFiltre;
    _desembouage = data?.desembouage;
    _reducteurPression = data?.reducteurPression;
    _crepine = data?.crepine;
    _vasExpansion = data?.vasExpansion;
    _sonde = data?.sonde;
    _dsp = data?.dsp;
    _limiteurTemperature = data?.limiteurTemperature;
    _manometrePresent = data?.manometrePresent;
    _flexibleGaz = data?.flexibleGaz;
    _roaiPresent = data?.roaiPresent;
    _daaf = data?.daaf;
    _detectionGaz = data?.detectionGaz;
    _typeVase = data?.typeVase;
  }

  @override
  void dispose() {
    _typeFiltre.dispose();
    _volumeVase.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = AccessoiresSection(
      filtrePresent: _filtrePresent,
      typeFiltre: _typeFiltre.text.isEmpty ? null : _typeFiltre.text,
      preFiltre: _preFiltre,
      desembouage: _desembouage,
      reducteurPression: _reducteurPression,
      crepine: _crepine,
      vasExpansion: _vasExpansion,
      typeVase: _typeVase,
      volumeVase: _volumeVase.text.isEmpty ? null : _volumeVase.text,
      sonde: _sonde,
      dsp: _dsp,
      limiteurTemperature: _limiteurTemperature,
      manometrePresent: _manometrePresent,
      flexibleGaz: _flexibleGaz,
      roaiPresent: _roaiPresent,
      daaf: _daaf,
      detectionGaz: _detectionGaz,
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
        Text('Filtration', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Filtre présent'),
          value: _filtrePresent ?? false,
          onChanged: (val) {
            setState(() => _filtrePresent = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _typeFiltre,
          decoration: const InputDecoration(
            labelText: 'Type filtre',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        CheckboxListTile(
          title: const Text('Pré-filtre'),
          value: _preFiltre ?? false,
          onChanged: (val) {
            setState(() => _preFiltre = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Eau', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Désembouage'),
          value: _desembouage ?? false,
          onChanged: (val) {
            setState(() => _desembouage = val);
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
        const SizedBox(height: 16),
        Text('Chauffage', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Vase expansion'),
          value: _vasExpansion ?? false,
          onChanged: (val) {
            setState(() => _vasExpansion = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _typeVase,
          decoration: const InputDecoration(
            labelText: 'Type vase',
            border: OutlineInputBorder(),
          ),
          items: ['Fermée', 'Ouverte', 'Fermée air']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() => _typeVase = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _volumeVase,
          decoration: const InputDecoration(
            labelText: 'Volume vase (L)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        CheckboxListTile(
          title: const Text('Sonde'),
          value: _sonde ?? false,
          onChanged: (val) {
            setState(() => _sonde = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Contrôle', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('DSP (Détecteur surpression)'),
          value: _dsp ?? false,
          onChanged: (val) {
            setState(() => _dsp = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Limiteur température'),
          value: _limiteurTemperature ?? false,
          onChanged: (val) {
            setState(() => _limiteurTemperature = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Manomètre présent'),
          value: _manometrePresent ?? false,
          onChanged: (val) {
            setState(() => _manometrePresent = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Gaz', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Flexible gaz'),
          value: _flexibleGaz ?? false,
          onChanged: (val) {
            setState(() => _flexibleGaz = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('ROAI présent'),
          value: _roaiPresent ?? false,
          onChanged: (val) {
            setState(() => _roaiPresent = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Sécurité Additionnelle',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
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
