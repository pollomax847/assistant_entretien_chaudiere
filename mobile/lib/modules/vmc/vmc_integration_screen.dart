import 'package:flutter/material.dart';
import 'vmc_calculator.dart';
import 'vmc_pdf_generator.dart';
import 'vmc_documentation_screen.dart';

/// Modèle pour une mesure VMC par pièce (cuisine, salle-de-bain, wc, autre-sdb)
class MesurePiece {
  String typePiece; // cuisine, salle-de-bain, wc, autre-sdb
  double debitMesure; // en m³/h
  MesurePiece({required this.typePiece, this.debitMesure = 0.0});
}

class VMCIntegrationScreen extends StatefulWidget {
  const VMCIntegrationScreen({super.key});

  @override
  State<VMCIntegrationScreen> createState() => _VMCIntegrationScreenState();
}

class _VMCIntegrationScreenState extends State<VMCIntegrationScreen> {
  // Sélections principales (reflètent le site)
  String _typeLogement = 'T3';
  String _typeVMC = 'simple-flux';

  // Mesures VMC par pièce
  List<MesurePiece> _mesuresPiece = [];
  
  // Controllers pour les champs de texte
  final Map<String, TextEditingController> _controllers = {};

  // Résultats diagnostic
  String? _statut; // success, warning, error
  String? _message;
  String? _recommandation;
  int _pourcentageConformite = 0;
  List<Map<String, dynamic>> _resultatsParPiece = [];

  // Textes affichage des pièces
  static const Map<String, String> kNomsPiece = {
    'cuisine': 'Cuisine',
    'salle-de-bain': 'Salle de bain principale',
    'wc': 'WC',
    'autre-sdb': 'Autre salle d\'eau',
  };

  @override
  void initState() {
    super.initState();
    _initializeMesures();
    _verifierConformite();
  }
  
  @override
  void dispose() {
    // Nettoyer les controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _initializeMesures() {
    // Déterminer les pièces selon le type de logement
    List<String> pieces;
    switch (_typeLogement) {
      case 'T1':
      case 'T2':
        pieces = ['cuisine', 'salle-de-bain', 'wc'];
        break;
      case 'T3':
      case 'T4':
      case 'T5+':
      default:
        pieces = ['cuisine', 'salle-de-bain', 'wc', 'autre-sdb'];
        break;
    }
    
    // Sauvegarder les valeurs existantes
    final Map<String, double> savedValues = {};
    for (var mesure in _mesuresPiece) {
      savedValues[mesure.typePiece] = mesure.debitMesure;
    }
    
    // Créer les nouvelles mesures
    _mesuresPiece = pieces.map((piece) {
      final savedValue = savedValues[piece] ?? 0.0;
      
      // Créer ou mettre à jour le controller
      if (!_controllers.containsKey(piece)) {
        _controllers[piece] = TextEditingController();
      }
      _controllers[piece]!.text = savedValue > 0 ? savedValue.toString() : '';
      
      return MesurePiece(typePiece: piece, debitMesure: savedValue);
    }).toList();
    
    // Supprimer les controllers non utilisés
    _controllers.removeWhere((key, value) {
      if (!pieces.contains(key)) {
        value.dispose();
        return true;
      }
      return false;
    });
  }

  void _verifierConformite() {
    // Récupérer la référence pour le type de logement et VMC sélectionnés
    final reference = VMCCalculator.getReference(_typeVMC, _typeLogement);
    if (reference == null) {
      setState(() {
        _statut = 'error';
        _message = 'Type VMC ou logement invalide';
        _recommandation = '';
      });
      return;
    }

    // Analyser chaque mesure par rapport à sa référence
    _resultatsParPiece = [];
    int conformesCount = 0;
    int tropFaibleCount = 0;
    int tropEleveCount = 0;

    for (final mesure in _mesuresPiece) {
      if (mesure.debitMesure == 0 || mesure.debitMesure.isNaN) {
        // Pas de mesure, on l'ignore
        continue;
      }

      final ref = reference[mesure.typePiece] as Map<String, dynamic>?;
      if (ref == null) {
        continue;
      }

      final min = (ref['min'] as num).toDouble();
      final max = (ref['max'] as num).toDouble();

      String etat = 'error';
      if (mesure.debitMesure >= min && mesure.debitMesure <= max) {
        etat = 'success';
        conformesCount++;
      } else if (mesure.debitMesure < min) {
        tropFaibleCount++;
      } else {
        tropEleveCount++;
      }

      final message = VMCCalculator.getEtatMessage(etat, mesure.debitMesure, min, max);
      _resultatsParPiece.add({
        'piece': mesure.typePiece,
        'nomPiece': kNomsPiece[mesure.typePiece],
        'debit': mesure.debitMesure,
        'min': min,
        'max': max,
        'etat': etat,
        'message': message,
      });
    }

    // Calculer le pourcentage de conformité
    if (_resultatsParPiece.isEmpty) {
      _statut = 'error';
      _message = 'Aucune mesure VMC saisie';
      _recommandation = 'Veuillez entrer au moins une mesure de débit.';
      _pourcentageConformite = 0;
    } else {
      _pourcentageConformite = ((conformesCount / _resultatsParPiece.length) * 100).round();

      if (_pourcentageConformite == 100) {
        _statut = 'success';
        _message = 'Installation conforme';
        _recommandation = 'Aucune action nécessaire.';
      } else if (_pourcentageConformite >= 80) {
        _statut = 'warning';
        _message = 'Installation globalement conforme avec quelques ajustements nécessaires';
        _recommandation = 'Vérifiez et ajustez les débits si nécessaire.';
      } else if (_pourcentageConformite >= 50) {
        _statut = 'warning';
        final diagnostic = VMCCalculator.getDiagnosticMessage(_pourcentageConformite, tropFaibleCount, tropEleveCount);
        _message = diagnostic;
        _recommandation = 'Réglage des bouches ou vérification du caisson VMC recommandé.';
      } else {
        _statut = 'error';
        final diagnostic = VMCCalculator.getDiagnosticMessage(_pourcentageConformite, tropFaibleCount, tropEleveCount);
        _message = diagnostic;
        _recommandation = 'Installation non conforme. Révision complète nécessaire.';
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification des Débits VMC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Documentation VMC',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VMCDocumentationScreen(typeVMC: _typeVMC),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type de logement
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type de logement', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _typeLogement,
                      items: ['T1', 'T2', 'T3', 'T4', 'T5+'].map((t) {
                        String label = t;
                        if (t == 'T1') {
                          label = 'T1 (1 pièce principale)';
                        } else if (t == 'T2') {
                          label = 'T2 (2 pièces principales)';
                        } else if (t == 'T3') {
                          label = 'T3 (3 pièces principales)';
                        } else if (t == 'T4') {
                          label = 'T4 (4 pièces principales)';
                        } else if (t == 'T5+') {
                          label = 'T5 et plus (5 pièces principales et plus)';
                        }
                        return DropdownMenuItem(value: t, child: Text(label));
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            _typeLogement = v;
                            _initializeMesures(); // Ajuster les mesures selon le nouveau type
                          });
                          _verifierConformite();
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Type de logement'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Type de VMC
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type de VMC', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _typeVMC,
                      items: VMCCalculator.getTypesVMC().map((t) {
                        return DropdownMenuItem(
                          value: t['value']!,
                          child: Text(t['label']!),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            _typeVMC = v;
                          });
                          _verifierConformite();
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Type de VMC'),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getVMCDescription(_typeVMC),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tableau de référence
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tableau de référence des débits réglementaires',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _buildReferenceTable(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Mesures VMC
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mesures des débits', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ..._mesuresPiece.map((mesure) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(kNomsPiece[mesure.typePiece] ?? mesure.typePiece),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: _controllers[mesure.typePiece],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'm³/h',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                onChanged: (v) {
                                  final val = double.tryParse(v) ?? 0.0;
                                  setState(() => mesure.debitMesure = val);
                                  _verifierConformite();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Résultats
            Card(
              color: _statut == 'success'
                  ? Colors.green.withAlpha(25)
                  : _statut == 'warning'
                      ? Colors.orange.withAlpha(25)
                      : Colors.red.withAlpha(25),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Résultats', style: Theme.of(context).textTheme.titleMedium),
                        if (_resultatsParPiece.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: () async {
                              await VMCPdfGenerator.instance.generateDiagnosticReport(
                                context: context,
                                typeLogement: _typeLogement,
                                typeVMC: _typeVMC,
                                resultatsParPiece: _resultatsParPiece,
                                pourcentageConformite: _pourcentageConformite,
                                message: _message ?? '',
                                recommandation: _recommandation ?? '',
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf, size: 18),
                            label: const Text('Export PDF'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_resultatsParPiece.isNotEmpty) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Pièce')),
                            DataColumn(label: Text('Débit (m³/h)')),
                            DataColumn(label: Text('Min (m³/h)')),
                            DataColumn(label: Text('Max (m³/h)')),
                            DataColumn(label: Text('État')),
                          ],
                          rows: _resultatsParPiece.map((r) {
                            final etatWidget = r['etat'] == 'success'
                                ? Chip(
                                    label: Text(r['message']),
                                    backgroundColor: Colors.green,
                                    labelStyle: const TextStyle(color: Colors.white),
                                  )
                                : Chip(
                                    label: Text(r['message']),
                                    backgroundColor: Colors.red,
                                    labelStyle: const TextStyle(color: Colors.white),
                                  );
                            return DataRow(cells: [
                              DataCell(Text(r['nomPiece'])),
                              DataCell(Text('${r['debit'].toStringAsFixed(1)}')),
                              DataCell(Text('${r['min'].toInt()}')),
                              DataCell(Text('${r['max'].toInt()}')),
                              DataCell(etatWidget),
                            ]);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _statut == 'success' ? Colors.green : _statut == 'warning' ? Colors.orange : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Conformité globale: $_pourcentageConformite%',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Diagnostic: $_message',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Recommandation: $_recommandation',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ] else
                      Text(
                        _message ?? 'Entrez des mesures pour voir les résultats',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceTable() {
    final reference = VMCCalculator.getReference(_typeVMC, _typeLogement);
    if (reference == null) {
      return const Text('Référence non disponible');
    }

    final rows = reference.entries.map((entry) {
      final piece = entry.key;
      final debits = entry.value;
      final min = (debits['min'] as num).toInt();
      final max = (debits['max'] as num).toInt();
      return DataRow(cells: [
        DataCell(Text(kNomsPiece[piece] ?? piece)),
        DataCell(Text('$min')),
        DataCell(Text('$max')),
      ]);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Pièce')),
          DataColumn(label: Text('Min (m³/h)')),
          DataColumn(label: Text('Max (m³/h)')),
        ],
        rows: rows,
      ),
    );
  }

  String _getVMCDescription(String typeVMC) {
    switch (typeVMC) {
      case 'simple-flux':
        return 'Extraction mécanique avec débit constant. Système de base fiable et économique.';
      case 'hygro-a':
        return 'Bouches d\'extraction hygroréglables. Économie d\'énergie de 15-20%.';
      case 'hygro-b':
        return 'Entrées et extractions hygroréglables. Économie maximale de 25-30%.';
      case 'double-flux':
        return 'Récupération de chaleur jusqu\'à 90%. Filtration complète de l\'air.';
      case 'vmc-gaz':
        return 'Ventilation + évacuation des fumées. Contrôle annuel obligatoire.';
      default:
        return '';
    }
  }
}
