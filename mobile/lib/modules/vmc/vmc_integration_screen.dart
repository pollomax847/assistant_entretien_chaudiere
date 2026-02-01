import 'package:flutter/material.dart';
import 'dart:math';
import 'vmc_calculator.dart';

// Localized labels and defaults
const Map<String, String> kStateLabels = {
  'neuf': 'Neuf',
  'bon': 'Bon',
  'moyen': 'Moyen',
  'mauvais': 'Mauvais',
};

const Map<String, String> kRoomLabels = {
  'salon': 'Salon',
  'sejour': 'Séjour',
  'chambre': 'Chambre',
  'autre-piece': 'Autre pièce',
};

const Map<String, String> kDefaultHygroModuleByRoom = {
  'salon': '6-45',
  'sejour': '6-45',
  'chambre': '6-22',
  'autre-piece': '6-22',
};

class Piece {
  String type;
  String nom;
  Piece({required this.type, required this.nom});
}

class Fenetre {
  String taille; // petite, moyenne, grande, baie
  bool ouverte;
  Fenetre({required this.taille, this.ouverte = false});
}

class AirInlet {
  String room; // salon, chambre, sejour, autre-piece
  String inletType; // standard, hygro
  String module; // '15','22','30','45' or range '6-45'
  String state; // neuf, bon, moyen, mauvais
  AirInlet({required this.room, this.inletType = 'standard', this.module = '30', this.state = 'bon'});
}

class MesureVMC {
  String piece;
  double debit;
  MesureVMC({required this.piece, required this.debit});
}

class VMCIntegrationScreen extends StatefulWidget {
  const VMCIntegrationScreen({super.key});

  @override
  State<VMCIntegrationScreen> createState() => _VMCIntegrationScreenState();
}

class _VMCIntegrationScreenState extends State<VMCIntegrationScreen> {
  // Pièces et fenêtres
  List<Piece> _pieces = [Piece(type: 'chambre', nom: 'Chambre 1')];
  List<Fenetre> _fenetres = [Fenetre(taille: 'moyenne')];
  List<MesureVMC> _mesuresVMC = [MesureVMC(piece: 'Chambre 1', debit: 15)];

  // Types de pièces et tailles de fenêtres
  final List<String> _typesPiece = ['chambre', 'cuisine', 'salleDeBain', 'wc', 'salon'];
  final List<String> _taillesFenetre = ['petite', 'moyenne', 'grande', 'baie'];
  final Map<String, double> _debitsFenetre = {
    'petite': 10,
    'moyenne': 20,
    'grande': 30,
    'baie': 45,
  };
  final Map<String, double> _debitsPiece = {
    'cuisine': 45,
    'salleDeBain': 30,
    'wc': 15,
    'chambre': 15,
    'salon': 30,
  };

  // Diagnostic
  String? _typeLogement;
  double? _debitTotalFenetres;
  double? _debitTotalVMC;
  double? _diff;
  double? _diffPct;
  String? _statut;
  String? _message;
  String? _recommandation;

  // Entrées d'air détaillées (UI)
  List<AirInlet> _airInlets = [];

  @override
  void initState() {
    super.initState();
    _diagnostiquer();
  }

  void _ajouterPiece() {
    setState(() {
      _pieces.add(Piece(type: 'chambre', nom: 'Chambre ${_pieces.length + 1}'));
    });
    _diagnostiquer();
  }

  void _ajouterFenetre() {
    setState(() {
      _fenetres.add(Fenetre(taille: 'moyenne'));
    });
    _diagnostiquer();
  }

  void _ajouterAirInlet() {
    setState(() {
      _airInlets.add(AirInlet(room: 'salon', inletType: 'standard', module: '30'));
    });
    _diagnostiquer();
  }

  void _ajouterMesureVMC() {
    setState(() {
      _mesuresVMC.add(MesureVMC(piece: 'Chambre ${_mesuresVMC.length + 1}', debit: 15));
    });
    _diagnostiquer();
  }

  void _diagnostiquer() {
    // Détection type logement
    int nbChambres = _pieces.where((p) => p.type == 'chambre').length;
    if (nbChambres == 0) {
      _typeLogement = 'T1';
    } else if (nbChambres == 1) {
      _typeLogement = 'T2';
    } else if (nbChambres == 2) {
      _typeLogement = 'T3';
    } else if (nbChambres == 3) {
      _typeLogement = 'T4';
    } else {
      _typeLogement = 'T5+';
    }
    // Débit total fenêtres (si entrées d'air détaillées présentes, on les utilise)
    double debitTotalFenetres = 0.0;
    if (_airInlets.isNotEmpty) {
      double totalStandard = 0.0;
      double totalHygroMin = 0.0;
      double totalHygroMax = 0.0;
      for (final ai in _airInlets) {
        // efficiency factor
        double eff = 1.0;
        switch (ai.state) {
          case 'neuf': eff = 1.0; break;
          case 'bon': eff = 0.9; break;
          case 'moyen': eff = 0.7; break;
          case 'mauvais': eff = 0.5; break;
        }
        if (ai.inletType == 'hygro' && ai.module.contains('-')) {
          final parts = ai.module.split('-').map((s) => double.tryParse(s) ?? 0).toList();
          if (parts.length == 2) {
            totalHygroMin += parts[0] * eff;
            totalHygroMax += parts[1] * eff;
          }
        } else {
          totalStandard += (double.tryParse(ai.module) ?? 0) * eff;
        }
      }
      if (totalHygroMax > 0) {
        // use min as conservative effective flow in summary (mirrors site behavior)
        debitTotalFenetres = totalStandard + totalHygroMin;
      } else {
        debitTotalFenetres = totalStandard;
      }
    } else {
      debitTotalFenetres = _fenetres.where((f) => f.ouverte).fold(0.0, (sum, f) => sum + _debitsFenetre[f.taille]!);
    }
    // Débit total VMC
    final debitTotalVMC = _mesuresVMC.fold(0.0, (sum, m) => sum + m.debit);

    _debitTotalFenetres = debitTotalFenetres;
    _debitTotalVMC = debitTotalVMC;

    // Comparaison et compatibilité (utilise VMCCalculator pour messages identiques au site)
    _diff = debitTotalFenetres - debitTotalVMC;
    _diffPct = debitTotalVMC > 0 ? ((_debitTotalFenetres! - _debitTotalVMC!) / debitTotalVMC) * 100 : 0;

    // Si aucune fenêtre ouverte
    if (_debitTotalFenetres == 0) {
      _statut = 'erreur';
      _message = 'Aucune fenêtre ouverte';
      _recommandation = 'Ouvrez au moins une fenêtre.';
      setState(() {});
      return;
    }

    // Si aucune mesure VMC, utiliser valeurs standards selon type de logement
    double extractionTotal = debitTotalVMC;
    if (extractionTotal == 0) {
      switch (_typeLogement) {
        case 'T1': extractionTotal = 75; break;
        case 'T2': extractionTotal = 90; break;
        case 'T3': extractionTotal = 105; break;
        case 'T4': extractionTotal = 120; break;
        case 'T5+': extractionTotal = 135; break;
        default: extractionTotal = 105;
      }
    }

    final compat = VMCCalculator.checkCompatibilityWithVMC(debitTotalFenetres, extractionTotal);

    final status = compat['status'] as String? ?? 'bad';
    final msg = compat['message'] as String? ?? '';
    final diffVal = compat['difference'] as double? ?? (debitTotalFenetres - extractionTotal);

    if (status == 'good') {
      _statut = 'succès';
      _message = msg;
      _recommandation = 'Aucune action nécessaire.';
    } else if (status == 'warning') {
      _statut = 'alerte';
      _message = msg;
      _recommandation = 'Vérifiez et ajustez si nécessaire (fermer/ouvrir fenêtres ou régler la VMC).';
    } else {
      _statut = 'alerte';
      _message = msg;
      if (diffVal > 0) {
        _recommandation = 'Fermez des fenêtres ou augmentez le débit VMC.';
      } else {
        _recommandation = 'Ouvrez plus de fenêtres ou réduisez le débit VMC.';
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostic VMC & Fenêtres')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gestion des pièces
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pièces', style: Theme.of(context).textTheme.titleMedium),
                    ..._pieces.asMap().entries.map((entry) => ListTile(
                          title: Text('${entry.value.nom} (${entry.value.type})'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() => _pieces.removeAt(entry.key));
                              _diagnostiquer();
                            },
                          ),
                          onTap: () async {
                            final type = await showDialog<String>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text('Type de pièce'),
                                children: _typesPiece.map((t) => SimpleDialogOption(
                                  child: Text(t),
                                  onPressed: () => Navigator.pop(ctx, t),
                                )).toList(),
                              ),
                            );
                            if (type != null) {
                              setState(() => entry.value.type = type);
                              _diagnostiquer();
                            }
                          },
                        )),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter une pièce'),
                      onPressed: _ajouterPiece,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Gestion des fenêtres + entrées d'air détaillées
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fenêtres', style: Theme.of(context).textTheme.titleMedium),
                    // Simple list (legacy)
                    ..._fenetres.asMap().entries.map((entry) => ListTile(
                          title: Text('Fenêtre ${entry.key + 1} (${entry.value.taille})'),
                          leading: Checkbox(
                            value: entry.value.ouverte,
                            onChanged: (v) {
                              setState(() => entry.value.ouverte = v ?? false);
                              _diagnostiquer();
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() => _fenetres.removeAt(entry.key));
                              _diagnostiquer();
                            },
                          ),
                          onTap: () async {
                            final taille = await showDialog<String>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text('Taille de fenêtre'),
                                children: _taillesFenetre.map((t) => SimpleDialogOption(
                                  child: Text(t),
                                  onPressed: () => Navigator.pop(ctx, t),
                                )).toList(),
                              ),
                            );
                            if (taille != null) {
                              setState(() => entry.value.taille = taille);
                              _diagnostiquer();
                            }
                          },
                        )),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter une fenêtre'),
                          onPressed: _ajouterFenetre,
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.tune),
                          label: const Text('Utiliser entrées d\'air détaillées'),
                          onPressed: _ajouterAirInlet,
                        ),
                      ],
                    ),

                    const Divider(),
                    Text('Entrées d\'air (détaillées)', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    // Air inlets list
                    if (_airInlets.isEmpty)
                      Text('Aucune entrée d\'air détaillée. Cliquez sur "Utiliser entrées d\'air détaillées" pour en ajouter.'),
                    ..._airInlets.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final ai = entry.value;
                      // compute effective flow and efficiency
                      double eff = 1.0;
                      switch (ai.state) {
                        case 'neuf': eff = 1.0; break;
                        case 'bon': eff = 0.9; break;
                        case 'moyen': eff = 0.7; break;
                        case 'mauvais': eff = 0.5; break;
                      }
                      double effectiveFlow = 0.0;
                      if (ai.module.contains('-')) {
                        final parts = ai.module.split('-').map((s) => double.tryParse(s) ?? 0).toList();
                        if (parts.length == 2) effectiveFlow = ((parts[0] + parts[1]) / 2) * eff;
                      } else {
                        effectiveFlow = (double.tryParse(ai.module) ?? 0) * eff;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: ai.room,
                                      items: [
                                        DropdownMenuItem(value: 'salon', child: Text(kRoomLabels['salon']!)),
                                        DropdownMenuItem(value: 'sejour', child: Text(kRoomLabels['sejour']!)),
                                        DropdownMenuItem(value: 'chambre', child: Text(kRoomLabels['chambre']!)),
                                        DropdownMenuItem(value: 'autre-piece', child: Text(kRoomLabels['autre-piece']!)),
                                      ],
                                      onChanged: (v) {
                                        setState(() {
                                          ai.room = v ?? ai.room;
                                          // If hygro type, update default module for the selected room
                                          if (ai.inletType == 'hygro') {
                                            ai.module = kDefaultHygroModuleByRoom[ai.room] ?? ai.module;
                                          }
                                        });
                                        _diagnostiquer();
                                      },
                                      decoration: const InputDecoration(labelText: 'Type de pièce'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: ai.inletType,
                                      items: [
                                        DropdownMenuItem(value: 'standard', child: Text('Autoréglable')),
                                        DropdownMenuItem(value: 'hygro', child: Text('Hygroréglable')),
                                      ],
                                      onChanged: (v) {
                                        setState(() {
                                          ai.inletType = v ?? ai.inletType;
                                          // default module when type changes: use room-specific hygro default
                                          if (ai.inletType == 'hygro') {
                                            ai.module = kDefaultHygroModuleByRoom[ai.room] ?? ai.module;
                                          } else {
                                            ai.module = '30';
                                          }
                                        });
                                        _diagnostiquer();
                                      },
                                      decoration: const InputDecoration(labelText: 'Type d\'entrée d\'air'),
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: ai.module,
                                      items: (ai.inletType == 'hygro') ? [
                                        DropdownMenuItem(value: '6-22', child: Text('6-22 m³/h (hygro)')),
                                        DropdownMenuItem(value: '6-45', child: Text('6-45 m³/h (hygro)')),
                                      ] : [
                                        DropdownMenuItem(value: '15', child: Text('15 m³/h')),
                                        DropdownMenuItem(value: '22', child: Text('22 m³/h')),
                                        DropdownMenuItem(value: '30', child: Text('30 m³/h')),
                                        DropdownMenuItem(value: '45', child: Text('45 m³/h')),
                                      ],
                                      onChanged: (v) { setState(() => ai.module = v ?? ai.module); _diagnostiquer(); },
                                      decoration: const InputDecoration(labelText: 'Module entrée d\'air'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: ai.state,
                                      items: [
                                        DropdownMenuItem(value: 'neuf', child: Text(kStateLabels['neuf']!)),
                                        DropdownMenuItem(value: 'bon', child: Text(kStateLabels['bon']!)),
                                        DropdownMenuItem(value: 'moyen', child: Text(kStateLabels['moyen']!)),
                                        DropdownMenuItem(value: 'mauvais', child: Text(kStateLabels['mauvais']!)),
                                      ],
                                      onChanged: (v) { setState(() => ai.state = v ?? ai.state); _diagnostiquer(); },
                                      decoration: const InputDecoration(labelText: 'État'),
                                    ),
                                  ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () { setState(() => _airInlets.removeAt(idx)); _diagnostiquer(); },
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: Text('Débit effectif : ${effectiveFlow.round()} m³/h')),
                                  SizedBox(
                                    width: 120,
                                    child: Stack(
                                      children: [
                                        Container(height: 10, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(6))),
                                        Container(width: (ai.state == 'neuf' ? 1.0 : ai.state == 'bon' ? 0.9 : ai.state == 'moyen' ? 0.7 : 0.5) * 120, height: 10, decoration: BoxDecoration(color: (ai.state == 'mauvais' ? Colors.red : ai.state == 'moyen' ? Colors.amber : Colors.green), borderRadius: BorderRadius.circular(6))),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${(eff * 100).round()}%')
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                    // Summary of air inlets
                    Builder(builder: (ctx) {
                      if (_airInlets.isEmpty) return const SizedBox.shrink();
                      double totalStandard = 0.0;
                      double totalHygroMin = 0.0;
                      double totalHygroMax = 0.0;
                      for (final ai in _airInlets) {
                        double eff = 1.0;
                        switch (ai.state) {
                          case 'neuf': eff = 1.0; break;
                          case 'bon': eff = 0.9; break;
                          case 'moyen': eff = 0.7; break;
                          case 'mauvais': eff = 0.5; break;
                        }
                        if (ai.module.contains('-')) {
                          final parts = ai.module.split('-').map((s) => double.tryParse(s) ?? 0).toList();
                          if (parts.length == 2) {
                            totalHygroMin += parts[0] * eff;
                            totalHygroMax += parts[1] * eff;
                          }
                        } else {
                          totalStandard += (double.tryParse(ai.module) ?? 0) * eff;
                        }
                      }
                      final totalMin = (totalStandard + totalHygroMin).round();
                      final totalMax = (totalStandard + (totalHygroMax > 0 ? totalHygroMax : 0)).round();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bilan entrées d\'air :', style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 6),
                          Text('Entrées autoréglables: ${totalStandard.round()} m³/h'),
                          if (totalHygroMax > 0) Text('Entrées hygroréglables: ${totalHygroMin.round()} à ${totalHygroMax.round()} m³/h'),
                          const SizedBox(height: 6),
                          Text('Débit total estimé: ${totalMin} ${totalHygroMax > 0 ? 'à $totalMax' : ''} m³/h'),
                          const SizedBox(height: 6),
                          Text('Ce débit doit correspondre à la somme des débits d\'extraction de votre VMC.'),
                        ],
                      );
                    }),
                    const SizedBox(height: 8),
                    // Button to add more air inlets
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter une entrée d\'air'),
                        onPressed: _ajouterAirInlet,
                      ),
                    ),
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
                    Text('Mesures VMC', style: Theme.of(context).textTheme.titleMedium),
                    ..._mesuresVMC.asMap().entries.map((entry) => ListTile(
                          title: Text('${entry.value.piece}'),
                          subtitle: Text('Débit: ${entry.value.debit} m³/h'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() => _mesuresVMC.removeAt(entry.key));
                              _diagnostiquer();
                            },
                          ),
                          onTap: () async {
                            final debit = await showDialog<double>(
                              context: context,
                              builder: (ctx) => SimpleDialog(
                                title: const Text('Débit mesuré (m³/h)'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(labelText: 'Débit (m³/h)'),
                                      onSubmitted: (v) => Navigator.pop(ctx, double.tryParse(v)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (debit != null) {
                              setState(() => entry.value.debit = debit);
                              _diagnostiquer();
                            }
                          },
                        )),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter une mesure'),
                      onPressed: _ajouterMesureVMC,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Diagnostic
            Card(
              color: _statut == 'succès'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Diagnostic', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('Type logement détecté : $_typeLogement'),
                    Text('Débit total fenêtres (ouvertes) : ${_debitTotalFenetres?.toStringAsFixed(1)} m³/h'),
                    Text('Débit total VMC : ${_debitTotalVMC?.toStringAsFixed(1)} m³/h'),
                    Text('Différence : ${_diff?.toStringAsFixed(1)} m³/h (${_diffPct?.toStringAsFixed(1)}%)'),
                    const SizedBox(height: 8),
                    Text('Statut : $_statut', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Message : $_message'),
                    Text('Recommandation : $_recommandation'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
