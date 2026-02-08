// screens/ballon_tampon_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gestion_pieces_screen.dart';
import 'dimensionnement_radiateurs_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/rapport_bug.dart';

enum TypeBallon { vertical, horizontal, serpentin }

class BallonTamponScreen extends StatefulWidget {
  const BallonTamponScreen({Key? key}) : super(key: key);

  @override
  State<BallonTamponScreen> createState() => _BallonTamponScreenState();
}

class _BallonTamponScreenState extends State<BallonTamponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _puissanceChaudiereController = TextEditingController();
  final _nombrePiecesController = TextEditingController();
  final _surfaceTotaleController = TextEditingController();
  final _hauteurSousPlafondController = TextEditingController();
  final _temperatureDepartController = TextEditingController(text: '80');
  final _temperatureRetourController = TextEditingController(text: '60');
  final _dureeStockageController = TextEditingController(text: '2');
  final _nombreRadiateursFonteController = TextEditingController();
  final _nombreRadiateursAcierController = TextEditingController();
  final _nombreRadiateursAluminiumController = TextEditingController();
  final _nombreRadiateursPanneauController = TextEditingController();
  final _volumeChaudiereController = TextEditingController();
  final _validateurController = TextEditingController();
  final _commentaireController = TextEditingController();
  bool _estValide = false;
  bool _estApprouve = false;

  double? _capaciteBallon;
  double? _puissanceCirculateur;
  double? _debitCirculateur;
  double? _volumeTotalEau;
  List<Map<String, dynamic>>? _pieces;
  double? _puissanceTotaleRadiateurs;
  TypeBallon _typeBallon = TypeBallon.vertical;
  List<String>? _recommandationsCirculateurs;

  @override
  void dispose() {
    _puissanceChaudiereController.dispose();
    _nombrePiecesController.dispose();
    _surfaceTotaleController.dispose();
    _hauteurSousPlafondController.dispose();
    _temperatureDepartController.dispose();
    _temperatureRetourController.dispose();
    _dureeStockageController.dispose();
    _nombreRadiateursFonteController.dispose();
    _nombreRadiateursAcierController.dispose();
    _nombreRadiateursAluminiumController.dispose();
    _nombreRadiateursPanneauController.dispose();
    _volumeChaudiereController.dispose();
    _validateurController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  Future<void> _recupererDonneesPieces() async {
    final result = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(builder: (context) => const GestionPiecesScreen()),
    );

    if (result != null) {
      setState(() {
        _pieces = result;
        _nombrePiecesController.text = result.length.toString();

        // Calcul de la surface totale
        double surfaceTotale = 0;
        for (var piece in result) {
          surfaceTotale += piece['surface'] as double;
        }
        _surfaceTotaleController.text = surfaceTotale.toString();
      });
    }
  }

  Future<void> _recupererDonneesRadiateurs() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const DimensionnementRadiateurs()),
    );

    if (result != null && result is double) {
      setState(() {
        _puissanceTotaleRadiateurs = result;
        _puissanceChaudiereController.text = result.toString();
      });
    }
  }

  List<String> _getRecommandationsCirculateurs(double puissance) {
    if (puissance < 0.1) {
      return ['Grundfos Alpha2 25-40', 'Wilo Stratos PICO 25/1-4'];
    } else if (puissance < 0.2) {
      return ['Grundfos Alpha3 25-40', 'Wilo Stratos PICO 25/1-6'];
    } else if (puissance < 0.3) {
      return ['Grundfos Alpha3 25-60', 'Wilo Stratos PICO 25/1-8'];
    } else {
      return ['Grundfos Alpha3 32-60', 'Wilo Stratos PICO 32/1-8'];
    }
  }

  void _calculerDimensionnement() {
    if (!_formKey.currentState!.validate()) return;

    final puissanceChaudiere = double.parse(_puissanceChaudiereController.text);
    final nombrePieces = int.parse(_nombrePiecesController.text);
    final surfaceTotale = double.parse(_surfaceTotaleController.text);
    final hauteurSousPlafond = double.parse(_hauteurSousPlafondController.text);
    final temperatureDepart = double.parse(_temperatureDepartController.text);
    final temperatureRetour = double.parse(_temperatureRetourController.text);
    final dureeStockage = double.parse(_dureeStockageController.text);

    // Calcul du volume d'eau des radiateurs
    final nombreRadiateursFonte =
        double.tryParse(_nombreRadiateursFonteController.text) ?? 0;
    final nombreRadiateursAcier =
        double.tryParse(_nombreRadiateursAcierController.text) ?? 0;
    final nombreRadiateursAluminium =
        double.tryParse(_nombreRadiateursAluminiumController.text) ?? 0;
    final nombreRadiateursPanneau =
        double.tryParse(_nombreRadiateursPanneauController.text) ?? 0;
    final volumeChaudiere =
        double.tryParse(_volumeChaudiereController.text) ?? 0;

    // Volumes unitaires des radiateurs (en litres)
    const volumeFonte = 11.0;
    const volumeAcier = 7.5;
    const volumeAluminium = 5.5;
    const volumePanneau = 4.5;

    // Calcul du volume total d'eau
    final volumeRadiateurs = (nombreRadiateursFonte * volumeFonte) +
        (nombreRadiateursAcier * volumeAcier) +
        (nombreRadiateursAluminium * volumeAluminium) +
        (nombreRadiateursPanneau * volumePanneau);

    // Volume de la tuyauterie (15% du volume total)
    final volumeTotalSansTuyauterie = volumeRadiateurs + volumeChaudiere;
    final volumeTuyauterie = volumeTotalSansTuyauterie * 0.15;
    final volumeTotalEau = volumeTotalSansTuyauterie + volumeTuyauterie;

    // Calcul de la capacité du ballon tampon
    final capaciteBallon = (puissanceChaudiere * 3600 * dureeStockage) /
        (4.18 * 1000 * (temperatureDepart - temperatureRetour));

    // Calcul de la puissance du circulateur secondaire
    final volumeTotal = surfaceTotale * hauteurSousPlafond;
    final debitEstime = volumeTotal * 0.5;
    const hauteurManometrique = 2.0;
    final puissanceCirculateur =
        (debitEstime * hauteurManometrique * 9.81) / (3600 * 1000 * 0.7);

    setState(() {
      _capaciteBallon = capaciteBallon;
      _puissanceCirculateur = puissanceCirculateur;
      _debitCirculateur = debitEstime;
      _volumeTotalEau = volumeTotalEau;
      _recommandationsCirculateurs =
          _getRecommandationsCirculateurs(puissanceCirculateur);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Résultat du calcul'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚠️ Version BETA - Ces calculs sont approximatifs',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                  'Volume total d\'eau : ${volumeTotalEau.toStringAsFixed(1)} L'),
              const SizedBox(height: 8),
              Text(
                  'Capacité du ballon tampon : ${capaciteBallon.toStringAsFixed(0)} L'),
              const SizedBox(height: 8),
              Text(
                  'Puissance du circulateur : ${puissanceCirculateur.toStringAsFixed(2)} kW'),
              const SizedBox(height: 8),
              Text('Débit estimé : ${debitEstime.toStringAsFixed(2)} m³/h'),
              const SizedBox(height: 16),
              const Text(
                'Circulateurs recommandés :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._recommandationsCirculateurs!.map((circ) => Text('• $circ')),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Validation professionnelle',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _validateurController,
                decoration: const InputDecoration(
                  labelText: 'Nom du professionnel validant',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _estApprouve,
                    onChanged: (value) {
                      setState(() {
                        _estApprouve = value ?? false;
                        if (!_estApprouve) {
                          _estValide = false;
                        }
                      });
                    },
                  ),
                  const Text('J\'approuve ces calculs'),
                ],
              ),
              if (!_estApprouve) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _commentaireController,
                  decoration: const InputDecoration(
                    labelText: 'Commentaires sur les calculs',
                    border: OutlineInputBorder(),
                    helperText:
                        'Expliquez pourquoi vous n\'approuvez pas ces calculs',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _commentaireController.text.isEmpty
                      ? null
                      : () => _envoyerCommentaire(context),
                  icon: const Icon(Icons.send),
                  label: const Text('Envoyer le commentaire au développeur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _estValide,
                    onChanged: _estApprouve
                        ? (value) {
                            setState(() {
                              _estValide = value ?? false;
                            });
                          }
                        : null,
                  ),
                  const Text('Je valide ces calculs'),
                ],
              ),
              if (_estValide && _validateurController.text.isNotEmpty)
                Text(
                  'Validé par : ${_validateurController.text}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (!_estApprouve && _commentaireController.text.isNotEmpty)
                Text(
                  'Commentaire : ${_commentaireController.text}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'Note : Ces calculs sont approximatifs et doivent être validés par un professionnel qualifié.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Future<void> _envoyerCommentaire(BuildContext context) async {
    try {
      final parametres = {
        'Puissance chaudière': '${_puissanceChaudiereController.text} kW',
        'Surface totale': '${_surfaceTotaleController.text} m²',
        'Nombre de pièces': _nombrePiecesController.text,
        'Hauteur sous plafond': '${_hauteurSousPlafondController.text} m',
        'Température départ': '${_temperatureDepartController.text}°C',
        'Température retour': '${_temperatureRetourController.text}°C',
        'Durée stockage': '${_dureeStockageController.text} h',
        'Type ballon': _typeBallon.toString(),
      };

      final resultats = {
        'Volume total d\'eau': '${_volumeTotalEau?.toStringAsFixed(1)} L',
        'Capacité ballon tampon': '${_capaciteBallon?.toStringAsFixed(0)} L',
        'Puissance circulateur':
            '${_puissanceCirculateur?.toStringAsFixed(2)} kW',
        'Débit estimé': '${_debitCirculateur?.toStringAsFixed(2)} m³/h',
      };

      final logs = [
        'Calcul volume total d\'eau :',
        '  - Volume radiateurs : ${(_nombreRadiateursFonteController.text.isEmpty ? 0 : double.parse(_nombreRadiateursFonteController.text) * 11)} + ${(_nombreRadiateursAcierController.text.isEmpty ? 0 : double.parse(_nombreRadiateursAcierController.text) * 7.5)} + ${(_nombreRadiateursAluminiumController.text.isEmpty ? 0 : double.parse(_nombreRadiateursAluminiumController.text) * 5.5)} + ${(_nombreRadiateursPanneauController.text.isEmpty ? 0 : double.parse(_nombreRadiateursPanneauController.text) * 4.5)} L',
        '  - Volume chaudière : ${_volumeChaudiereController.text} L',
        '  - Volume tuyauterie (15%) : ${(_volumeTotalEau ?? 0) * 0.15} L',
        '  - Total : ${_volumeTotalEau?.toStringAsFixed(1)} L',
        '',
        'Calcul ballon tampon :',
        '  - Formule : V = (P * 3600 * t) / (c * rho * (Td - Tr))',
        '  - P = ${_puissanceChaudiereController.text} kW',
        '  - t = ${_dureeStockageController.text} h',
        '  - Td = ${_temperatureDepartController.text}°C',
        '  - Tr = ${_temperatureRetourController.text}°C',
        '  - Résultat : ${_capaciteBallon?.toStringAsFixed(0)} L',
        '',
        'Calcul circulateur :',
        '  - Volume total = ${_surfaceTotaleController.text} * ${_hauteurSousPlafondController.text} = ${double.parse(_surfaceTotaleController.text) * double.parse(_hauteurSousPlafondController.text)} m³',
        '  - Débit estimé = ${_debitCirculateur?.toStringAsFixed(2)} m³/h',
        '  - Puissance = ${_puissanceCirculateur?.toStringAsFixed(2)} kW',
      ];

      await RapportBug.envoyerRapport(
        context: context,
        titre: 'CALCUL DIMENSIONNEMENT',
        commentaire: _commentaireController.text,
        nomUtilisateur: _validateurController.text,
        parametres: parametres,
        resultats: resultats,
        logs: logs,
        recommandations: _recommandationsCirculateurs ?? [],
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi : ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Ballon Tampon et Circulateurs'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'BETA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: _recupererDonneesPieces,
                icon: const Icon(Icons.room),
                label: const Text('Récupérer les données des pièces'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _recupererDonneesRadiateurs,
                icon: const Icon(Icons.water_drop),
                label: const Text('Récupérer les données des radiateurs'),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Type de ballon tampon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RadioListTile<TypeBallon>(
                        title: const Text('Vertical'),
                        value: TypeBallon.vertical,
                        groupValue: _typeBallon,
                        onChanged: (value) {
                          setState(() {
                            _typeBallon = value!;
                          });
                        },
                      ),
                      RadioListTile<TypeBallon>(
                        title: const Text('Horizontal'),
                        value: TypeBallon.horizontal,
                        groupValue: _typeBallon,
                        onChanged: (value) {
                          setState(() {
                            _typeBallon = value!;
                          });
                        },
                      ),
                      RadioListTile<TypeBallon>(
                        title: const Text('Avec serpentin'),
                        value: TypeBallon.serpentin,
                        groupValue: _typeBallon,
                        onChanged: (value) {
                          setState(() {
                            _typeBallon = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _puissanceChaudiereController,
                decoration: const InputDecoration(
                  labelText: 'Puissance de la chaudière (kW)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la puissance';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombrePiecesController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de pièces',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de pièces';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre entier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _surfaceTotaleController,
                decoration: const InputDecoration(
                  labelText: 'Surface totale (m²)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la surface';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hauteurSousPlafondController,
                decoration: const InputDecoration(
                  labelText: 'Hauteur sous plafond (m)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la hauteur';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureDepartController,
                decoration: const InputDecoration(
                  labelText: 'Température de départ (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la température';
                  }
                  final temp = double.tryParse(value);
                  if (temp == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (temp < 50 || temp > 90) {
                    return 'La température doit être entre 50°C et 90°C';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _temperatureRetourController,
                decoration: const InputDecoration(
                  labelText: 'Température de retour (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la température';
                  }
                  final temp = double.tryParse(value);
                  if (temp == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (temp < 30 || temp > 70) {
                    return 'La température doit être entre 30°C et 70°C';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dureeStockageController,
                decoration: const InputDecoration(
                  labelText: 'Durée de stockage souhaitée (heures)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la durée';
                  }
                  final duree = double.tryParse(value);
                  if (duree == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  if (duree < 1 || duree > 24) {
                    return 'La durée doit être entre 1 et 24 heures';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Nombre de radiateurs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nombreRadiateursFonteController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de radiateurs en fonte',
                  border: OutlineInputBorder(),
                  helperText: 'Volume unitaire : 11 L',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreRadiateursAcierController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de radiateurs en acier',
                  border: OutlineInputBorder(),
                  helperText: 'Volume unitaire : 7.5 L',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreRadiateursAluminiumController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de radiateurs en aluminium',
                  border: OutlineInputBorder(),
                  helperText: 'Volume unitaire : 5.5 L',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreRadiateursPanneauController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de radiateurs panneau',
                  border: OutlineInputBorder(),
                  helperText: 'Volume unitaire : 4.5 L',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _volumeChaudiereController,
                decoration: const InputDecoration(
                  labelText: 'Volume d\'eau de la chaudière (L)',
                  border: OutlineInputBorder(),
                  helperText: 'Volume d\'eau contenu dans la chaudière',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _calculerDimensionnement,
                child: const Text('Calculer le dimensionnement'),
              ),
              if (_capaciteBallon != null) ...[
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Caractéristiques recommandées',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Volume total d\'eau : ${_volumeTotalEau!.toStringAsFixed(1)} L',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Capacité du ballon tampon : ${_capaciteBallon!.toStringAsFixed(0)} L',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Puissance du circulateur : ${_puissanceCirculateur!.toStringAsFixed(2)} kW',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Débit estimé : ${_debitCirculateur!.toStringAsFixed(2)} m³/h',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Circulateurs recommandés :',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ..._recommandationsCirculateurs!
                            .map((circ) => Text('• $circ')),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
