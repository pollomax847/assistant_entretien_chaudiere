import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'rt_chaudiere_form.dart';
import 'rt_pac_form.dart';
import 'rt_clim_form.dart';

enum TypeReleve {
  chaudiere,
  pac,
  clim,
}

class ReleveTechnique {
  String nomEntreprise;
  String nomTechnicien;
  DateTime dateReleve;
  TypeReleve type;
  Map<String, dynamic> donnees;

  ReleveTechnique({
    required this.nomEntreprise,
    required this.nomTechnicien,
    required this.dateReleve,
    required this.type,
    required this.donnees,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomEntreprise': nomEntreprise,
      'nomTechnicien': nomTechnicien,
      'dateReleve': dateReleve.toIso8601String(),
      'type': type.toString(),
      'donnees': donnees,
    };
  }

  factory ReleveTechnique.fromJson(Map<String, dynamic> json) {
    return ReleveTechnique(
      nomEntreprise: json['nomEntreprise'] ?? '',
      nomTechnicien: json['nomTechnicien'] ?? '',
      dateReleve: DateTime.parse(json['dateReleve']),
      type: TypeReleve.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TypeReleve.chaudiere,
      ),
      donnees: json['donnees'] ?? {},
    );
  }
}

class ReleveTechniqueScreenComplet extends StatefulWidget {
  final TypeReleve type;

  const ReleveTechniqueScreenComplet({
    super.key,
    required this.type,
  });

  @override
  State<ReleveTechniqueScreenComplet> createState() =>
      _ReleveTechniqueScreenCompletState();
}

class _ReleveTechniqueScreenCompletState
    extends State<ReleveTechniqueScreenComplet> {
  final _formKey = GlobalKey<FormState>();
  final _nomEntrepriseController = TextEditingController();
  final _nomTechnicienController = TextEditingController();
  late DateTime _dateReleve;
  int _nombreReleves = 1;
  final List<Map<String, dynamic>> _releves = [];

  @override
  void initState() {
    super.initState();
    _dateReleve = DateTime.now();
  }

  @override
  void dispose() {
    _nomEntrepriseController.dispose();
    _nomTechnicienController.dispose();
    super.dispose();
  }

  void _ajouterReleve() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _releves.add({
          'nomEntreprise': _nomEntrepriseController.text,
          'nomTechnicien': _nomTechnicienController.text,
          'dateReleve': _dateReleve,
          'type': widget.type,
          'donnees': {}, // Sera rempli par le formulaire spécifique
        });
        _nombreReleves++;
      });
    }
  }

  void _sauvegarderReleve() {
    if (_releves.isNotEmpty) {
      // Logique de sauvegarde
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relevé sauvegardé avec succès')),
      );
    }
  }

  Widget _buildForm() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return RTChaudiereForm(
          onDataChanged: (data) {
            if (_releves.isNotEmpty) {
              _releves.last['donnees'] = data;
            }
          },
        );
      case TypeReleve.pac:
        return RTPACForm(
          onDataChanged: (data) {
            if (_releves.isNotEmpty) {
              _releves.last['donnees'] = data;
            }
          },
        );
      case TypeReleve.clim:
        return RTClimForm(
          onDataChanged: (data) {
            if (_releves.isNotEmpty) {
              _releves.last['donnees'] = data;
            }
          },
        );
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
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exporterTXT(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informations générales
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations générales',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomEntrepriseController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de l\'entreprise',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomTechnicienController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du technicien',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Date du relevé: ${DateFormat('dd/MM/yyyy').format(_dateReleve)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _dateReleve,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  _dateReleve = date;
                                });
                              }
                            },
                            child: const Text('Changer'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nombre de relevés: $_nombreReleves',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Formulaire spécifique
              _buildForm(),

              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _ajouterReleve,
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un relevé'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _sauvegarderReleve,
                      icon: const Icon(Icons.save),
                      label: const Text('Sauvegarder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitre() {
    switch (widget.type) {
      case TypeReleve.chaudiere:
        return 'Relevé Technique Chaudière Complet';
      case TypeReleve.pac:
        return 'Relevé Technique PAC Complet';
      case TypeReleve.clim:
        return 'Relevé Technique Climatisation Complet';
    }
  }

  Future<void> _exporterTXT(BuildContext context) async {
    if (_releves.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun relevé à exporter')),
      );
      return;
    }

    // Logique d'export TXT simplifiée
    String contenu = 'RELEVÉS TECHNIQUES\n\n';
    contenu += 'Entreprise: ${_nomEntrepriseController.text}\n';
    contenu += 'Technicien: ${_nomTechnicienController.text}\n';
    contenu += 'Date: ${DateFormat('dd/MM/yyyy').format(_dateReleve)}\n\n';

    for (int i = 0; i < _releves.length; i++) {
      contenu += 'Relevé ${i + 1}:\n';
      contenu += jsonEncode(_releves[i]);
      contenu += '\n\n';
    }

    // Ici on pourrait utiliser share_plus pour partager le fichier
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export simulé: ${contenu.length} caractères')),
    );
  }
}
