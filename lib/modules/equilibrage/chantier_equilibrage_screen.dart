import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../providers/chantiers_provider.dart';
import '../../models/chantier.dart';
import '../../models/radiateur.dart';

class ChantierEquilibrageScreen extends ConsumerStatefulWidget {
  final Chantier chantier;

  const ChantierEquilibrageScreen({super.key, required this.chantier});

  @override
  ConsumerState<ChantierEquilibrageScreen> createState() => _ChantierEquilibrageScreenState();
}

class _ChantierEquilibrageScreenState extends ConsumerState<ChantierEquilibrageScreen> {
  late Chantier _chantierCourant;
  List<Map<String, dynamic>> _qualigazCodes = [];
  bool _codesLoaded = false;

  @override
  void initState() {
    super.initState();
    _chantierCourant = widget.chantier;
    _loadQualigazCodes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadQualigazCodes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/qualigaz_codes.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _qualigazCodes = List<Map<String, dynamic>>.from(jsonData['codes']);
        _codesLoaded = true;
      });
    } catch (e) {
      print('Erreur lors du chargement des codes Qualigaz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Équilibrage - ${_chantierCourant.nom}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _ajouterRadiateur,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _trierRadiateurs,
            tooltip: 'Trier par ordre',
          ),
          if (_codesLoaded)
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: _analyserReseau,
              tooltip: 'Analyser le réseau',
            ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec infos chantier
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _chantierCourant.nom,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_chantierCourant.adresse != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _chantierCourant.adresse!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (_chantierCourant.descriptionChaudiere != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _chantierCourant.descriptionChaudiere!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.device_thermostat, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      '${_chantierCourant.radiateurs.length} radiateur(s)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${_chantierCourant.dateCreation.day}/${_chantierCourant.dateCreation.month}/${_chantierCourant.dateCreation.year}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Liste des radiateurs
          Expanded(
            child: _chantierCourant.radiateurs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.thermostat, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucun radiateur dans ce chantier',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ajoutez votre premier radiateur',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _ajouterRadiateur,
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter un radiateur'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _chantierCourant.radiateurs.length,
                    itemBuilder: (context, index) {
                      final radiateur = _chantierCourant.radiateurs[index];
                      return _buildRadiateurCard(radiateur, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _chantierCourant.radiateurs.isNotEmpty
          ? FloatingActionButton(
              onPressed: _sauvegarderChantier,
              child: const Icon(Icons.save),
              tooltip: 'Sauvegarder les modifications',
            )
          : null,
    );
  }

  Widget _buildRadiateurCard(Radiateur radiateur, int index) {
    final statutColor = _getStatutColor(radiateur.statut);
    final statutIcon = _getStatutIcon(radiateur.statut);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statutColor.withOpacity(0.2),
          child: Icon(statutIcon, color: statutColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                radiateur.nom,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statutColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statutColor.withOpacity(0.3)),
              ),
              child: Text(
                radiateur.statut.displayName,
                style: TextStyle(
                  color: statutColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ordre: ${radiateur.ordre + 1}'),
            if (radiateur.tempAller != null && radiateur.tempRetour != null) ...[
              Text(
                'ΔT: ${radiateur.deltaT?.toStringAsFixed(1) ?? 'N/A'}°C',
                style: TextStyle(
                  color: (radiateur.deltaT ?? 0) > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Mesures de température
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: radiateur.tempAller?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Température Aller (°C)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _updateTempAller(radiateur, value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: radiateur.tempRetour?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Température Retour (°C)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _updateTempRetour(radiateur, value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tours de vanne
                TextFormField(
                  initialValue: radiateur.toursVanne.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Tours de vanne',
                    border: OutlineInputBorder(),
                    suffixText: 'tours',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _updateToursVanne(radiateur, value),
                ),
                const SizedBox(height: 12),

                // Notes
                TextFormField(
                  initialValue: radiateur.notes,
                  decoration: const InputDecoration(
                    labelText: 'Notes/Observations',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) => _updateNotes(radiateur, value),
                ),
                const SizedBox(height: 12),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _modifierRadiateur(radiateur),
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _supprimerRadiateur(radiateur),
                        icon: const Icon(Icons.delete),
                        label: const Text('Supprimer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatutColor(StatutRadiateur statut) {
    switch (statut) {
      case StatutRadiateur.ok:
        return Colors.green;
      case StatutRadiateur.tropChaud:
        return Colors.red;
      case StatutRadiateur.tropFroid:
        return Colors.blue;
      case StatutRadiateur.aPurger:
        return Colors.orange;
      case StatutRadiateur.aAjuster:
        return Colors.yellow;
      case StatutRadiateur.autre:
        return Colors.grey;
    }
  }

  IconData _getStatutIcon(StatutRadiateur statut) {
    switch (statut) {
      case StatutRadiateur.ok:
        return Icons.check_circle;
      case StatutRadiateur.tropChaud:
        return Icons.thermostat;
      case StatutRadiateur.tropFroid:
        return Icons.ac_unit;
      case StatutRadiateur.aPurger:
        return Icons.cleaning_services;
      case StatutRadiateur.aAjuster:
        return Icons.build;
      case StatutRadiateur.autre:
        return Icons.help;
    }
  }

  void _ajouterRadiateur() {
    final nomController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un radiateur'),
        content: TextField(
          controller: nomController,
          decoration: const InputDecoration(
            labelText: 'Nom du radiateur',
            hintText: 'Ex: Salon, Chambre 1, Cuisine...',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomController.text.trim().isNotEmpty) {
                final nouveauRadiateur = Radiateur(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nom: nomController.text.trim(),
                  ordre: _chantierCourant.radiateurs.length,
                );

                setState(() {
                  _chantierCourant.radiateurs.add(nouveauRadiateur);
                  _chantierCourant.trierRadiateurs();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Radiateur "${nouveauRadiateur.nom}" ajouté')),
                );
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _modifierRadiateur(Radiateur radiateur) {
    final nomController = TextEditingController(text: radiateur.nom);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le radiateur'),
        content: TextField(
          controller: nomController,
          decoration: const InputDecoration(labelText: 'Nom du radiateur'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomController.text.trim().isNotEmpty) {
                setState(() {
                  radiateur.nom = nomController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _supprimerRadiateur(Radiateur radiateur) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le radiateur ?'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${radiateur.nom}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _chantierCourant.radiateurs.remove(radiateur);
                // Réorganiser les ordres
                for (int i = 0; i < _chantierCourant.radiateurs.length; i++) {
                  _chantierCourant.radiateurs[i].ordre = i;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Radiateur "${radiateur.nom}" supprimé')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _trierRadiateurs() {
    setState(() {
      _chantierCourant.trierRadiateurs();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Radiateurs triés par ordre')),
    );
  }

  void _updateTempAller(Radiateur radiateur, String value) {
    final temp = double.tryParse(value);
    setState(() {
      radiateur.tempAller = temp;
      _updateStatutRadiateur(radiateur);
    });
  }

  void _updateTempRetour(Radiateur radiateur, String value) {
    final temp = double.tryParse(value);
    setState(() {
      radiateur.tempRetour = temp;
      _updateStatutRadiateur(radiateur);
    });
  }

  void _updateToursVanne(Radiateur radiateur, String value) {
    final tours = double.tryParse(value) ?? 0.0;
    setState(() {
      radiateur.toursVanne = tours;
    });
  }

  void _updateNotes(Radiateur radiateur, String value) {
    setState(() {
      radiateur.notes = value;
    });
  }

  void _updateStatutRadiateur(Radiateur radiateur) {
    if (radiateur.tempAller != null && radiateur.tempRetour != null) {
      final deltaT = radiateur.deltaT ?? 0;
      if (deltaT < 5.0) {
        radiateur.statut = StatutRadiateur.tropFroid;
      } else if (deltaT > 15.0) {
        radiateur.statut = StatutRadiateur.tropChaud;
      } else {
        radiateur.statut = StatutRadiateur.ok;
      }
    } else {
      radiateur.statut = StatutRadiateur.aAjuster;
    }
  }

  void _analyserReseau() {
    final issues = _analyzeNetwork();
    if (issues.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Analyse du Réseau'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];
                return Card(
                  color: _getSeverityColor(issue['severity'] ?? 'low'),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${issue['code']}: ${issue['description']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (issue['actions'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Actions: ${(issue['actions'] as List).join(', ')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune anomalie détectée dans le réseau')),
      );
    }
  }

  List<Map<String, dynamic>> _analyzeNetwork() {
    final issues = <Map<String, dynamic>>[];
    final radiateurs = _chantierCourant.radiateurs;

    // Calculer les deltaT moyens
    final validDeltaTs = radiateurs
        .where((r) => r.deltaT != null)
        .map((r) => r.deltaT!)
        .toList();

    if (validDeltaTs.isEmpty) return issues;

    final avgDeltaT = validDeltaTs.reduce((a, b) => a + b) / validDeltaTs.length;
    final maxDeltaT = validDeltaTs.reduce((a, b) => a > b ? a : b);
    final minDeltaT = validDeltaTs.reduce((a, b) => a < b ? a : b);

    // Analyser les écarts
    if ((maxDeltaT - minDeltaT) > 10.0) {
      // Déséquilibre important
      final code = _qualigazCodes.firstWhere(
        (c) => c['code'] == 'A1',
        orElse: () => {'code': 'A1', 'description': 'Anomalie importante - Déséquilibre du réseau de chauffage', 'severity': 'medium'},
      );
      issues.add(code);
    }

    // Radiateurs trop chauds ou trop froids
    final tropChauds = radiateurs.where((r) => r.statut == StatutRadiateur.tropChaud).length;
    final tropFroids = radiateurs.where((r) => r.statut == StatutRadiateur.tropFroid).length;

    if (tropChauds > radiateurs.length * 0.3) {
      final code = _qualigazCodes.firstWhere(
        (c) => c['code'] == 'A1',
        orElse: () => {'code': 'A1', 'description': 'Anomalie importante - Plusieurs radiateurs trop chauds', 'severity': 'medium'},
      );
      issues.add(code);
    }

    if (tropFroids > radiateurs.length * 0.3) {
      final code = _qualigazCodes.firstWhere(
        (c) => c['code'] == 'A1',
        orElse: () => {'code': 'A1', 'description': 'Anomalie importante - Plusieurs radiateurs trop froids', 'severity': 'medium'},
      );
      issues.add(code);
    }

    // Radiateurs à purger
    final aPurger = radiateurs.where((r) => r.statut == StatutRadiateur.aPurger).length;
    if (aPurger > 0) {
      final code = _qualigazCodes.firstWhere(
        (c) => c['code'] == 'A1',
        orElse: () => {'code': 'A1', 'description': 'Anomalie importante - Radiateurs nécessitant un purge', 'severity': 'medium'},
      );
      issues.add(code);
    }

    return issues;
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red.shade100;
      case 'high':
        return Colors.orange.shade100;
      case 'medium':
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _sauvegarderChantier() {
    ref.read(chantiersProvider.notifier).updateChantier(_chantierCourant);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chantier sauvegardé')),
    );
  }
}