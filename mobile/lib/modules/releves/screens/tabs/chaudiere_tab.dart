import 'package:flutter/material.dart';
import '../../models/sections/chaudiere_section.dart';
import '../../../utils/mixins/mixins.dart';

/// Tab Écran - Chaudière
/// Gère les données chaudière, ECS, configuration, raccordements
class ChaudiereTab extends StatefulWidget {
  final ChaudiereSection? initialData;
  final Function(ChaudiereSection) onUpdate;

  const ChaudiereTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _ChaudiereTabState createState() => _ChaudiereTabState();
}

class _ChaudiereTabState extends State<ChaudiereTab>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  late TextEditingController _marqueController;
  late TextEditingController _modeleController;
  late TextEditingController _anneeInstallationController;
  late TextEditingController _energieController;
  late TextEditingController _puissanceController;
  late TextEditingController _volumeBallonController;
  late TextEditingController _marqueBallon;
  late TextEditingController _hauteurBallonController;
  late TextEditingController _profondeurBallonController;
  late TextEditingController _typeTuyauterie;
  late TextEditingController _typeRaccordement;
  late TextEditingController _diametre;
  late TextEditingController _typeAlimentationElectrique;
  late TextEditingController _commentaireController;

  bool? _chauffageSeul;
  bool? _avecEcs;
  bool? _radiateur;
  bool? _plancherChauffant;
  bool? _tuyauxDerriereChaudiere;
  bool? _besoinPompeRelevage;

  String? _typeBallonEcs;
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData;
    _marqueController = TextEditingController(text: data?.marque ?? '');
    _modeleController = TextEditingController(text: data?.modele ?? '');
    _anneeInstallationController =
        TextEditingController(text: data?.anneeInstallation?.toString() ?? '');
    _energieController = TextEditingController(text: data?.energie ?? '');
    _puissanceController = TextEditingController(text: data?.puissance ?? '');
    _volumeBallonController =
        TextEditingController(text: data?.volumeBallon ?? '');
    _marqueBallon = TextEditingController(text: data?.marqueBallon ?? '');
    _hauteurBallonController =
        TextEditingController(text: data?.hauteurBallon ?? '');
    _profondeurBallonController =
        TextEditingController(text: data?.profondeurBallon ?? '');
    _typeTuyauterie =
        TextEditingController(text: data?.typeTuyauterie ?? '');
    _typeRaccordement =
        TextEditingController(text: data?.typeRaccordementEvacuation ?? '');
    _diametre = TextEditingController(text: data?.diametre ?? '');
    _typeAlimentationElectrique =
        TextEditingController(text: data?.typeAlimentationElectrique ?? '');
    _commentaireController = TextEditingController(text: data?.commentaire ?? '');

    _chauffageSeul = data?.chauffageSeul;
    _avecEcs = data?.avecEcs;
    _radiateur = data?.radiateur;
    _plancherChauffant = data?.plancherChauffant;
    _tuyauxDerriereChaudiere = data?.tuyauxDerriereChaudiere;
    _besoinPompeRelevage = data?.besoinPompeRelevage;
    _typeBallonEcs = data?.typeBallonEcs;
  }

  @override
  void dispose() {
    _introController.dispose();
    _marqueController.dispose();
    _modeleController.dispose();
    _anneeInstallationController.dispose();
    _energieController.dispose();
    _puissanceController.dispose();
    _volumeBallonController.dispose();
    _marqueBallon.dispose();
    _hauteurBallonController.dispose();
    _profondeurBallonController.dispose();
    _typeTuyauterie.dispose();
    _typeRaccordement.dispose();
    _diametre.dispose();
    _typeAlimentationElectrique.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = ChaudiereSection(
      marque: _marqueController.text.isEmpty ? null : _marqueController.text,
      modele: _modeleController.text.isEmpty ? null : _modeleController.text,
      anneeInstallation: _anneeInstallationController.text.isEmpty
          ? null
          : int.tryParse(_anneeInstallationController.text),
      energie: _energieController.text.isEmpty ? null : _energieController.text,
      puissance:
          _puissanceController.text.isEmpty ? null : _puissanceController.text,
      chauffageSeul: _chauffageSeul,
      avecEcs: _avecEcs,
      typeBallonEcs: _typeBallonEcs,
      volumeBallon:
          _volumeBallonController.text.isEmpty ? null : _volumeBallonController.text,
      marqueBallon:
          _marqueBallon.text.isEmpty ? null : _marqueBallon.text,
      hauteurBallon:
          _hauteurBallonController.text.isEmpty ? null : _hauteurBallonController.text,
      profondeurBallon: _profondeurBallonController.text.isEmpty
          ? null
          : _profondeurBallonController.text,
      radiateur: _radiateur,
      plancherChauffant: _plancherChauffant,
      typeTuyauterie:
          _typeTuyauterie.text.isEmpty ? null : _typeTuyauterie.text,
      tuyauxDerriereChaudiere: _tuyauxDerriereChaudiere,
      typeRaccordementEvacuation:
          _typeRaccordement.text.isEmpty ? null : _typeRaccordement.text,
      diametre: _diametre.text.isEmpty ? null : _diametre.text,
      besoinPompeRelevage: _besoinPompeRelevage,
      typeAlimentationElectrique: _typeAlimentationElectrique.text.isEmpty
          ? null
          : _typeAlimentationElectrique.text,
      commentaire:
          _commentaireController.text.isEmpty ? null : _commentaireController.text,
    );
    widget.onUpdate(section);
  }

  @override
  Widget build(BuildContext context) {
    final fade = buildStaggeredFade(_introController, 0);
    final slide = buildStaggeredSlide(fade);
    return buildFadeSlide(
      fade: fade,
      slide: slide,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
        Text('Équipement Chaudière',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _marqueController,
          decoration: const InputDecoration(
            labelText: 'Marque',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _modeleController,
          decoration: const InputDecoration(
            labelText: 'Modèle',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _anneeInstallationController,
          decoration: const InputDecoration(
            labelText: 'Année installation',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _energieController,
          decoration: const InputDecoration(
            labelText: 'Énergie (GPL, GN, Fioul)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _puissanceController,
          decoration: const InputDecoration(
            labelText: 'Puissance (kW)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Chauffage seul'),
          value: _chauffageSeul ?? false,
          onChanged: (val) {
            setState(() => _chauffageSeul = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Avec ECS'),
          value: _avecEcs ?? false,
          onChanged: (val) {
            setState(() => _avecEcs = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Ballons ECS', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _typeBallonEcs,
          decoration: const InputDecoration(
            labelText: 'Type ballon ECS',
            border: OutlineInputBorder(),
          ),
          items: [
            'Ballon séparé',
            'Instantané',
            'Micro-accumulation',
            'Mixte',
          ]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() => _typeBallonEcs = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _volumeBallonController,
          decoration: const InputDecoration(
            labelText: 'Volume ballon (L)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _marqueBallon,
          decoration: const InputDecoration(
            labelText: 'Marque ballon',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _hauteurBallonController,
          decoration: const InputDecoration(
            labelText: 'Hauteur ballon (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _profondeurBallonController,
          decoration: const InputDecoration(
            labelText: 'Profondeur ballon (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Installation', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Radiateurs'),
          value: _radiateur ?? false,
          onChanged: (val) {
            setState(() => _radiateur = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Plancher chauffant'),
          value: _plancherChauffant ?? false,
          onChanged: (val) {
            setState(() => _plancherChauffant = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _typeTuyauterie,
          decoration: const InputDecoration(
            labelText: 'Type tuyauterie',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        CheckboxListTile(
          title: const Text('Tuyaux derrière chaudière'),
          value: _tuyauxDerriereChaudiere ?? false,
          onChanged: (val) {
            setState(() => _tuyauxDerriereChaudiere = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Raccordements', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _typeRaccordement,
          decoration: const InputDecoration(
            labelText: 'Type évacuation',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _diametre,
          decoration: const InputDecoration(
            labelText: 'Diamètre',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        CheckboxListTile(
          title: const Text('Besoin pompe relevage'),
          value: _besoinPompeRelevage ?? false,
          onChanged: (val) {
            setState(() => _besoinPompeRelevage = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _typeAlimentationElectrique,
          decoration: const InputDecoration(
            labelText: 'Type alimentation électrique',
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
      ),
    );
  }
}
