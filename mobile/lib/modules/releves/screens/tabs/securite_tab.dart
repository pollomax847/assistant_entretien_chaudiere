import 'package:flutter/material.dart';
import '../../models/sections/securite_section.dart';

/// Tab Écran - Sécurité
class SecuriteTab extends StatefulWidget {
  final SecuriteSection? initialData;
  final Function(SecuriteSection) onUpdate;

  const SecuriteTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _SecuriteTabState createState() => _SecuriteTabState();
}

class _SecuriteTabState extends State<SecuriteTab> {
  late TextEditingController _commentaireAccessibiliteController;
  late TextEditingController _particularitesController;
  late TextEditingController _travailsAChargerController;
  late TextEditingController _travailsAMentionnerController;

  bool? _tousAccesOk;
  bool? _travauxHauteur;
  bool? _echafaudageNecessaire;
  bool? _toitPentu;
  bool? _comblePresent;
  bool? _cavitePresente;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData;
    _commentaireAccessibiliteController =
        TextEditingController(text: data?.commentaireAccessibilite ?? '');
    _particularitesController =
        TextEditingController(text: data?.particularites ?? '');
    _travailsAChargerController =
        TextEditingController(text: data?.travailsACharger ?? '');
    _travailsAMentionnerController =
        TextEditingController(text: data?.travailsAMentionner ?? '');

    _tousAccesOk = data?.tousAccesOk;
    _travauxHauteur = data?.travauxHauteur;
    _echafaudageNecessaire = data?.echafaudageNecessaire;
    _toitPentu = data?.toitPentu;
    _comblePresent = data?.comblePresent;
    _cavitePresente = data?.cavitePresente;
  }

  @override
  void dispose() {
    _commentaireAccessibiliteController.dispose();
    _particularitesController.dispose();
    _travailsAChargerController.dispose();
    _travailsAMentionnerController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = SecuriteSection(
      tousAccesOk: _tousAccesOk,
      travauxHauteur: _travauxHauteur,
      echafaudageNecessaire: _echafaudageNecessaire,
      commentaireAccessibilite: _commentaireAccessibiliteController.text.isEmpty
          ? null
          : _commentaireAccessibiliteController.text,
      toitPentu: _toitPentu,
      comblePresent: _comblePresent,
      cavitePresente: _cavitePresente,
      particularites: _particularitesController.text.isEmpty
          ? null
          : _particularitesController.text,
      travailsACharger: _travailsAChargerController.text.isEmpty
          ? null
          : _travailsAChargerController.text,
      travailsAMentionner: _travailsAMentionnerController.text.isEmpty
          ? null
          : _travailsAMentionnerController.text,
    );
    widget.onUpdate(section);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Accessibilité Lieu',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Tous accès OK'),
          value: _tousAccesOk ?? false,
          onChanged: (val) {
            setState(() => _tousAccesOk = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Travaux en hauteur'),
          value: _travauxHauteur ?? false,
          onChanged: (val) {
            setState(() => _travauxHauteur = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Échafaudage nécessaire'),
          value: _echafaudageNecessaire ?? false,
          onChanged: (val) {
            setState(() => _echafaudageNecessaire = val);
            _saveData();
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _commentaireAccessibiliteController,
          decoration: const InputDecoration(
            labelText: 'Commentaire accessibilité',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Conditions Spéciales',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Toit pentu'),
          value: _toitPentu ?? false,
          onChanged: (val) {
            setState(() => _toitPentu = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Comble présent'),
          value: _comblePresent ?? false,
          onChanged: (val) {
            setState(() => _comblePresent = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Cavité présente'),
          value: _cavitePresente ?? false,
          onChanged: (val) {
            setState(() => _cavitePresente = val);
            _saveData();
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _particularitesController,
          decoration: const InputDecoration(
            labelText: 'Particularités du chantier',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 16),
        Text('Travaux à Signaler',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _travailsAChargerController,
          decoration: const InputDecoration(
            labelText: 'Travaux à charger',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _travailsAMentionnerController,
          decoration: const InputDecoration(
            labelText: 'Travaux à mentionner',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (_) => _saveData(),
        ),
      ],
    );
  }
}
