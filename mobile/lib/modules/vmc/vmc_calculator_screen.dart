import 'package:flutter/material.dart';
import '../../utils/mixins/measurement_photo_storage_mixin.dart';
import '../../utils/mixins/animation_style_mixin.dart';
import '../reglementation_gaz/widgets/measurement_photo_widget.dart';
import '../../models/vmc_models.dart';

class VMCCalculatorScreen extends StatefulWidget {
  const VMCCalculatorScreen({super.key});

  @override
  State<VMCCalculatorScreen> createState() => _VMCCalculatorScreenState();
}

class _VMCCalculatorScreenState extends State<VMCCalculatorScreen>
    with SingleTickerProviderStateMixin, AnimationStyleMixin, MeasurementPhotoStorageMixin {

  // Pagination - Extended to 5 steps
  int _currentPage = 0;
  final int _totalPages = 5;
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  // Housing configuration (from calculator)
  String _typeLogement = 'T2';
  String _typeVMC = 'HYGRO_B';

  // Vents (bouches) - from calculator
  List<Bouche> _bouches = [];

  // Air inlets - from calculator
  List<EntreeAir> _entreesAir = [];

  // Balance data - from existing diagnostic
  final List<Piece> _pieces = [Piece(type: 'chambre', nom: 'Chambre 1')];
  final List<Fenetre> _fenetres = [Fenetre(taille: 'moyenne')];
  final List<MesureVMC> _mesuresVMC = [MesureVMC(piece: 'Chambre 1', debit: 15)];
  final List<MesurePression> _mesuresPression = [];

  // Conformity data
  bool _isDebitMaster = true;
  String _conformite = '?';
  String _detail = '';
  String _valeurs = '';
  String _globalConformite = '';

  // Balance diagnostic data
  String? _typeLogementDiag;
  double? _debitTotalFenetres;
  double? _debitTotalVMC;
  double? _diff;
  double? _diffPct;
  String? _statut;
  String? _message;
  String? _recommandation;
  String? _pressionMessage;
  bool _pressionConforme = true;

  // Constants from calculator
  final Map<String, int> _minTotalDebit = {
    'T1': 10, 'T2': 10, 'T3': 15, 'T4': 20, 'T5': 25, 'T6': 30, 'T7': 35,
  };

  final Map<String, Map<String, dynamic>> _debits = {
    'T1': {'cuisine': {'base': 20, 'pointe': 75}, 'sdb': {'base': 15, 'pointe': 15}, 'wc': {'base': 15, 'pointe': 15}},
    'T2': {'cuisine': {'base': 30, 'pointe': 90}, 'sdb': {'base': 15, 'pointe': 15}, 'wc': {'base': 15, 'pointe': 15}},
    'T3': {'cuisine': {'base': 45, 'pointe': 105}, 'sdb': {'base': 30, 'pointe': 30}, 'wc': {'base': 15, 'pointe': 15}},
    'T4': {'cuisine': {'base': 45, 'pointe': 120}, 'sdb': {'base': 30, 'pointe': 30}, 'wc': {'base': 30, 'pointe': 30}},
    'T5': {'cuisine': {'base': 45, 'pointe': 135}, 'sdb': {'base': 30, 'pointe': 30}, 'wc': {'base': 30, 'pointe': 30}},
    'T6': {'cuisine': {'base': 45, 'pointe': 135}, 'sdb': {'base': 30, 'pointe': 30}, 'wc': {'base': 30, 'pointe': 30}},
    'T7': {'cuisine': {'base': 45, 'pointe': 135}, 'sdb': {'base': 30, 'pointe': 30}, 'wc': {'base': 30, 'pointe': 30}},
  };

  final List<String> _typesPiece = ['chambre', 'cuisine', 'salleDeBain', 'wc', 'salon'];
  final List<String> _taillesFenetre = ['petite', 'moyenne', 'grande', 'baie'];
  final Map<String, double> _debitsFenetre = {
    'petite': 10, 'moyenne': 20, 'grande': 30, 'baie': 45,
  };

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _initializeConformity();
    _diagnostiquer();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  void _initializeConformity() {
    _bouches.clear();
    _bouches.add(Bouche(piece: 'cuisine', diametre: 80, debit: _debits[_typeLogement]!['cuisine']['base'].toDouble(), vitesse: 0.0));
    _bouches.add(Bouche(piece: 'sdb', diametre: 80, debit: _debits[_typeLogement]!['sdb']['base'].toDouble(), vitesse: 0.0));
    _bouches.add(Bouche(piece: 'wc', diametre: 80, debit: _debits[_typeLogement]!['wc']['base'].toDouble(), vitesse: 0.0));
    if (_typeLogement == 'T4' || _typeLogement == 'T5' || _typeLogement == 'T6' || _typeLogement == 'T7') {
      _bouches.add(Bouche(piece: 'wc', diametre: 80, debit: _debits[_typeLogement]!['wc']['base'].toDouble(), vitesse: 0.0));
    }
    _entreesAir.clear();
    _entreesAir.add(EntreeAir(debit: 30.0));
    _entreesAir.add(EntreeAir(debit: 30.0));
    _calculerConformite();
  }

  void _updateLogement(String newLogement) {
    setState(() {
      _typeLogement = newLogement;
      _initializeConformity();
    });
  }

  void _calculerConformite() {
    double totalDebitExtraction = 0.0;
    StringBuffer details = StringBuffer();
    bool allConforme = true;

    for (var bouche in _bouches) {
      double rayon = bouche.diametre / 2000.0;
      double section = 3.14159 * rayon * rayon;
      if (_isDebitMaster) {
        double debitMs = bouche.debit / 3600.0;
        bouche.vitesse = section > 0 ? debitMs / section : 0.0;
      } else {
        double debitMs = bouche.vitesse * section;
        bouche.debit = debitMs * 3600.0;
      }

      var data = _debits[_typeLogement]![bouche.piece];
      num base = data['base'];
      num pointe = data['pointe'];
      bouche.conforme = bouche.debit >= base && bouche.debit <= pointe;
      if (!bouche.conforme) allConforme = false;
      bouche.detail = '${bouche.debit.toStringAsFixed(0)} m³/h (${base}-${pointe})';
      details.write('${bouche.piece.capitalize()}: ${bouche.detail}, Vitesse: ${bouche.vitesse.toStringAsFixed(2)} m/s\n');
      totalDebitExtraction += bouche.debit;
    }

    double totalIncoming = _entreesAir.fold(0.0, (sum, entree) => sum + entree.debit);
    int minTotal = _minTotalDebit[_typeLogement] ?? 10;
    bool globalConforme = totalDebitExtraction >= minTotal && totalIncoming >= totalDebitExtraction;

    setState(() {
      _conformite = allConforme ? '✅ CONFORME' : '❌ NON CONFORME';
      _detail = 'Détails par bouche:\n$details';
      _valeurs = 'Total Extraction: ${totalDebitExtraction.toStringAsFixed(0)} m³/h (min $minTotal)\nTotal Entrées d\'air: ${totalIncoming.toStringAsFixed(0)} m³/h';
      _globalConformite = globalConforme ? 'Global Conforme' : 'Global Non Conforme';
    });
  }

  void _diagnostiquer() {
    // Housing type from pieces
    int nbChambres = _pieces.where((p) => p.type == 'chambre').length;
    if (nbChambres == 0) _typeLogementDiag = 'T1';
    else if (nbChambres == 1) _typeLogementDiag = 'T2';
    else if (nbChambres == 2) _typeLogementDiag = 'T3';
    else if (nbChambres == 3) _typeLogementDiag = 'T4';
    else _typeLogementDiag = 'T5+';

    // Window debits
    _debitTotalFenetres = _fenetres.where((f) => f.ouverte).fold(0.0, (sum, f) => sum + (_debitsFenetre[f.taille] ?? 0));

    // VMC debits
    _debitTotalVMC = _mesuresVMC.fold(0.0, (sum, m) => sum + m.debit);

    _diff = _debitTotalFenetres! - _debitTotalVMC!;
    _diffPct = _debitTotalVMC! > 0 ? (_diff! / _debitTotalVMC!) * 100 : 0;

    // Status logic
    if (_debitTotalFenetres == 0) {
      _statut = 'erreur';
      _message = 'Aucune fenêtre ouverte';
      _recommandation = 'Ouvrez au moins une fenêtre.';
    } else if ((_debitTotalFenetres! - _debitTotalVMC!).abs() < 15) {
      _statut = 'succès';
      _message = 'Débits compatible - Équilibre proche';
      _recommandation = 'Aucune action nécessaire.';
    } else if (_debitTotalFenetres! > _debitTotalVMC!) {
      _statut = 'alerte';
      _message = 'Excès d\'air entrant - Fermer fenêtres ou augmenter VMC';
      _recommandation = 'Fermez des fenêtres ou augmentez le débit VMC.';
    } else {
      _statut = 'alerte';
      _message = 'Insuffisant d\'air entrant - Ouvrir fenêtres ou réduire VMC';
      _recommandation = 'Ouvrez plus de fenêtres ou réduisez le débit VMC.';
    }

    // Pressure analysis
    if (_mesuresPression.isNotEmpty) {
      int nbConformes = 0;
      List<String> problemes = [];
      for (final m in _mesuresPression) {
        bool ok = m.pressionPa >= 40 && m.pressionPa <= 120;
        if (m.typeBouche == BoucheType.soufflage) ok = m.pressionPa >= 50 && m.pressionPa <= 150;
        if (ok) nbConformes++;
        else problemes.add('${m.pieceNom}: ${m.pressionPa.toStringAsFixed(0)} Pa');
      }
      _pressionConforme = nbConformes == _mesuresPression.length;
      _pressionMessage = 'Pression: $nbConformes/${_mesuresPression.length} conformes.';
      if (!_pressionConforme) {
        _pressionMessage! += ' Problèmes: ${problemes.join(", ")}';
        _statut = 'alerte';
        _message = '${_message ?? ""}\nNon-conformité pression RE2020';
        _recommandation = '${_recommandation ?? ""}\nVérifiez encrassement ou réglages.';
      }
    } else {
      _pressionMessage = 'Aucune mesure de pression.';
    }
  }

  void _setPage(int nextPage) {
    setState(() => _currentPage = nextPage);
    _introController.forward(from: 0);
  }

  Widget _wrapSection(Widget child, int index) {
    final fade = buildStaggeredFade(_introController, index);
    final slide = buildStaggeredSlide(fade);
    return buildFadeSlide(fade: fade, slide: slide, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌬️ Calculateur VMC Complet'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Étape ${_currentPage + 1}/$_totalPages', style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _buildPageContent(),
            ),
          ),
          _buildNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentPage) {
      case 0: return _buildPageConfiguration();
      case 1: return _buildPageBouches();
      case 2: return _buildPageEntreesAir();
      case 3: return _buildPageMesures();
      case 4: return _buildPageResultats();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildPageConfiguration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wrapSection(
          Text('🏠 Configuration du logement', style: Theme.of(context).textTheme.headlineSmall),
          0,
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Type de logement',
          child: Column(
            children: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'].map((t) =>
              RadioListTile<String>(
                title: Text(t),
                value: t,
                groupValue: _typeLogement,
                onChanged: (v) => _updateLogement(v!),
              )
            ).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Type de VMC',
          child: Column(
            children: ['HYGRO_B', 'HYGRO_A', 'GAZ', 'SANITAIRE'].map((t) =>
              RadioListTile<String>(
                title: Text(t.replaceAll('_', ' ')),
                value: t,
                groupValue: _typeVMC,
                onChanged: (v) => setState(() => _typeVMC = v!),
              )
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPageBouches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wrapSection(
          Text('🔧 Configuration des bouches VMC', style: Theme.of(context).textTheme.headlineSmall),
          0,
        ),
        const SizedBox(height: 16),
        ..._bouches.map((b) => _buildBoucheCard(b)),
        ElevatedButton(
          onPressed: () => setState(() {
            _bouches.add(Bouche(piece: 'sdb', diametre: 80, debit: 15.0, vitesse: 0.0));
            _calculerConformite();
          }),
          child: const Text('Ajouter une bouche'),
        ),
        const SizedBox(height: 16),
        _buildConformitePreview(),
      ],
    );
  }

  Widget _buildPageEntreesAir() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wrapSection(
          Text('🌫️ Entrées d\'air (modules fenêtre)', style: Theme.of(context).textTheme.headlineSmall),
          0,
        ),
        const SizedBox(height: 16),
        ..._entreesAir.map((e) => _buildEntreeCard(e)),
        ElevatedButton(
          onPressed: () => setState(() {
            _entreesAir.add(EntreeAir(debit: 30.0));
            _calculerConformite();
          }),
          child: const Text('Ajouter une entrée d\'air'),
        ),
      ],
    );
  }

  Widget _buildPageMesures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wrapSection(
          Text('📊 Mesures d\'équilibre', style: Theme.of(context).textTheme.headlineSmall),
          0,
        ),
        const SizedBox(height: 16),
        // Pieces and windows (simplified)
        _buildSectionCard(
          title: 'Pièces et fenêtres',
          child: Column(
            children: [
              ..._pieces.map((p) => ListTile(title: Text(p.nom), subtitle: Text(p.type))),
              ..._fenetres.map((f) => ListTile(title: Text('Fenêtre ${f.taille}'), trailing: Checkbox(value: f.ouverte, onChanged: (v) => setState(() => f.ouverte = v!)))),
            ],
          ),
        ),
        // VMC measurements
        _buildSectionCard(
          title: 'Mesures VMC',
          child: Column(
            children: _mesuresVMC.map((m) => ListTile(title: Text(m.piece), subtitle: Text('${m.debit} m³/h'))).toList(),
          ),
        ),
        // Pressure measurements
        _buildSectionCard(
          title: 'Mesures de pression',
          child: Column(
            children: _mesuresPression.map((p) => ListTile(title: Text(p.pieceNom), subtitle: Text('${p.pressionPa} Pa'))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPageResultats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wrapSection(
          Text('📋 Résultats complets', style: Theme.of(context).textTheme.headlineSmall),
          0,
        ),
        const SizedBox(height: 16),
        // Conformity results
        _buildSectionCard(
          title: 'Conformité réglementaire',
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _conformite.contains('✅') ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(_conformite, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_detail, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Text(_valeurs, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Text(_globalConformite, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Balance results
        _buildSectionCard(
          title: 'Équilibre VMC',
          child: Column(
            children: [
              _buildDetailRow('Type logement', _typeLogementDiag ?? 'N/A'),
              _buildDetailRow('Débit fenêtres', '${_debitTotalFenetres?.toStringAsFixed(1)} m³/h'),
              _buildDetailRow('Débit VMC', '${_debitTotalVMC?.toStringAsFixed(1)} m³/h'),
              _buildDetailRow('Différence', '${_diff?.toStringAsFixed(1)} m³/h (${_diffPct?.toStringAsFixed(1)}%)'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(_message ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_recommandation ?? '', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              if (_pressionMessage != null) ...[
                const SizedBox(height: 12),
                Text(_pressionMessage!, style: const TextStyle(fontSize: 14)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoucheCard(Bouche bouche) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: bouche.piece,
              items: const [
                DropdownMenuItem(value: 'cuisine', child: Text('Cuisine')),
                DropdownMenuItem(value: 'sdb', child: Text('Salle de bain')),
                DropdownMenuItem(value: 'wc', child: Text('WC')),
              ],
              onChanged: (v) => setState(() {
                bouche.piece = v!;
                _calculerConformite();
              }),
            ),
            DropdownButton<int>(
              value: bouche.diametre,
              items: const [80, 100, 125, 150, 160, 200].map((d) =>
                DropdownMenuItem(value: d, child: Text('$d mm'))
              ).toList(),
              onChanged: (v) => setState(() {
                bouche.diametre = v!;
                _calculerConformite();
              }),
            ),
            TextField(
              controller: TextEditingController(text: bouche.debit.toStringAsFixed(1)),
              onChanged: (v) {
                bouche.debit = double.tryParse(v) ?? 0.0;
                _isDebitMaster = true;
                _calculerConformite();
              },
              decoration: const InputDecoration(labelText: 'Débit (m³/h)'),
              keyboardType: TextInputType.number,
            ),
            Text('Vitesse: ${bouche.vitesse.toStringAsFixed(2)} m/s'),
            Text('Conforme: ${bouche.conforme ? "Oui" : "Non"} - ${bouche.detail}'),
          ],
        ),
      ),
    );
  }

  Widget _buildEntreeCard(EntreeAir entree) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: TextEditingController(text: entree.debit.toStringAsFixed(1)),
          onChanged: (v) {
            entree.debit = double.tryParse(v) ?? 0.0;
            _calculerConformite();
          },
          decoration: const InputDecoration(labelText: 'Débit du module (m³/h)'),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget _buildConformitePreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(_conformite, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_globalConformite, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (_statut) {
      case 'succès': return Colors.green[100]!;
      case 'alerte': return Colors.orange[100]!;
      case 'erreur': return Colors.red[100]!;
      default: return Colors.grey[100]!;
    }
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 0 ? () => _setPage(_currentPage - 1) : null,
            child: const Text('Précédent'),
          ),
          Text('Étape ${_currentPage + 1} / $_totalPages'),
          ElevatedButton(
            onPressed: _currentPage < _totalPages - 1 ? () => _setPage(_currentPage + 1) : null,
            child: const Text('Suivant'),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}