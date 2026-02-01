import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReglementationGazScreen extends StatefulWidget {
  const ReglementationGazScreen({super.key});

  @override
  State<ReglementationGazScreen> createState() => _ReglementationGazScreenState();
}

class _ReglementationGazScreenState extends State<ReglementationGazScreen> {
  // VASO - Réglette de contrôle (réponses: 'Oui' / 'Non' / 'NC')
  String _vasoPresent = 'NC';
  String _vasoConforme = 'NC';
  String _vasoObservation = '';

  // Robinet ROAI (réponses: 'Oui' / 'Non' / 'NC')
  String _roaiPresent = 'NC';
  String _roaiConforme = 'NC';
  String _roaiObservation = '';

  // Distances réglementaires
  final _distanceFenetreController = TextEditingController();
  final _distancePorteController = TextEditingController();
  final _distanceEvacuationController = TextEditingController();
  final _distanceAspirationController = TextEditingController();

  // Ventilation & Hotte
  String _typeHotte = 'Non';
  String _ventilationConforme = 'NC';
  String _ventilationObservation = '';

  // VMC Gaz (réponses: 'Oui' / 'Non' / 'NC')
  String _vmcPresent = 'NC';
  String _vmcConforme = 'NC';
  String _vmcObservation = '';

  // Détecteurs (réponses: 'Oui' / 'Non' / 'NC')
  String _detecteurCO = 'NC';
  String _detecteurGaz = 'NC';
  String _detecteursConformes = 'NC';

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Widget _buildRadioQuestion(String title, String value, ValueChanged<String?> onChanged, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitle != null) Padding(padding: const EdgeInsets.only(bottom: 4.0), child: Text(subtitle, style: const TextStyle(color: Colors.grey))),
        RadioListTile<String>(
          title: Text('$title — Oui'),
          value: 'Oui',
          groupValue: value,
          onChanged: onChanged,
          dense: true,
        ),
        RadioListTile<String>(
          title: Text('$title — Non'),
          value: 'Non',
          groupValue: value,
          onChanged: onChanged,
          dense: true,
        ),
        RadioListTile<String>(
          title: Text('$title — NC'),
          value: 'NC',
          groupValue: value,
          onChanged: onChanged,
          dense: true,
        ),
      ],
    );
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
      _vasoPresent = prefs.getString('vasoPresent') ?? 'NC';
      _vasoConforme = prefs.getString('vasoConforme') ?? 'NC';
      _vasoObservation = prefs.getString('vasoObservation') ?? '';
      _roaiPresent = prefs.getString('roaiPresent') ?? 'NC';
      _roaiConforme = prefs.getString('roaiConforme') ?? 'NC';
      _roaiObservation = prefs.getString('roaiObservation') ?? '';

      _distanceFenetreController.text = prefs.getString('distanceFenetre') ?? '';
      _distancePorteController.text = prefs.getString('distancePorte') ?? '';
      _distanceEvacuationController.text = prefs.getString('distanceEvacuation') ?? '';
      _distanceAspirationController.text = prefs.getString('distanceAspiration') ?? '';

      _typeHotte = prefs.getString('typeHotte') ?? 'Non';
      _ventilationConforme = prefs.getString('ventilationConforme') ?? 'NC';
      _ventilationObservation = prefs.getString('ventilationObservation') ?? '';

      _vmcPresent = prefs.getString('vmcPresent') ?? 'NC';
      _vmcConforme = prefs.getString('vmcConforme') ?? 'NC';
      _vmcObservation = prefs.getString('vmcObservation') ?? '';

      _detecteurCO = prefs.getString('detecteurCO') ?? 'NC';
      _detecteurGaz = prefs.getString('detecteurGaz') ?? 'NC';
      _detecteursConformes = prefs.getString('detecteursConformes') ?? 'NC';
    });
  }

  Future<void> _sauvegarderDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vasoPresent', _vasoPresent);
    await prefs.setString('vasoConforme', _vasoConforme);
    await prefs.setString('vasoObservation', _vasoObservation);

    await prefs.setString('roaiPresent', _roaiPresent);
    await prefs.setString('roaiConforme', _roaiConforme);
    await prefs.setString('roaiObservation', _roaiObservation);

    await prefs.setString('distanceFenetre', _distanceFenetreController.text);
    await prefs.setString('distancePorte', _distancePorteController.text);
    await prefs.setString('distanceEvacuation', _distanceEvacuationController.text);
    await prefs.setString('distanceAspiration', _distanceAspirationController.text);

    await prefs.setString('typeHotte', _typeHotte);
    await prefs.setString('ventilationConforme', _ventilationConforme);
    await prefs.setString('ventilationObservation', _ventilationObservation);

    await prefs.setString('vmcPresent', _vmcPresent);
    await prefs.setString('vmcConforme', _vmcConforme);
    await prefs.setString('vmcObservation', _vmcObservation);

    await prefs.setString('detecteurCO', _detecteurCO);
    await prefs.setString('detecteurGaz', _detecteurGaz);
    await prefs.setString('detecteursConformes', _detecteursConformes);
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
      ventilationOk = _ventilationConforme == 'Oui';

    import 'package:flutter/material.dart';
    import 'dynamic_reglementation_form.dart';

    class ReglementationGazScreen extends StatelessWidget {
      const ReglementationGazScreen({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Réglementation Gaz'),
                SizedBox(height: 2),
                Text('Réf. réglementation 23/02/2018', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          body: const DynamicReglementationForm(),
        );
      }
    }
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
                  _buildRadioQuestion('Détecteur CO présent', _detecteurCO, (v) => setState(() => _detecteurCO = v ?? 'NC')),
                  _buildRadioQuestion('Détecteur Gaz présent', _detecteurGaz, (v) => setState(() => _detecteurGaz = v ?? 'NC')),
                  if (_detecteurCO == 'Oui' && _detecteurGaz == 'Oui') ...[
                    _buildRadioQuestion('Détecteurs conformes', _detecteursConformes, (v) => setState(() => _detecteursConformes = v ?? 'NC'), subtitle: 'Fonctionnement, emplacement, normes'),
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
