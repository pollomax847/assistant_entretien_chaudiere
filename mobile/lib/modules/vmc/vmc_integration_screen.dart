import 'package:flutter/material.dart';
import 'dart:math';

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
    // Débit total fenêtres (ouvertes uniquement)
    final debitTotalFenetres = _fenetres.where((f) => f.ouverte).fold(0.0, (sum, f) => sum + _debitsFenetre[f.taille]!);
    // Débit total VMC
    final debitTotalVMC = _mesuresVMC.fold(0.0, (sum, m) => sum + m.debit);

    _debitTotalFenetres = debitTotalFenetres;
    _debitTotalVMC = debitTotalVMC;

    // Comparaison
    _diff = debitTotalFenetres - debitTotalVMC;
    _diffPct = debitTotalVMC > 0 ? ((_debitTotalFenetres! - _debitTotalVMC!) / debitTotalVMC) * 100 : 0;
    if (_debitTotalVMC == 0) {
      _statut = 'erreur';
      _message = 'Aucune mesure VMC saisie';
      _recommandation = 'Ajoutez des mesures.';
    } else if (_debitTotalFenetres == 0) {
      _statut = 'erreur';
      _message = 'Aucune fenêtre ouverte';
      _recommandation = 'Ouvrez au moins une fenêtre.';
    } else if (_diffPct!.abs() <= 10) {
      _statut = 'succès';
      _message = 'Équilibre correct entre fenêtres et VMC';
      _recommandation = 'Aucune action nécessaire.';
    } else if (_diffPct! > 10) {
      _statut = 'alerte';
      _message = 'Débit fenêtres supérieur à la VMC';
      _recommandation = 'Fermez des fenêtres ou augmentez le débit VMC.';
    } else {
      _statut = 'alerte';
      _message = 'Débit fenêtres inférieur à la VMC';
      _recommandation = 'Ouvrez plus de fenêtres ou réduisez le débit VMC.';
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
            // Gestion des fenêtres
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fenêtres', style: Theme.of(context).textTheme.titleMedium),
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
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter une fenêtre'),
                      onPressed: _ajouterFenetre,
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
