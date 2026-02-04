import 'package:flutter/material.dart';
import '../../models/releve_technique.dart';
import '../../models/sections/client_section.dart';

/// Tab Écran - Client
/// Gère les informations du client et de l'environnement
class ClientTab extends StatefulWidget {
  final ClientSection? initialData;
  final Function(ClientSection) onUpdate;

  const ClientTab({
    Key? key,
    this.initialData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _ClientTabState createState() => _ClientTabState();
}

class _ClientTabState extends State<ClientTab> {
  late TextEditingController _numeroController;
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _telephonePortableController;
  late TextEditingController _adresseController;
  late TextEditingController _nomTechnicienController;
  late TextEditingController _matriculeTechnicienController;
  late TextEditingController _surfaceController;
  late TextEditingController _occupantsController;
  late TextEditingController _anneeConstructionController;
  late TextEditingController _piecesController;

  bool? _estAppartement;
  bool? _estPavillon;
  bool? _reperageAmiante;
  bool? _accordCopropriete;
  DateTime? _dateVisite;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final data = widget.initialData;
    _numeroController = TextEditingController(text: data?.numero ?? '');
    _nomController = TextEditingController(text: data?.nom ?? '');
    _emailController = TextEditingController(text: data?.email ?? '');
    _telephoneController = TextEditingController(text: data?.telephone ?? '');
    _telephonePortableController =
        TextEditingController(text: data?.telephonePortable ?? '');
    _adresseController =
        TextEditingController(text: data?.adresseChantier ?? '');
    _nomTechnicienController =
        TextEditingController(text: data?.nomTechnicien ?? '');
    _matriculeTechnicienController =
        TextEditingController(text: data?.matriculeTechnicien ?? '');
    _surfaceController = TextEditingController(text: data?.surface ?? '');
    _occupantsController =
        TextEditingController(text: data?.nombreOccupants?.toString() ?? '');
    _anneeConstructionController =
        TextEditingController(text: data?.anneeConstruction?.toString() ?? '');
    _piecesController =
        TextEditingController(text: data?.nombrePieces?.toString() ?? '');

    _estAppartement = data?.estAppartement;
    _estPavillon = data?.estPavillon;
    _reperageAmiante = data?.reperageAmiante;
    _accordCopropriete = data?.accordCopropriete;
    _dateVisite = data?.dateVisite;
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _telephonePortableController.dispose();
    _adresseController.dispose();
    _nomTechnicienController.dispose();
    _matriculeTechnicienController.dispose();
    _surfaceController.dispose();
    _occupantsController.dispose();
    _anneeConstructionController.dispose();
    _piecesController.dispose();
    super.dispose();
  }

  void _saveData() {
    final section = ClientSection(
      numero: _numeroController.text.isEmpty ? null : _numeroController.text,
      nom: _nomController.text.isEmpty ? null : _nomController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      telephone:
          _telephoneController.text.isEmpty ? null : _telephoneController.text,
      telephonePortable: _telephonePortableController.text.isEmpty
          ? null
          : _telephonePortableController.text,
      adresseChantier:
          _adresseController.text.isEmpty ? null : _adresseController.text,
      nomTechnicien: _nomTechnicienController.text.isEmpty
          ? null
          : _nomTechnicienController.text,
      matriculeTechnicien: _matriculeTechnicienController.text.isEmpty
          ? null
          : _matriculeTechnicienController.text,
      dateVisite: _dateVisite,
      estAppartement: _estAppartement,
      estPavillon: _estPavillon,
      surface: _surfaceController.text.isEmpty ? null : _surfaceController.text,
      nombreOccupants: _occupantsController.text.isEmpty
          ? null
          : _occupantsController.text,
      anneeConstruction: _anneeConstructionController.text.isEmpty
          ? null
          : int.tryParse(_anneeConstructionController.text),
      reperageAmiante: _reperageAmiante,
      accordCopropriete: _accordCopropriete,
      nombrePieces: _piecesController.text.isEmpty
          ? null
          : _piecesController.text,
    );
    widget.onUpdate(section);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section Client
        Text('Client', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _numeroController,
          decoration: const InputDecoration(
            labelText: 'Numéro client',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nomController,
          decoration: const InputDecoration(
            labelText: 'Nom',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _telephoneController,
          decoration: const InputDecoration(
            labelText: 'Téléphone fixe',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _telephonePortableController,
          decoration: const InputDecoration(
            labelText: 'Téléphone portable',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _adresseController,
          decoration: const InputDecoration(
            labelText: 'Adresse du chantier',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          onChanged: (_) => _saveData(),
        ),

        // Section Technicien
        const SizedBox(height: 24),
        Text('Technicien', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          controller: _nomTechnicienController,
          decoration: const InputDecoration(
            labelText: 'Nom du technicien',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _matriculeTechnicienController,
          decoration: const InputDecoration(
            labelText: 'Matricule',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateVisite ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() => _dateVisite = date);
              _saveData();
            }
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(
            _dateVisite == null
                ? 'Choisir date visite'
                : 'Visite: ${_dateVisite!.day}/${_dateVisite!.month}/${_dateVisite!.year}',
          ),
        ),

        // Section Environnement
        const SizedBox(height: 24),
        Text('Environnement', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Appartement'),
                value: _estAppartement ?? false,
                onChanged: (val) {
                  setState(() => _estAppartement = val);
                  _saveData();
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Pavillon'),
                value: _estPavillon ?? false,
                onChanged: (val) {
                  setState(() => _estPavillon = val);
                  _saveData();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _surfaceController,
          decoration: const InputDecoration(
            labelText: 'Surface (m²)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _occupantsController,
          decoration: const InputDecoration(
            labelText: 'Nombre d\'occupants',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _anneeConstructionController,
          decoration: const InputDecoration(
            labelText: 'Année construction',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _piecesController,
          decoration: const InputDecoration(
            labelText: 'Nombre de pièces',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _saveData(),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Repérage amiante'),
          value: _reperageAmiante ?? false,
          onChanged: (val) {
            setState(() => _reperageAmiante = val);
            _saveData();
          },
        ),
        CheckboxListTile(
          title: const Text('Accord copropriété'),
          value: _accordCopropriete ?? false,
          onChanged: (val) {
            setState(() => _accordCopropriete = val);
            _saveData();
          },
        ),
      ],
    );
  }
}
