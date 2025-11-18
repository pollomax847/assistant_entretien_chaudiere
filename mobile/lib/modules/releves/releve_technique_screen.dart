import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

enum TypeReleve { chaudiere, pac, climatisation }

class ReleveTechniqueScreen extends StatefulWidget {
  final TypeReleve type;
  
  const ReleveTechniqueScreen({
    super.key,
    required this.type,
  });

  @override
  State<ReleveTechniqueScreen> createState() => _ReleveTechniqueScreenState();
}

class _ReleveTechniqueScreenState extends State<ReleveTechniqueScreen>
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  final Map<String, Map<String, TextEditingController>> _controllers = {};
  
  int _nombreReleves = 0;
  String _nomEntreprise = '';
  String _nomTechnicien = '';
  
  Map<String, List<String>> sections = {};

  @override
  void initState() {
    super.initState();
    _initializeSections();
    _initializeControllers();
    _chargerDonnees();
    _tabController = TabController(length: sections.length, vsync: this);
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomEntreprise = prefs.getString('entrepriseNom') ?? '';
      _nomTechnicien = prefs.getString('technicienNom') ?? '';
      _nombreReleves = prefs.getInt('nombre_releves_${widget.type.name}') ?? 0;
    });
  }

  void _initializeSections() {
    final sectionsBase = {
      "Informations générales": [
        "Numéro de relevé: ",
        "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
        "Entreprise: ",
        "Technicien: ",
        "Adresse intervention: ",
        "Client: ",
        "Téléphone: ",
      ],
    };

    switch (widget.type) {
      case TypeReleve.chaudiere:
        sections = {
          ...sectionsBase,
          "Caractéristiques Chaudière": [
            "Marque: ",
            "Modèle: ",
            "Puissance nominale (kW): ",
            "Type de combustible: ",
            "Année d'installation: ",
            "Numéro de série: ",
            "Type de chaudière: ",
          ],
          "Mesures": [
            "Température fumées (°C): ",
            "Température ambiante (°C): ",
            "CO2 (%): ",
            "CO ambiant (ppm): ",
            "Tirage (Pa): ",
            "Pression gaz (mbar): ",
            "Rendement (%): ",
          ],
          "Installation": [
            "Type d'évacuation: ",
            "Etat conduit: ",
            "Alimentation gaz: ",
            "Sécurité gaz: ",
            "Régulation: ",
            "Circulateur: ",
          ],
          "Observations": [
            "Défauts constatés: ",
            "Travaux recommandés: ",
            "Conformité installation: ",
            "Prochaine visite: ",
          ],
        };
        break;
        
      case TypeReleve.pac:
        sections = {
          ...sectionsBase,
          "Caractéristiques PAC": [
            "Marque: ",
            "Modèle: ",
            "Puissance nominale (kW): ",
            "Type de PAC: ",
            "Fluide frigorigène: ",
            "Année d'installation: ",
            "COP nominal: ",
          ],
          "Mesures Thermiques": [
            "Température extérieure (°C): ",
            "Température départ (°C): ",
            "Température retour (°C): ",
            "Delta T (°C): ",
            "Débit (l/h): ",
            "Puissance absorbée (kW): ",
          ],
          "Mesures Électriques": [
            "Tension alimentation (V): ",
            "Intensité compresseur (A): ",
            "Intensité total (A): ",
            "Puissance électrique (kW): ",
            "COP mesuré: ",
          ],
          "Observations": [
            "État général: ",
            "Défauts constatés: ",
            "Maintenance effectuée: ",
            "Recommandations: ",
          ],
        };
        break;
        
      case TypeReleve.climatisation:
        sections = {
          ...sectionsBase,
          "Caractéristiques Climatisation": [
            "Marque: ",
            "Modèle: ",
            "Puissance frigorifique (kW): ",
            "Type de fluide: ",
            "Charge en fluide (kg): ",
            "Année d'installation: ",
            "EER nominal: ",
          ],
          "Mesures Frigorifiques": [
            "Température intérieure (°C): ",
            "Température extérieure (°C): ",
            "Humidité relative (%): ",
            "Pression HP (bar): ",
            "Pression BP (bar): ",
            "Surchauffe (°C): ",
            "Sous-refroidissement (°C): ",
          ],
          "Performance": [
            "Puissance absorbée (kW): ",
            "Puissance frigorifique mesurée (kW): ",
            "EER mesuré: ",
            "Débit d'air (m³/h): ",
          ],
          "Observations": [
            "État installation: ",
            "Étanchéité circuit: ",
            "Maintenance effectuée: ",
            "Recommandations: ",
          ],
        };
        break;
    }
  }

  void _initializeControllers() {
    for (String sectionName in sections.keys) {
      _controllers[sectionName] = {};
      for (String field in sections[sectionName]!) {
        String key = field.replaceAll(': ', '');
        _controllers[sectionName]![key] = TextEditingController();
        
        // Pré-remplir certains champs
        if (key.contains('Date')) {
          _controllers[sectionName]![key]!.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
        } else if (key.contains('Entreprise')) {
          _controllers[sectionName]![key]!.text = _nomEntreprise;
        } else if (key.contains('Technicien')) {
          _controllers[sectionName]![key]!.text = _nomTechnicien;
        } else if (key.contains('Numéro de relevé')) {
          _controllers[sectionName]![key]!.text = (_nombreReleves + 1).toString();
        }
      }
    }
  }

  Future<void> _sauvegarderReleve() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Sauvegarder les données du relevé
    Map<String, dynamic> releveData = {};
    for (String sectionName in _controllers.keys) {
      releveData[sectionName] = {};
      for (String fieldKey in _controllers[sectionName]!.keys) {
        releveData[sectionName][fieldKey] = _controllers[sectionName]![fieldKey]!.text;
      }
    }
    
    // Sauvegarder avec timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setString('releve_${widget.type.name}_$timestamp', releveData.toString());
    
    // Incrementer le compteur
    await prefs.setInt('nombre_releves_${widget.type.name}', _nombreReleves + 1);
    
    setState(() {
      _nombreReleves++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relevé sauvegardé avec succès')),
    );
  }

  String _getTitre() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return 'Relevé Technique Chaudière';
      case TypeReleve.pac:
        return 'Relevé Technique PAC';
      case TypeReleve.climatisation:
        return 'Relevé Technique Climatisation';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitre()),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _sauvegarderReleve,
            tooltip: 'Sauvegarder',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: sections.keys.map((section) => Tab(text: section)).toList(),
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

  Widget _buildSection(String sectionName, List<String> fields) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ...fields.map((field) {
            String label = field.replaceAll(': ', '');
            String key = label;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _controllers[sectionName]![key],
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                maxLines: label.toLowerCase().contains('observation') ||
                         label.toLowerCase().contains('défaut') ||
                         label.toLowerCase().contains('recommandation') ? 3 : 1,
                keyboardType: _getKeyboardType(label),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 32),
          
          // Informations sur le relevé
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations du relevé',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Type: ${_getTitre()}'),
                  Text('Nombre de relevés: $_nombreReleves'),
                  Text('Date de création: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType(String label) {
    if (label.toLowerCase().contains('température') ||
        label.toLowerCase().contains('puissance') ||
        label.toLowerCase().contains('pression') ||
        label.toLowerCase().contains('débit') ||
        label.toLowerCase().contains('intensité') ||
        label.toLowerCase().contains('tension') ||
        label.toLowerCase().contains('cop') ||
        label.toLowerCase().contains('eer') ||
        label.toLowerCase().contains('rendement') ||
        label.toLowerCase().contains('humidité') ||
        label.toLowerCase().contains('co2') ||
        label.toLowerCase().contains('tirage')) {
      return TextInputType.number;
    }
    if (label.toLowerCase().contains('téléphone')) {
      return TextInputType.phone;
    }
    if (label.toLowerCase().contains('email')) {
      return TextInputType.emailAddress;
    }
    return TextInputType.text;
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
