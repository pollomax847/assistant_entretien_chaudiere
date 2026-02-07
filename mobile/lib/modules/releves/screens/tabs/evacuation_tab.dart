import 'package:flutter/material.dart';
import '../../models/sections/evacuation_section.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/mixins.dart';

/// Tab Écran - Évacuation
class EvacuationTab extends StatefulWidget {
  final EvacuationSection? initialData;
  final Function(EvacuationSection) onUpdate;

  const EvacuationTab({
    super.key,
    this.initialData,
    required this.onUpdate,
  });

  @override
  State<EvacuationTab> createState() => _EvacuationTabState();
}

class _EvacuationTabState extends State<EvacuationTab>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  late TextEditingController _typeEvacuationController;
  late TextEditingController _diameterController;
  late TextEditingController _materiereController;
  late TextEditingController _longueurController;
  late TextEditingController _nombreCoudes90Controller;
  late TextEditingController _nombreCoudes45Controller;
  late TextEditingController _longueurTubageController;
  late TextEditingController _hauteurSortieController;
  late TextEditingController _diameterVentouseController;
  late TextEditingController _distanceParoiController;
  late TextEditingController _commentaireController;

  bool? _conduitRigide;
  bool? _tubage;
  bool? _sortieCheminee;
  bool? _sortieToiture;
  bool? _sortieParMur;
  bool? _depassementNormes;
  bool? _ventouseVerticale;
  bool? _ventouseHorizontale;
  bool? _puregePresente;
  bool? _bouchonGaz;
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
    _typeEvacuationController =
        TextEditingController(text: data?.typeEvacuation ?? '');
    _diameterController = TextEditingController(text: data?.diametre ?? '');
    _materiereController = TextEditingController(text: data?.matiere ?? '');
    _longueurController = TextEditingController(text: data?.longueur ?? '');
    _nombreCoudes90Controller =
        TextEditingController(text: data?.nombreCoudes90 ?? '');
    _nombreCoudes45Controller =
        TextEditingController(text: data?.nombreCoudes45 ?? '');
    _longueurTubageController =
        TextEditingController(text: data?.longueurTubage ?? '');
    _hauteurSortieController =
        TextEditingController(text: data?.hauteurSortieToiture ?? '');
    _diameterVentouseController =
        TextEditingController(text: data?.diameterVentouse ?? '');
    _distanceParoiController =
        TextEditingController(text: data?.distanceParoiVoisine ?? '');
    _commentaireController = TextEditingController(text: data?.commentaire ?? '');

    _conduitRigide = data?.conduitRigide;
    _tubage = data?.tubage;
    _sortieCheminee = data?.sortieCheminee;
    _sortieToiture = data?.sortieToiture;
    _sortieParMur = data?.sortieParMur;
    _depassementNormes = data?.depassementNormes;
    _ventouseVerticale = data?.ventouseVerticale;
    _ventouseHorizontale = data?.ventouseHorizontale;
    _puregePresente = data?.puregePresente;
    _bouchonGaz = data?.bouchonGaz;
  }

  @override
  void dispose() {
    _introController.dispose();
    _typeEvacuationController.dispose();
    _diameterController.dispose();
    _materiereController.dispose();
    _longueurController.dispose();
    _nombreCoudes90Controller.dispose();
    _nombreCoudes45Controller.dispose();
    _longueurTubageController.dispose();
    _hauteurSortieController.dispose();
    _diameterVentouseController.dispose();
    _distanceParoiController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = EvacuationSection(
      typeEvacuation: _typeEvacuationController.text.isEmpty
          ? null
          : _typeEvacuationController.text,
      conduitRigide: _conduitRigide,
      diametre: _diameterController.text.isEmpty ? null : _diameterController.text,
      matiere: _materiereController.text.isEmpty ? null : _materiereController.text,
      longueur: _longueurController.text.isEmpty ? null : _longueurController.text,
      nombreCoudes90: _nombreCoudes90Controller.text.isEmpty
          ? null
          : _nombreCoudes90Controller.text,
      nombreCoudes45: _nombreCoudes45Controller.text.isEmpty
          ? null
          : _nombreCoudes45Controller.text,
      tubage: _tubage,
      longueurTubage: _longueurTubageController.text.isEmpty
          ? null
          : _longueurTubageController.text,
      sortieCheminee: _sortieCheminee,
      sortieToiture: _sortieToiture,
      sortieParMur: _sortieParMur,
      hauteurSortieToiture: _hauteurSortieController.text.isEmpty
          ? null
          : _hauteurSortieController.text,
      depassementNormes: _depassementNormes,
      diameterVentouse: _diameterVentouseController.text.isEmpty
          ? null
          : _diameterVentouseController.text,
      ventouseVerticale: _ventouseVerticale,
      ventouseHorizontale: _ventouseHorizontale,
      distanceParoiVoisine: _distanceParoiController.text.isEmpty
          ? null
          : _distanceParoiController.text,
      puregePresente: _puregePresente,
      bouchonGaz: _bouchonGaz,
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
        Text('Système d\'Évacuation',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _typeEvacuationController,
          decoration: const InputDecoration(
            labelText: 'Type d\'évacuation',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Conduit rigide'),
          value: _conduitRigide ?? false,
          onChanged: (val) {
            setState(() => _conduitRigide = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _diameterController,
          decoration: const InputDecoration(
            labelText: 'Diamètre (mm)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _materiereController,
          decoration: const InputDecoration(
            labelText: 'Matière',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _longueurController,
          decoration: const InputDecoration(
            labelText: 'Longueur (m)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nombreCoudes90Controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de coudes 90°',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nombreCoudes45Controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de coudes 45°',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Tubage'),
          value: _tubage ?? false,
          onChanged: (val) {
            setState(() => _tubage = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _longueurTubageController,
          decoration: const InputDecoration(
            labelText: 'Longueur tubage (m)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Sortie', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Sortie cheminée'),
          value: _sortieCheminee ?? false,
          onChanged: (val) {
            setState(() => _sortieCheminee = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Sortie toiture'),
          value: _sortieToiture ?? false,
          onChanged: (val) {
            setState(() => _sortieToiture = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Sortie par mur'),
          value: _sortieParMur ?? false,
          onChanged: (val) {
            setState(() => _sortieParMur = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _hauteurSortieController,
          decoration: const InputDecoration(
            labelText: 'Hauteur sortie toiture (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Dépassement normes'),
          value: _depassementNormes ?? false,
          onChanged: (val) {
            setState(() => _depassementNormes = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Ventouse', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          controller: _diameterVentouseController,
          decoration: const InputDecoration(
            labelText: 'Diamètre ventouse',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Ventouse verticale'),
          value: _ventouseVerticale ?? false,
          onChanged: (val) {
            setState(() => _ventouseVerticale = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Ventouse horizontale'),
          value: _ventouseHorizontale ?? false,
          onChanged: (val) {
            setState(() => _ventouseHorizontale = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _distanceParoiController,
          decoration: const InputDecoration(
            labelText: 'Distance paroi voisine (cm)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Purge présente'),
          value: _puregePresente ?? false,
          onChanged: (val) {
            setState(() => _puregePresente = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Bouchon gaz'),
          value: _bouchonGaz ?? false,
          onChanged: (val) {
            setState(() => _bouchonGaz = val);
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
      ),
    );
  }
}
