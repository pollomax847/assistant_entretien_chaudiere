import 'package:flutter/material.dart';
import 'dart:io';
import '../../utils/mixins/measurement_photo_storage_mixin.dart';
import '../reglementation_gaz/widgets/measurement_photo_widget.dart';

// Type de bouche : extraction ou soufflage
enum BoucheType { extraction, soufflage }

// Classe pour mesure pression (RE2020 protocole)
class MesurePression {
  String pieceNom;
  BoucheType typeBouche;
  double pressionPa;
  double? pressionRef;
  String? commentaire;
  List<File> photos; // Photos associées à cette mesure

  MesurePression({
    required this.pieceNom,
    required this.typeBouche,
    required this.pressionPa,
    this.pressionRef = 80.0,
    this.commentaire,
    this.photos = const [],
  });
}

// Localized labels and defaults
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

class MesureVMC {
  String piece;
  double debit;
  List<File> photos; // Photos associées à cette mesure

  MesureVMC({
    required this.piece,
    required this.debit,
    this.photos = const [],
  });
}

class VMCIntegrationScreen extends StatefulWidget {
  const VMCIntegrationScreen({super.key});

  @override
  State<VMCIntegrationScreen> createState() => _VMCIntegrationScreenState();
}

class _VMCIntegrationScreenState extends State<VMCIntegrationScreen>
    with MeasurementPhotoStorageMixin {
  // Pagination
  int _currentPage = 0;
  final int _totalPages = 4;

  // Données
  final List<Piece> _pieces = [Piece(type: 'chambre', nom: 'Chambre 1')];
  final List<Fenetre> _fenetres = [Fenetre(taille: 'moyenne')];
  final List<MesureVMC> _mesuresVMC = [MesureVMC(piece: 'Chambre 1', debit: 15)];
  final List<MesurePression> _mesuresPression = [];
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
  String? _pressionMessage;
  bool _pressionConforme = true;

  @override
  void initState() {
    super.initState();
    _diagnostiquer();
  }

  void _ajouterPiece() {
    setState(() {
      final newPiece = Piece(type: 'chambre', nom: 'Chambre ${_pieces.length + 1}');
      _pieces.add(newPiece);
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

  void _ajouterMesurePression() {
    setState(() {
      final nomPiece = _pieces.isNotEmpty
          ? _pieces[_mesuresPression.length % _pieces.length].nom
          : 'Pièce ${_mesuresPression.length + 1}';
      _mesuresPression.add(MesurePression(
        pieceNom: nomPiece,
        typeBouche: BoucheType.extraction,
        pressionPa: 80.0,
      ));
    });
    _diagnostiquer();
  }

  void _editerPression(int index, double nouvelleValeur, {String? comm}) {
    setState(() {
      _mesuresPression[index].pressionPa = nouvelleValeur;
      if (comm != null) _mesuresPression[index].commentaire = comm;
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

    double debitTotalFenetres = _fenetres.where((f) => f.ouverte).fold(0.0, (sum, f) => sum + (_debitsFenetre[f.taille] ?? 0));

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

    // Analyse des pressions (RE2020)
    String pressionMessage = '';
    _pressionConforme = true;

    if (_mesuresPression.isNotEmpty) {
      int nbConformes = 0;
      List<String> problemes = [];

      for (final m in _mesuresPression) {
        bool ok = m.pressionPa >= 40 && m.pressionPa <= 120;

        if (m.typeBouche == BoucheType.soufflage) {
          ok = m.pressionPa >= 50 && m.pressionPa <= 150;
        }

        if (ok) nbConformes++;
        else {
          problemes.add('${m.pieceNom} (${m.typeBouche.name}) : ${m.pressionPa.toStringAsFixed(0)} Pa → hors plage');
        }
      }

      _pressionConforme = (nbConformes == _mesuresPression.length);
      pressionMessage = 'Pression aux bouches : $nbConformes/${_mesuresPression.length} conformes (plage typique 40-120 Pa extraction).';
      if (!_pressionConforme) {
        pressionMessage += '\nProblèmes : ${problemes.join(', ')}';
      }
    } else {
      pressionMessage = 'Aucune mesure de pression aux bouches effectuée.';
    }

    _pressionMessage = pressionMessage;

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

    // Intégration pression au diagnostic
    if (_mesuresPression.isNotEmpty && !_pressionConforme) {
      _statut = 'alerte';
      _message = (_message ?? '') + '\nNon-conformité pression RE2020 (protocole §8.3.5)';
      _recommandation = (_recommandation ?? '') + '\nVérifiez encrassement, réglages bouches ou réseau (pression nominale ~80 Pa).';
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
      case 3:
        return _buildPage4();
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
                ..._mesuresVMC.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final mesure = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          tileColor: Colors.orange.withOpacity(0.05),
                          leading: const Icon(Icons.speed, color: Colors.orange),
                          title: Text(mesure.piece),
                          subtitle: Text('${mesure.debit.toStringAsFixed(1)} m³/h'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  final controller = TextEditingController(text: mesure.debit.toString());
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
                                              setState(() => mesure.debit = val);
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
                                  setState(() => _mesuresVMC.removeAt(idx));
                                  _diagnostiquer();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        MeasurementPhotoWidget(
                          title: '📸 Photos de la mesure VMC',
                          initialPhotos: mesure.photos,
                          onPhotosChanged: (photos) {
                            setState(() {
                              mesure.photos = photos;
                            });
                            saveMeasurementPhotos('vmc_mesure_${mesure.piece}_$idx', photos);
                          },
                          maxPhotos: 3,
                          recommended: false,
                        ),
                      ],
                    ),
                  );
                }),
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
          '🔬 Étape 3 : Mesures de pression (RE2020)',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Mesurez à ~80 Pa nominal. Plage typique extraction : 40-120 Pa.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
        const SizedBox(height: 16),

        ..._mesuresPression.asMap().entries.map((entry) {
          final idx = entry.key;
          final m = entry.value;
          final isExtraction = m.typeBouche == BoucheType.extraction;
          final minPa = isExtraction ? 40 : 50;
          final maxPa = isExtraction ? 120 : 150;
          final color = (m.pressionPa >= minPa && m.pressionPa <= maxPa)
              ? Colors.green
              : (m.pressionPa < minPa ? Colors.orange : Colors.red);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.speed, color: color),
                  title: Text('${m.pieceNom} - ${m.typeBouche.name}'),
                  subtitle: Text('${m.pressionPa.toStringAsFixed(0)} Pa (plage: $minPa-$maxPa Pa)'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          final controller = TextEditingController(text: m.pressionPa.toString());
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Pression ${m.pieceNom}'),
                              content: TextField(
                                controller: controller,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(labelText: 'Pression (Pa)'),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
                                TextButton(
                                  onPressed: () {
                                    final val = double.tryParse(controller.text);
                                    if (val != null) {
                                      _editerPression(idx, val);
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
                          setState(() => _mesuresPression.removeAt(idx));
                          _diagnostiquer();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              MeasurementPhotoWidget(
                title: '📸 Photos de la mesure de pression',
                initialPhotos: m.photos,
                onPhotosChanged: (photos) {
                  setState(() {
                    m.photos = photos;
                  });
                  saveMeasurementPhotos('vmc_pression_${m.pieceNom}_$idx', photos);
                },
                maxPhotos: 3,
                recommended: false,
              ),
              const SizedBox(height: 16),
            ],
          );
        }),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Ajouter mesure pression'),
            onPressed: _ajouterMesurePression,
          ),
        ),
      ],
    );
  }

  Widget _buildPage4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✅ Étape 4 : Diagnostic complet',
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
                if (_mesuresPression.isNotEmpty)
                  _buildDetailRow(
                    'Pression moyenne (Pa)',
                    '${(_mesuresPression.map((m) => m.pressionPa).reduce((a, b) => a + b) / _mesuresPression.length).toStringAsFixed(1)}',
                  ),
                const SizedBox(height: 20),
                if (_pressionMessage != null && _pressionMessage!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _pressionConforme ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (_pressionConforme ? Colors.blue : Colors.orange).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📊 Analyse pression RE2020:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(_pressionMessage ?? '', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
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
