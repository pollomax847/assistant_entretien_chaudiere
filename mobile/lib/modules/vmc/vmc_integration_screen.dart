import 'package:flutter/material.dart';
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
  'cuisine': '45',
  'salle-de-bain': '30',
  'salleDeBain': '30',
  'wc': '15',
};

class Piece {
  String type;
  String nom;
  Piece({required this.type, required this.nom});
}

class Fenetre {
  String taille;
  bool ouverte;
  Fenetre({required this.taille, this.ouverte = false});
}

class AirInlet {
  String room;
  String inletType;
  String module;
  String state;
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
  // Pagination
  int _currentPage = 0;
  final int _totalPages = 3;

  // Données
  final List<Piece> _pieces = [Piece(type: 'chambre', nom: 'Chambre 1')];
  final List<Fenetre> _fenetres = [Fenetre(taille: 'moyenne')];
  final List<MesureVMC> _mesuresVMC = [MesureVMC(piece: 'Chambre 1', debit: 15)];
  final List<String> _typesPiece = ['chambre', 'cuisine', 'salleDeBain', 'wc', 'salon'];
  final List<String> _taillesFenetre = ['petite', 'moyenne', 'grande', 'baie'];
  final Map<String, double> _debitsFenetre = {
    'petite': 10,
    'moyenne': 20,
    'grande': 30,
    'baie': 45,
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

  // Entrées air
  final List<AirInlet> _airInlets = [];
  bool _useDetailedInlets = false;

  @override
  void initState() {
    super.initState();
    _diagnostiquer();
  }

  void _ajouterPiece() {
    setState(() {
      final newPiece = Piece(type: 'chambre', nom: 'Chambre ${_pieces.length + 1}');
      _pieces.add(newPiece);
      final defaultModule = kDefaultHygroModuleByRoom[newPiece.type] ?? '30';
      _airInlets.add(AirInlet(room: newPiece.type, inletType: 'standard', module: defaultModule));
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

    double debitTotalFenetres = 0.0;
    if (_useDetailedInlets && _airInlets.isNotEmpty) {
      double totalStandard = 0.0;
      double totalHygroMin = 0.0;
      double totalHygroMax = 0.0;
      for (final ai in _airInlets) {
        double eff = 1.0;
        switch (ai.state) {
          case 'neuf':
            eff = 1.0;
            break;
          case 'bon':
            eff = 0.9;
            break;
          case 'moyen':
            eff = 0.7;
            break;
          case 'mauvais':
            eff = 0.5;
            break;
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
        debitTotalFenetres = totalStandard + totalHygroMin;
      } else {
        debitTotalFenetres = totalStandard;
      }
    } else {
      debitTotalFenetres = _fenetres.where((f) => f.ouverte).fold(0.0, (sum, f) => sum + _debitsFenetre[f.taille]!);
    }

    final debitTotalVMC = _mesuresVMC.fold(0.0, (sum, m) => sum + m.debit);

    _debitTotalFenetres = debitTotalFenetres;
    _debitTotalVMC = debitTotalVMC;

    _diff = debitTotalFenetres - debitTotalVMC;
    _diffPct = debitTotalVMC > 0 ? ((_debitTotalFenetres! - _debitTotalVMC!) / debitTotalVMC) * 100 : 0;

    if (_debitTotalFenetres == 0) {
      _statut = 'erreur';
      _message = 'Aucune fenêtre ouverte';
      _recommandation = 'Ouvrez au moins une fenêtre.';
      setState(() {});
      return;
    }

    double extractionTotal = debitTotalVMC;
    if (extractionTotal == 0) {
      switch (_typeLogement) {
        case 'T1':
          extractionTotal = 75;
          break;
        case 'T2':
          extractionTotal = 90;
          break;
        case 'T3':
          extractionTotal = 105;
          break;
        case 'T4':
          extractionTotal = 120;
          break;
        case 'T5+':
          extractionTotal = 135;
          break;
        default:
          extractionTotal = 105;
      }
    }

    if ((debitTotalFenetres - extractionTotal).abs() < 15) {
      _statut = 'succès';
      _message = 'Débits compatible - Équilibre proche';
      _recommandation = 'Aucune action nécessaire.';
    } else if (debitTotalFenetres > extractionTotal) {
      _statut = 'alerte';
      _message = 'Excès d\'air entrant - Fermer fenêtres ou augmenter VMC';
      _recommandation = 'Fermez des fenêtres ou augmentez le débit VMC.';
    } else {
      _statut = 'alerte';
      _message = 'Insuffisant d\'air entrant - Ouvrir fenêtres ou réduire VMC';
      _recommandation = 'Ouvrez plus de fenêtres ou réduisez le débit VMC.';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostic VMC'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Étape courante
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Étape ${_currentPage + 1}/$_totalPages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // Contenu de la page
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildPageContent(),
            ),
          ),

          // Boutons de navigation
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Précédent'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                  ),
                ),
                Text(
                  'Étape ${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton.icon(
                  onPressed: _currentPage < _totalPages - 1
                      ? () => setState(() => _currentPage++)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentPage) {
      case 0:
        return _buildPage1();
      case 1:
        return _buildPage2();
      case 2:
        return _buildPage3();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🏠 Étape 1 : Pièces et Fenêtres',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // Pièces
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pièces du logement', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._pieces.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.blue.withOpacity(0.05),
                    leading: const Icon(Icons.home, color: Colors.blue),
                    title: Text('${entry.value.nom}'),
                    subtitle: Text(entry.value.type),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
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
                  ),
                )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter une pièce'),
                    onPressed: _ajouterPiece,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Fenêtres
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fenêtres', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._fenetres.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: entry.value.ouverte ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    leading: Icon(
                      entry.value.ouverte ? Icons.lightbulb_outline : Icons.lightbulb,
                      color: entry.value.ouverte ? Colors.green : Colors.grey,
                    ),
                    title: Text('Fenêtre ${entry.key + 1}'),
                    subtitle: Text('${entry.value.taille} - ${entry.value.ouverte ? "Ouverte" : "Fermée"}'),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: entry.value.ouverte,
                            onChanged: (val) {
                              setState(() => entry.value.ouverte = val ?? false);
                              _diagnostiquer();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            iconSize: 20,
                            onPressed: () {
                              setState(() => _fenetres.removeAt(entry.key));
                              _diagnostiquer();
                            },
                          ),
                        ],
                      ),
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
                  ),
                )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter une fenêtre'),
                    onPressed: _ajouterFenetre,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 Étape 2 : Mesures VMC',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mesures des débits (m³/h)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._mesuresVMC.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.orange.withOpacity(0.05),
                    leading: const Icon(Icons.speed, color: Colors.orange),
                    title: Text(entry.value.piece),
                    subtitle: Text('${entry.value.debit.toStringAsFixed(1)} m³/h'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            final controller = TextEditingController(text: entry.value.debit.toString());
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Modifier la mesure'),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(labelText: 'Débit (m³/h)'),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final val = double.tryParse(controller.text);
                                      if (val != null) {
                                        setState(() => entry.value.debit = val);
                                        _diagnostiquer();
                                        Navigator.pop(ctx);
                                      }
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => _mesuresVMC.removeAt(entry.key));
                            _diagnostiquer();
                          },
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter une mesure'),
                    onPressed: _ajouterMesureVMC,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✅ Étape 3 : Diagnostic',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        Card(
          color: _statut == 'succès'
              ? Colors.green.withOpacity(0.1)
              : _statut == 'alerte'
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _statut == 'succès'
                          ? Icons.check_circle
                          : _statut == 'alerte'
                              ? Icons.warning
                              : Icons.error,
                      size: 32,
                      color: _statut == 'succès'
                          ? Colors.green
                          : _statut == 'alerte'
                              ? Colors.orange
                              : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _statut?.toUpperCase() ?? 'N/A',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _statut == 'succès'
                                  ? Colors.green
                                  : _statut == 'alerte'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                          Text(_message ?? '', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Text('Détails du diagnostic:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildDetailRow('Type de logement', _typeLogement ?? 'N/A'),
                _buildDetailRow('Débit fenêtres (m³/h)', '${_debitTotalFenetres?.toStringAsFixed(1) ?? 0}'),
                _buildDetailRow('Débit VMC (m³/h)', '${_debitTotalVMC?.toStringAsFixed(1) ?? 0}'),
                _buildDetailRow('Différence', '${_diff?.toStringAsFixed(1) ?? 0} m³/h (${_diffPct?.toStringAsFixed(1) ?? 0}%)'),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💡 Recommandation:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_recommandation ?? '', style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
