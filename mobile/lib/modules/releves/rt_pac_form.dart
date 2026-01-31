import 'package:flutter/material.dart';

class RTPACForm extends StatefulWidget {
  const RTPACForm({super.key});

  @override
  State<RTPACForm> createState() => _RTPACFormState();
}

class _RTPACFormState extends State<RTPACForm> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  final Map<String, TextEditingController> _controllers = {
    'numClient': TextEditingController(),
    'nomClient': TextEditingController(),
    'adresseFact': TextEditingController(),
    'surfaceChauffer': TextEditingController(),
    'anneeConst': TextEditingController(),
    'nbRadiateurs': TextEditingController(),
    'consoFuel': TextEditingController(),
    'tension': TextEditingController(),
    'puissanceAbo': TextEditingController(),
    'distTableau': TextEditingController(),
    'deperditionTotale': TextEditingController(),
    'tauxCouverture': TextEditingController(),
  };

  // --- STATES ---
  bool _amiante = false;
  bool _ecsIndependante = false;
  bool _tableauConforme = false;
  bool _besoinTableauSupp = false;
  bool _uiEmplacementChaudiere = true;
  bool _vanne3Voies = false;
  bool _ballonDecouplage = false;
  String _typeEmetteur = 'Radiateur fonte';

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique PAC'),
        backgroundColor: Colors.indigo,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildHeader(),
              _buildSection('Client', [
                _buildTextField('numClient', 'Numéro client (gazelle)'),
                _buildTextField('nomClient', 'Nom du client'),
                _buildTextField('adresseFact', 'Adresse de facturation', maxLines: 2),
              ]),
              _buildSection('Description de l\'habitation', [
                _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
                SwitchListTile(
                  title: const Text('Repérage amiante établi'),
                  value: _amiante,
                  onChanged: (v) => setState(() => _amiante = v),
                ),
                _buildTextField('surfaceChauffer', 'Surface à chauffer (m2)', keyboardType: TextInputType.number),
              ]),
              _buildSection('Volumes & Émetteurs', [
                DropdownButtonFormField<String>(
                  value: _typeEmetteur,
                  decoration: const InputDecoration(labelText: 'Type d\'émetteur zone 1', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: ['Radiateur fonte', 'Radiateur acier', 'Plancher chauffant'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _typeEmetteur = v!),
                ),
                _buildTextField('nbRadiateurs', 'Nombre total de radiateurs', keyboardType: TextInputType.number),
              ]),
              _buildSection('Système Actuel', [
                SwitchListTile(
                  title: const Text('Production ECS indépendante'),
                  value: _ecsIndependante,
                  onChanged: (v) => setState(() => _ecsIndependante = v),
                ),
                _buildTextField('consoFuel', 'Consommation Fuel annuelle (L)', keyboardType: TextInputType.number),
              ]),
              _buildSection('Caractéristiques Électriques', [
                SwitchListTile(
                  title: const Text('Tableau électrique conforme'),
                  value: _tableauConforme,
                  onChanged: (v) => setState(() => _tableauConforme = v),
                ),
                _buildTextField('tension', 'Mesure de la tension (V)', keyboardType: TextInputType.number),
                _buildTextField('puissanceAbo', 'Puissance abonnement (kVA)', keyboardType: TextInputType.number),
                CheckboxListTile(
                  title: const Text('Besoin d\'un tableau supplémentaire'),
                  value: _besoinTableauSupp,
                  onChanged: (v) => setState(() => _besoinTableauSupp = v!),
                ),
              ]),
              _buildSection('Hydraulique', [
                CheckboxListTile(
                  title: const Text('Vanne 3 voies'),
                  value: _vanne3Voies,
                  onChanged: (v) => setState(() => _vanne3Voies = v!),
                ),
                CheckboxListTile(
                  title: const Text('Présence ballon découplage/tampon'),
                  value: _ballonDecouplage,
                  onChanged: (v) => setState(() => _ballonDecouplage = v!),
                ),
              ]),
              _buildSection('Dimensionnement', [
                _buildTextField('deperditionTotale', 'Déperdition totale (kW)', keyboardType: TextInputType.number),
                _buildTextField('tauxCouverture', 'Taux de couverture (%)', keyboardType: TextInputType.number),
              ]),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Relevé PAC enregistré')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('ENREGISTRER LE RELEVÉ PAC', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Column(
        children: [
          Icon(Icons.heat_pump, size: 50, color: Colors.indigo),
          SizedBox(height: 10),
          Text('RELEVÉ TECHNIQUE PAC', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(thickness: 2, color: Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        children: children,
      ),
    );
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}
