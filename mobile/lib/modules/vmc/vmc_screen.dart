import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pdf_generator_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/mixins/controller_dispose_mixin.dart';
import '../../utils/mixins/snackbar_mixin.dart';

class VmcScreen extends StatefulWidget {
  const VmcScreen({super.key});

  @override
  State<VmcScreen> createState() => _VmcScreenState();
}

class _VmcScreenState extends State<VmcScreen> 
    with ControllerDisposeMixin, SnackBarMixin {
  // Données de base
  late final _nomClientController = registerController(TextEditingController());
  late final _adresseController = registerController(TextEditingController());
  late final _technicienController = registerController(TextEditingController());

  // Paramètres VMC
  int _nbBouches = 1;
  double _debitMesure = 0.0;
  double _debitMS = 0.0;
  bool _modulesFenetre = true;
  bool _etalonnagePortes = true;
  String _typeVmc = 'Automatique';

  // Calculs
  double _debitTotalCalcule = 0.0;
  double _debitNominal = 0.0;
  bool _conforme = false;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomClientController.text = prefs.getString('vmc_nom_client') ?? '';
      _adresseController.text = prefs.getString('vmc_adresse') ?? '';
      _technicienController.text = prefs.getString('vmc_technicien') ?? '';

      _nbBouches = prefs.getInt('vmc_nb_bouches') ?? 1;
      _debitMesure = prefs.getDouble('vmc_debit_mesure') ?? 0.0;
      _debitMS = prefs.getDouble('vmc_debit_ms') ?? 0.0;
      _modulesFenetre = prefs.getBool('vmc_modules_fenetre') ?? true;
      _etalonnagePortes = prefs.getBool('vmc_etalonnage_portes') ?? true;
      _typeVmc = prefs.getString('vmc_type') ?? 'Automatique';
    });
    _calculerResultats();
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vmc_nom_client', _nomClientController.text);
    await prefs.setString('vmc_adresse', _adresseController.text);
    await prefs.setString('vmc_technicien', _technicienController.text);

    await prefs.setInt('vmc_nb_bouches', _nbBouches);
    await prefs.setDouble('vmc_debit_mesure', _debitMesure);
    await prefs.setDouble('vmc_debit_ms', _debitMS);
    await prefs.setBool('vmc_modules_fenetre', _modulesFenetre);
    await prefs.setBool('vmc_etalonnage_portes', _etalonnagePortes);
    await prefs.setString('vmc_type', _typeVmc);
  }

  void _calculerResultats() {
    // Calcul du débit total (simplifié)
    _debitTotalCalcule = _nbBouches * 25.0; // 25 m³/h par bouche environ

    // Débit nominal selon la norme
    _debitNominal = _nbBouches * 30.0; // Valeur de référence

    // Vérification de conformité
    _conforme = _debitMesure >= (_debitNominal * 0.8) &&
                _debitMesure <= (_debitNominal * 1.2) &&
                _modulesFenetre &&
                _etalonnagePortes;

    setState(() {});
  }

  Future<void> _genererPDF() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final technicien = _technicienController.text.isNotEmpty ? _technicienController.text : 'Technicien';
      final entreprise = prefs.getString('entreprise') ?? 'Entreprise';

      final controles = {
        'nom_client': _nomClientController.text,
        'adresse': _adresseController.text,
        'type_vmc': _typeVmc,
        'nb_bouches': _nbBouches,
        'debit_mesure': _debitMesure,
        'debit_ms': _debitMS,
        'debit_total_calcule': _debitTotalCalcule,
        'debit_nominal': _debitNominal,
        'modules_fenetre': _modulesFenetre,
        'etalonnage_portes': _etalonnagePortes,
        'conforme': _conforme,
      };

      final pdfFile = await PdfGeneratorService.generateVmcPdf(
        technicien: technicien,
        entreprise: entreprise,
        dateCalcul: DateTime.now(),
        pieces: [controles],
        debitTotal: _debitTotalCalcule,
        typeVmc: _typeVmc,
      );

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Rapport de contrôle VMC',
      );

      showSuccess('PDF généré et partagé avec succès');
    } catch (e) {
      showError('Erreur lors de la génération du PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contrôle VMC'),
          actions: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _conforme ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _conforme ? 'CONFORME' : 'NON CONFORME',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _genererPDF,
              tooltip: 'Générer PDF',
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Installation'),
              Tab(text: 'Mesures'),
              Tab(text: 'Résultats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInstallationTab(),
            _buildMesuresTab(),
            _buildResultatsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations de l\'installation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nomClientController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du client',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _sauvegarderDonnees(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _adresseController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse d\'installation',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (value) => _sauvegarderDonnees(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _technicienController,
                    decoration: const InputDecoration(
                      labelText: 'Technicien',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _sauvegarderDonnees(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _typeVmc,
                    decoration: const InputDecoration(
                      labelText: 'Type de VMC',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Automatique', child: Text('VMC Automatique')),
                      DropdownMenuItem(value: 'Hygroréglable', child: Text('VMC Hygroréglable')),
                      DropdownMenuItem(value: 'Manuelle', child: Text('VMC Manuelle')),
                    ],
                    onChanged: (value) {
                      setState(() => _typeVmc = value!);
                      _sauvegarderDonnees();
                      _calculerResultats();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMesuresTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paramètres de mesure',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Nombre de bouches
                  TextFormField(
                    initialValue: _nbBouches.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Nombre de bouches',
                      border: OutlineInputBorder(),
                      helperText: 'Nombre total de bouches d\'extraction',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() => _nbBouches = int.tryParse(value) ?? 1);
                      _sauvegarderDonnees();
                      _calculerResultats();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Débit mesuré
                  TextFormField(
                    initialValue: _debitMesure.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Débit total mesuré (m³/h)',
                      border: OutlineInputBorder(),
                      helperText: 'Débit total mesuré sur l\'installation',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() => _debitMesure = double.tryParse(value) ?? 0.0);
                      _sauvegarderDonnees();
                      _calculerResultats();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Débit en m/s
                  TextFormField(
                    initialValue: _debitMS.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Débit en m/s',
                      border: OutlineInputBorder(),
                      helperText: 'Vitesse de l\'air mesurée',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() => _debitMS = double.tryParse(value) ?? 0.0);
                      _sauvegarderDonnees();
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contrôles complémentaires',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Modules aux fenêtres conformes'),
                    subtitle: const Text('Présence et fonctionnement des modules'),
                    value: _modulesFenetre,
                    onChanged: (value) {
                      setState(() => _modulesFenetre = value);
                      _sauvegarderDonnees();
                      _calculerResultats();
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Étalonnage des portes vérifié'),
                    subtitle: const Text('Contrôle de l\'étalonnage des portes'),
                    value: _etalonnagePortes,
                    onChanged: (value) {
                      setState(() => _etalonnagePortes = value);
                      _sauvegarderDonnees();
                      _calculerResultats();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Résultats des calculs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _buildResultItem('Débit total calculé', '${_debitTotalCalcule.toStringAsFixed(1)} m³/h'),
                  _buildResultItem('Débit nominal requis', '${_debitNominal.toStringAsFixed(1)} m³/h'),
                  _buildResultItem('Débit mesuré', '${_debitMesure.toStringAsFixed(1)} m³/h'),
                  _buildResultItem('Vitesse mesurée', '${_debitMS.toStringAsFixed(2)} m/s'),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _conforme ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _conforme ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _conforme ? Icons.check_circle : Icons.cancel,
                          color: _conforme ? Colors.green : Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _conforme ? 'INSTALLATION CONFORME' : 'INSTALLATION NON CONFORME',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _conforme ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommandations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (!_conforme) ...[
                    const Text(
                      '• Vérifier le nettoyage des bouches d\'extraction\n'
                      '• Contrôler l\'étanchéité du réseau\n'
                      '• Vérifier le réglage des débits\n'
                      '• Nettoyer ou remplacer les filtres',
                      style: TextStyle(height: 1.5),
                    ),
                  ] else ...[
                    const Text(
                      '• Maintenance annuelle recommandée\n'
                      '• Nettoyage régulier des filtres\n'
                      '• Contrôle périodique des débits',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}