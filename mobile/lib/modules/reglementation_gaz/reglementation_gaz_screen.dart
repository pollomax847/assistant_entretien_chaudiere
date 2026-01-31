import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReglementationGazScreen extends StatefulWidget {
  const ReglementationGazScreen({super.key});

  @override
  State<ReglementationGazScreen> createState() => _ReglementationGazScreenState();
}

class _ReglementationGazScreenState extends State<ReglementationGazScreen> {
  // VASO - Réglette de contrôle
  bool _vasoPresent = false;
  bool _vasoConforme = false;
  String _vasoObservation = '';

  // Robinet ROAI
  bool _roaiPresent = false;
  bool _roaiConforme = false;
  String _roaiObservation = '';

  // Distances réglementaires
  final _distanceFenetreController = TextEditingController();
  final _distancePorteController = TextEditingController();
  final _distanceEvacuationController = TextEditingController();
  final _distanceAspirationController = TextEditingController();

  // Ventilation & Hotte
  String _typeHotte = 'Non';
  bool _ventilationConforme = false;
  String _ventilationObservation = '';

  // VMC Gaz
  bool _vmcPresent = false;
  bool _vmcConforme = false;
  String _vmcObservation = '';

  // Détecteurs
  bool _detecteurCO = false;
  bool _detecteurGaz = false;
  bool _detecteursConformes = false;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  @override
  void dispose() {
    _distanceFenetreController.dispose();
    _distancePorteController.dispose();
    _distanceEvacuationController.dispose();
    _distanceAspirationController.dispose();
    super.dispose();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vasoPresent = prefs.getBool('vasoPresent') ?? false;
      _vasoConforme = prefs.getBool('vasoConforme') ?? false;
      _vasoObservation = prefs.getString('vasoObservation') ?? '';

      _roaiPresent = prefs.getBool('roaiPresent') ?? false;
      _roaiConforme = prefs.getBool('roaiConforme') ?? false;
      _roaiObservation = prefs.getString('roaiObservation') ?? '';

      _distanceFenetreController.text = prefs.getString('distanceFenetre') ?? '';
      _distancePorteController.text = prefs.getString('distancePorte') ?? '';
      _distanceEvacuationController.text = prefs.getString('distanceEvacuation') ?? '';
      _distanceAspirationController.text = prefs.getString('distanceAspiration') ?? '';

      _typeHotte = prefs.getString('typeHotte') ?? 'Non';
      _ventilationConforme = prefs.getBool('ventilationConforme') ?? false;
      _ventilationObservation = prefs.getString('ventilationObservation') ?? '';

      _vmcPresent = prefs.getBool('vmcPresent') ?? false;
      _vmcConforme = prefs.getBool('vmcConforme') ?? false;
      _vmcObservation = prefs.getString('vmcObservation') ?? '';

      _detecteurCO = prefs.getBool('detecteurCO') ?? false;
      _detecteurGaz = prefs.getBool('detecteurGaz') ?? false;
      _detecteursConformes = prefs.getBool('detecteursConformes') ?? false;
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vasoPresent', _vasoPresent);
    await prefs.setBool('vasoConforme', _vasoConforme);
    await prefs.setString('vasoObservation', _vasoObservation);

    await prefs.setBool('roaiPresent', _roaiPresent);
    await prefs.setBool('roaiConforme', _roaiConforme);
    await prefs.setString('roaiObservation', _roaiObservation);

    await prefs.setString('distanceFenetre', _distanceFenetreController.text);
    await prefs.setString('distancePorte', _distancePorteController.text);
    await prefs.setString('distanceEvacuation', _distanceEvacuationController.text);
    await prefs.setString('distanceAspiration', _distanceAspirationController.text);

    await prefs.setString('typeHotte', _typeHotte);
    await prefs.setBool('ventilationConforme', _ventilationConforme);
    await prefs.setString('ventilationObservation', _ventilationObservation);

    await prefs.setBool('vmcPresent', _vmcPresent);
    await prefs.setBool('vmcConforme', _vmcConforme);
    await prefs.setString('vmcObservation', _vmcObservation);

    await prefs.setBool('detecteurCO', _detecteurCO);
    await prefs.setBool('detecteurGaz', _detecteurGaz);
    await prefs.setBool('detecteursConformes', _detecteursConformes);
  }

  void _verifierConformite() {
    // Vérification des distances (normes GRDF)
    bool distancesConformes = true;
    String messageDistances = '';

    if (_distanceFenetreController.text.isNotEmpty) {
      double distance = double.tryParse(_distanceFenetreController.text) ?? 0;
      if (distance < 40) {
        distancesConformes = false;
        messageDistances += 'Distance fenêtre < 40cm. ';
      }
    }

    if (_distancePorteController.text.isNotEmpty) {
      double distance = double.tryParse(_distancePorteController.text) ?? 0;
      if (distance < 40) {
        distancesConformes = false;
        messageDistances += 'Distance porte < 40cm. ';
      }
    }

    if (_distanceEvacuationController.text.isNotEmpty) {
      double distance = double.tryParse(_distanceEvacuationController.text) ?? 0;
      if (distance < 40) {
        distancesConformes = false;
        messageDistances += 'Distance évacuation < 40cm. ';
      }
    }

    if (_distanceAspirationController.text.isNotEmpty) {
      double distance = double.tryParse(_distanceAspirationController.text) ?? 0;
      if (distance < 40) {
        distancesConformes = false;
        messageDistances += 'Distance aspiration < 40cm. ';
      }
    }

    // Vérification ventilation selon type de hotte
    bool ventilationOk = false;
    if (_typeHotte == 'Non') {
      ventilationOk = true; // Pas de hotte = conforme
    } else {
      ventilationOk = _ventilationConforme;
    }

    // Vérification VMC Gaz
    bool vmcOk = !_vmcPresent || _vmcConforme;

    // Vérification détecteurs
    bool detecteursOk = _detecteurCO && _detecteurGaz && _detecteursConformes;

    // Affichage du résumé
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Résumé de conformité'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildConformiteItem('VASO', _vasoPresent && _vasoConforme),
              _buildConformiteItem('Robinet ROAI', _roaiPresent && _roaiConforme),
              _buildConformiteItem('Distances réglementaires', distancesConformes),
              _buildConformiteItem('Ventilation & Hotte', ventilationOk),
              _buildConformiteItem('VMC Gaz', vmcOk),
              _buildConformiteItem('Détecteurs CO/Gaz', detecteursOk),
              if (messageDistances.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Détails distances: $messageDistances',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
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

  Widget _buildConformiteItem(String label, bool conforme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            conforme ? Icons.check_circle : Icons.cancel,
            color: conforme ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Réglementation Gaz'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Sécurité'),
              Tab(text: 'Distances'),
              Tab(text: 'Ventilation'),
              Tab(text: 'Détecteurs'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSecuriteTab(),
            _buildDistancesTab(),
            _buildVentilationTab(),
            _buildDetecteursTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _verifierConformite,
          child: const Icon(Icons.check_circle),
          tooltip: 'Vérifier conformité',
        ),
      ),
    );
  }

  Widget _buildSecuriteTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VASO
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Réglette VASO',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vérification de l\'état des canalisations et raccordements',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Réglette présente'),
                    value: _vasoPresent,
                    onChanged: (value) => setState(() => _vasoPresent = value),
                  ),
                  if (_vasoPresent) ...[
                    SwitchListTile(
                      title: const Text('Conforme'),
                      value: _vasoConforme,
                      onChanged: (value) => setState(() => _vasoConforme = value),
                    ),
                    TextFormField(
                      initialValue: _vasoObservation,
                      decoration: const InputDecoration(
                        labelText: 'Observations',
                        hintText: 'État des canalisations, anomalies...',
                      ),
                      maxLines: 3,
                      onChanged: (value) => _vasoObservation = value,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Robinet ROAI
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Robinet ROAI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Robinet d\'arrêt d\'urgence individuel',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Robinet présent'),
                    value: _roaiPresent,
                    onChanged: (value) => setState(() => _roaiPresent = value),
                  ),
                  if (_roaiPresent) ...[
                    SwitchListTile(
                      title: const Text('Conforme'),
                      value: _roaiConforme,
                      onChanged: (value) => setState(() => _roaiConforme = value),
                    ),
                    TextFormField(
                      initialValue: _roaiObservation,
                      decoration: const InputDecoration(
                        labelText: 'Observations',
                        hintText: 'Accessibilité, état, marquage...',
                      ),
                      maxLines: 3,
                      onChanged: (value) => _roaiObservation = value,
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

  Widget _buildDistancesTab() {
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
                    'Distances réglementaires (GRDF)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Distances minimales entre canalisations et ouvrants',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue.shade50,
                    child: const Text(
                      'Distance minimale réglementaire: 40 cm',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _distanceFenetreController,
                    decoration: const InputDecoration(
                      labelText: 'Distance fenêtres (cm)',
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _distancePorteController,
                    decoration: const InputDecoration(
                      labelText: 'Distance portes (cm)',
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _distanceEvacuationController,
                    decoration: const InputDecoration(
                      labelText: 'Distance évacuations (cm)',
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _distanceAspirationController,
                    decoration: const InputDecoration(
                      labelText: 'Distance aspirations (cm)',
                      suffixText: 'cm',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVentilationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotte Cuisine
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hotte de Cuisine',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _typeHotte,
                    decoration: const InputDecoration(
                      labelText: 'Type de hotte',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Non', child: Text('Pas de hotte')),
                      DropdownMenuItem(value: 'SimpleFlux', child: Text('Hotte simple flux')),
                      DropdownMenuItem(value: 'DoubleFlux', child: Text('Hotte double flux')),
                    ],
                    onChanged: (value) => setState(() => _typeHotte = value!),
                  ),
                  if (_typeHotte != 'Non') ...[
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Ventilation conforme'),
                      value: _ventilationConforme,
                      onChanged: (value) => setState(() => _ventilationConforme = value),
                    ),
                    TextFormField(
                      initialValue: _ventilationObservation,
                      decoration: const InputDecoration(
                        labelText: 'Observations ventilation',
                        hintText: 'État des conduits, débits, normes...',
                      ),
                      maxLines: 3,
                      onChanged: (value) => _ventilationObservation = value,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // VMC Gaz
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VMC Gaz',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vérification de l\'absence d\'interaction VMC/Appareil gaz',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('VMC présente'),
                    value: _vmcPresent,
                    onChanged: (value) => setState(() => _vmcPresent = value),
                  ),
                  if (_vmcPresent) ...[
                    SwitchListTile(
                      title: const Text('Conforme (pas d\'interaction)'),
                      value: _vmcConforme,
                      onChanged: (value) => setState(() => _vmcConforme = value),
                    ),
                    TextFormField(
                      initialValue: _vmcObservation,
                      decoration: const InputDecoration(
                        labelText: 'Observations VMC',
                        hintText: 'Type VMC, interactions détectées...',
                      ),
                      maxLines: 3,
                      onChanged: (value) => _vmcObservation = value,
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

  Widget _buildDetecteursTab() {
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
                    'Détecteurs de Sécurité',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Détecteurs de monoxyde de carbone et de gaz',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.red.shade50,
                    child: const Text(
                      'Obligatoire selon normes en vigueur',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Détecteur CO présent'),
                    value: _detecteurCO,
                    onChanged: (value) => setState(() => _detecteurCO = value),
                  ),
                  SwitchListTile(
                    title: const Text('Détecteur Gaz présent'),
                    value: _detecteurGaz,
                    onChanged: (value) => setState(() => _detecteurGaz = value),
                  ),
                  if (_detecteurCO && _detecteurGaz) ...[
                    SwitchListTile(
                      title: const Text('Détecteurs conformes'),
                      subtitle: const Text('Fonctionnement, emplacement, normes'),
                      value: _detecteursConformes,
                      onChanged: (value) => setState(() => _detecteursConformes = value),
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
}
