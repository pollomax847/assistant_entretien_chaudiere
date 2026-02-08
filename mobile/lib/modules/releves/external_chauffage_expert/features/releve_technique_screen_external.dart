// features/releves/_releve_technique_screen.dart (externe adapted)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../widgets/_photo_manager.dart';

enum TypeReleve { chaudiere, pac, clim }

class ReleveTechniqueScreenExternal extends StatefulWidget {
  final TypeReleve type;
  final dynamic releve;

  const ReleveTechniqueScreenExternal({
    super.key,
    required this.type,
    this.releve,
  });

  @override
  ReleveTechniqueScreenExternalState createState() => ReleveTechniqueScreenExternalState();
}

class ReleveTechniqueScreenExternalState extends State<ReleveTechniqueScreenExternal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, Map<String, TextEditingController>> _controllers = {};
  bool _isEditing = true;
  int _nombreReleves = 0;
  Map<String, List<String>> sections = {};

  @override
  void initState() {
    super.initState();
    _initializeSections();
    _initializeControllers();
    _chargerNombreReleves();
    _obtenirPosition();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _initializeSections() {
    sections = {
      "Informations générales": [
        "Numéro de relevé: ",
        "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
        "Entreprise: ",
        "Technicien: ",
        "Adresse: ",
      ],
      "Caractéristiques": _getCaracteristiquesForType(),
      "Mesures": _getMesuresForType(),
      "Résultats": _getResultatsForType(),
    };
  }

  List<String> _getCaracteristiquesForType() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return [
          "Marque: ",
          "Modèle: ",
          "Type: ",
          "Puissance: ",
          "Année: ",
          "N° de série: ",
        ];
      case TypeReleve.pac:
        return [
          "Surface habitable: ",
          "Hauteur sous plafond: ",
          "Type de logement: ",
          "Année de construction: ",
          "Niveau d'isolation: Moyenne",
          "Type de vitrage: ",
        ];
      case TypeReleve.clim:
        return [
          "Surface de la pièce: ",
          "Hauteur sous plafond: ",
          "Exposition: ",
          "Type d'utilisation: ",
          "Nombre d'occupants: ",
        ];
    }
  }

  List<String> _getMesuresForType() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return [
          "Température fumées: ",
          "CO2: ",
          "O2: ",
          "CO: ",
          "NOx: ",
          "Rendement: ",
        ];
      case TypeReleve.pac:
        return [
          "Température extérieure: ",
          "Température intérieure: ",
          "Delta T: ",
          "Pression circuit: ",
          "COP: ",
        ];
      case TypeReleve.clim:
        return [
          "Température entrée: ",
          "Température sortie: ",
          "Delta T: ",
          "Humidité relative: ",
          "Pression circuit: ",
        ];
    }
  }

  List<String> _getResultatsForType() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return [
          "État général: ",
          "Recommandations: ",
          "Prochain entretien: ",
          "Pièces à prévoir: ",
        ];
      case TypeReleve.pac:
        return [
          "Puissance calculée: ",
          "Recommandations: ",
          "Actions à prévoir: ",
          "Prochain entretien: ",
        ];
      case TypeReleve.clim:
        return [
          "Puissance frigorifique: ",
          "État des filtres: ",
          "Recommandations: ",
          "Prochain entretien: ",
        ];
    }
  }

  void _initializeControllers() {
    for (var section in sections.entries) {
      _controllers[section.key] = {};
      for (var field in section.value) {
        String key = field.split(":")[0];
        String value = field.split(": ").length > 1 ? field.split(": ")[1] : "";
        _controllers[section.key]![key] = TextEditingController(text: value);
      }
    }
  }

  Future<void> _chargerNombreReleves() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreReleves = prefs.getInt(
              'nombre_releves_${widget.type.toString().split('.').last.toLowerCase()}') ??
          0;
      final numeroReleve = _genererNumeroReleve();
      _controllers["Informations générales"]?["Numéro de relevé"]?.text =
          numeroReleve;
    });
  }

  String _genererNumeroReleve() {
    final date = DateTime.now();
    final numero = (_nombreReleves + 1).toString().padLeft(4, '0');
    final prefix = widget.type.toString().split('.').last;
    return '${prefix}_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}_$numero';
  }

  Future<void> _obtenirPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'La géolocalisation n\'est pas disponible. Veuillez saisir l\'adresse manuellement.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final adresse =
            "${place.street}, ${place.postalCode} ${place.locality}";
        setState(() {
          _controllers["Informations générales"]?["Adresse"]?.text = adresse;
        });
      }
    } catch (e) {
      print("Erreur de géolocalisation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Erreur de géolocalisation. Veuillez saisir l\'adresse manuellement.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildSection(String sectionName, List<String> fields) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (sectionName == "Informations générales") ...[
            _buildPhotoSection(),
            const SizedBox(height: 16),
            _buildAdresseField(),
          ],
          ...fields.map((field) {
            String label = field.split(":")[0];
            return _buildField(sectionName, label, field);
          }),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    String clientId =
        _controllers["Informations générales"]?['Numéro de relevé']?.text ??
            "default";
    clientId = clientId.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PhotoManager(
          photos: const [],
          clientId: clientId,
          typeReleve: widget.type.toString().split('.').last,
          onPhotosChanged: (newPhotos) {
            // Gérer les nouvelles photos
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildField(String section, String label, String field) {
    final controller = _controllers[section]![label];
    bool isDate = label.toLowerCase().contains("date");
    bool isNumeric = [
      "température",
      "puissance",
      "surface",
      "hauteur",
      "pression",
      "rendement",
      "cop",
    ].any((term) => label.toLowerCase().contains(term));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (isDate)
              _buildDateField(controller!)
            else if (isNumeric)
              _buildNumericField(controller!, label)
            else
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Entrez ${label.toLowerCase()}',
                ),
                enabled: _isEditing,
                maxLines:
                    label.toLowerCase().contains("recommandations") ? 3 : 1,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      enabled: _isEditing,
      onTap: _isEditing
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (date != null) {
                controller.text = DateFormat('dd/MM/yyyy').format(date);
              }
            }
          : null,
    );
  }

  Widget _buildNumericField(TextEditingController controller, String label) {
    String? suffix;
    if (label.toLowerCase().contains("température")) {
      suffix = "°C";
    } else if (label.toLowerCase().contains("puissance"))
      suffix = "kW";
    else if (label.toLowerCase().contains("surface"))
      suffix = "m²";
    else if (label.toLowerCase().contains("hauteur"))
      suffix = "m";
    else if (label.toLowerCase().contains("pression"))
      suffix = "bar";
    else if (label.toLowerCase().contains("rendement") ||
        label.toLowerCase().contains("cop")) suffix = "%";

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixText: suffix,
      ),
      enabled: _isEditing,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildAdresseField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controllers["Informations générales"]?['Adresse'],
            decoration: const InputDecoration(
              labelText: 'Adresse de l\'intervention',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: _isEditing ? _obtenirPosition : null,
          tooltip: 'Utiliser ma position',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String titre = switch (widget.type) {
      TypeReleve.chaudiere => 'Relevé Technique Chaudière',
      TypeReleve.pac => 'Relevé Technique PAC',
      TypeReleve.clim => 'Relevé Technique Climatisation',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(titre),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Informations"),
            Tab(text: "Caractéristiques"),
            Tab(text: "Mesures"),
            Tab(text: "Résultats"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: sections.entries
            .map((section) => _buildSection(section.key, section.value))
            .toList(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var sectionControllers in _controllers.values) {
      for (var controller in sectionControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}
