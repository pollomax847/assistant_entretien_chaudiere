import 'package:flutter/material.dart';
import '../../models/sections/conformite_section.dart';
import '../../../utils/mixins/mixins.dart';

/// Tab Écran - Conformité
class ConformiteTab extends StatefulWidget {
  final ConformiteSection? initialData;
  final Function(ConformiteSection) onUpdate;

  const ConformiteTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _ConformiteTabState createState() => _ConformiteTabState();
}

class _ConformiteTabState extends State<ConformiteTab>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  late TextEditingController _raisonController;
  late TextEditingController _commentaireController;

  bool? _compteurPlus20m;
  bool? _organeCoupure;
  bool? _alimenteeLigneSeparee;
  bool? _priseTerragePresente;
  bool? _robinetArretGeneralPresent;
  bool? _flexibleGazNonPerime;
  bool? _testNonRotationOk;
  bool? _ameneeAirPresente;
  bool? _extracteurMotorisePresent;
  bool? _boucheVmcSanitairePresente;
  bool? _foyerOuvert;
  bool? _clapet;
  bool? _conformeReglementationGaz;
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
    _raisonController = TextEditingController(text: data?.raison ?? '');
    _commentaireController = TextEditingController(text: data?.commentaire ?? '');

    _compteurPlus20m = data?.compteurPlus20m;
    _organeCoupure = data?.organeCoupure;
    _alimenteeLigneSeparee = data?.alimenteeLigneSeparee;
    _priseTerragePresente = data?.priseTerragePresente;
    _robinetArretGeneralPresent = data?.robinetArretGeneralPresent;
    _flexibleGazNonPerime = data?.flexibleGazNonPerime;
    _testNonRotationOk = data?.testNonRotationOk;
    _ameneeAirPresente = data?.ameneeAirPresente;
    _extracteurMotorisePresent = data?.extracteurMotorisePresent;
    _boucheVmcSanitairePresente = data?.boucheVmcSanitairePresente;
    _foyerOuvert = data?.foyerOuvert;
    _clapet = data?.clapet;
    _conformeReglementationGaz = data?.conformeReglementationGaz;
  }

  @override
  void dispose() {
    _introController.dispose();
    _raisonController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = ConformiteSection(
      compteurPlus20m: _compteurPlus20m,
      organeCoupure: _organeCoupure,
      alimenteeLigneSeparee: _alimenteeLigneSeparee,
      priseTerragePresente: _priseTerragePresente,
      robinetArretGeneralPresent: _robinetArretGeneralPresent,
      flexibleGazNonPerime: _flexibleGazNonPerime,
      testNonRotationOk: _testNonRotationOk,
      ameneeAirPresente: _ameneeAirPresente,
      extracteurMotorisePresent: _extracteurMotorisePresent,
      boucheVmcSanitairePresente: _boucheVmcSanitairePresente,
      foyerOuvert: _foyerOuvert,
      clapet: _clapet,
      conformeReglementationGaz: _conformeReglementationGaz,
      raison: _raisonController.text.isEmpty ? null : _raisonController.text,
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
        Text('Vérifications Obligatoires',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Compteur > 20m'),
          value: _compteurPlus20m ?? false,
          onChanged: (val) {
            setState(() => _compteurPlus20m = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Organe coupure'),
          value: _organeCoupure ?? false,
          onChanged: (val) {
            setState(() => _organeCoupure = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Alimentée ligne séparée'),
          value: _alimenteeLigneSeparee ?? false,
          onChanged: (val) {
            setState(() => _alimenteeLigneSeparee = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Prise terrage présente'),
          value: _priseTerragePresente ?? false,
          onChanged: (val) {
            setState(() => _priseTerragePresente = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Robinet arrêt général'),
          value: _robinetArretGeneralPresent ?? false,
          onChanged: (val) {
            setState(() => _robinetArretGeneralPresent = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Sécurité Gaz', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Flexible gaz non périmé'),
          value: _flexibleGazNonPerime ?? false,
          onChanged: (val) {
            setState(() => _flexibleGazNonPerime = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Test non-rotation OK'),
          value: _testNonRotationOk ?? false,
          onChanged: (val) {
            setState(() => _testNonRotationOk = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Ventilation', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Amenée d\'air présente'),
          value: _ameneeAirPresente ?? false,
          onChanged: (val) {
            setState(() => _ameneeAirPresente = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Extracteur motorisé'),
          value: _extracteurMotorisePresent ?? false,
          onChanged: (val) {
            setState(() => _extracteurMotorisePresent = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Bouche VMC sanitaire'),
          value: _boucheVmcSanitairePresente ?? false,
          onChanged: (val) {
            setState(() => _boucheVmcSanitairePresente = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        Text('Foyer Ouvert', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Foyer ouvert'),
          value: _foyerOuvert ?? false,
          onChanged: (val) {
            setState(() => _foyerOuvert = val);
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
        const SizedBox(height: 16),
        Text('Conformité Générale',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Conforme réglementation gaz'),
          value: _conformeReglementationGaz ?? false,
          onChanged: (val) {
            setState(() => _conformeReglementationGaz = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _raisonController,
          decoration: const InputDecoration(
            labelText: 'Raison si non-conforme',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
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
