import 'package:flutter/material.dart';

class RTChaudiereForm extends StatefulWidget {
  const RTChaudiereForm({super.key});

  @override
  State<RTChaudiereForm> createState() => _RTChaudiereFormState();
}

class _RTChaudiereFormState extends State<RTChaudiereForm> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
  // Client & Info
  final Map<String, TextEditingController> _controllers = {
    'numClient': TextEditingController(),
    'nomClient': TextEditingController(),
    'adresseFact': TextEditingController(),
    'email': TextEditingController(),
    'telFixe': TextEditingController(),
    'telMobile': TextEditingController(),
    'rtName': TextEditingController(),
    'nomRT': TextEditingController(),
    'technicien': TextEditingController(),
    'matricule': TextEditingController(),
    'adresseInst': TextEditingController(),
    'surface': TextEditingController(),
    'nbOccupants': TextEditingController(),
    'anneeConst': TextEditingController(),
    'pieces': TextEditingController(),
    'marqueActuelle': TextEditingController(),
    'modeleActuel': TextEditingController(),
    'puissance': TextEditingController(),
    'largeur': TextEditingController(),
    'hauteur': TextEditingController(),
    'profondeur': TextEditingController(),
  };

  // --- BOOLEANS / DROPDOWNS ---
  bool _isAppartement = false;
  bool _isPavillon = false;
  bool _amiante = false;
  bool _accordCoPro = false;
  bool _chauffageSeul = false;
  bool _mixteInstantanee = true;
  bool _avecBallon = false;
  bool _radiateur = true;
  bool _plancherChauffant = false;

  // Conformité (Simplified list for example)
  final Map<String, bool> _conformite = {
    'compteur20m': false,
    'organeCoupure': false,
    'volume15m3': false,
    'ameneeAir': true,
    'terre': true,
    'flexiblePerime': false,
  };

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
        title: const Text('Relevé Technique Chaudière'),
        elevation: 4,
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
                _buildTextField('email', 'Email', keyboardType: TextInputType.emailAddress),
                _buildTextField('telMobile', 'Téléphone mobile', keyboardType: TextInputType.phone),
              ]),
              _buildSection('Environnement', [
                SwitchListTile(
                  title: const Text('Appartement'),
                  value: _isAppartement,
                  onChanged: (v) => setState(() => _isAppartement = v),
                ),
                SwitchListTile(
                  title: const Text('Pavillon'),
                  value: _isPavillon,
                  onChanged: (v) => setState(() => _isPavillon = v),
                ),
                _buildTextField('surface', 'Surface (m2)', keyboardType: TextInputType.number),
                _buildTextField('anneeConst', 'Année de construction', keyboardType: TextInputType.number),
              ]),
              _buildSection('Équipement en place', [
                _buildTextField('marqueActuelle', 'Marque'),
                _buildTextField('modeleActuel', 'Modèle'),
                Row(
                  children: [
                    Expanded(child: _buildTextField('puissance', 'Puissance (W)')),
                    Expanded(child: _buildTextField('largeur', 'Largeur (cm)')),
                  ],
                ),
                CheckboxListTile(
                  title: const Text('Chauffage seul'),
                  value: _chauffageSeul,
                  onChanged: (v) => setState(() => _chauffageSeul = v!),
                ),
                CheckboxListTile(
                  title: const Text('Mixte instantanée'),
                  value: _mixteInstantanee,
                  onChanged: (v) => setState(() => _mixteInstantanee = v!),
                ),
              ]),
              _buildSection('Conformité', _conformite.keys.map((key) {
                return CheckboxListTile(
                  title: Text(_getConformiteLabel(key)),
                  value: _conformite[key],
                  onChanged: (v) => setState(() => _conformite[key] = v!),
                );
              }).toList()),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('ENREGISTRER LE RELEVÉ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
      child: Column(
        children: [
          const Icon(Icons.plumbing, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            'RELEVÉ TECHNIQUE',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: title == 'Client',
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        children: children,
      ),
    );
  }

  Widget _buildTextField(String key, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  String _getConformiteLabel(String key) {
    switch (key) {
      case 'compteur20m': return 'Compteur à plus de 20m';
      case 'organeCoupure': return 'Organe de coupure gaz accessible';
      case 'volume15m3': return 'Volume supérieur à 15m3';
      case 'ameneeAir': return 'Amenée d\'air conforme';
      case 'terre': return 'Présence de la terre';
      case 'flexiblePerime': return 'Flexible gaz périmé';
      default: return key;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logic to save or export data
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Succès'),
          content: const Text('Le relevé technique a été enregistré localement.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
          ],
        ),
      );
    }
  }
}
