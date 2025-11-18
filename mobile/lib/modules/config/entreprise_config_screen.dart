import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntrepriseConfigScreen extends StatefulWidget {
  const EntrepriseConfigScreen({super.key});

  @override
  State<EntrepriseConfigScreen> createState() => _EntrepriseConfigScreenState();
}

class _EntrepriseConfigScreenState extends State<EntrepriseConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers pour les champs
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _codePostalController = TextEditingController();
  final _villeController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _siretController = TextEditingController();
  final _technicienNomController = TextEditingController();
  final _technicienQualificationController = TextEditingController();
  final _technicienCertificationController = TextEditingController();

  bool _isPremium = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _nomController.text = prefs.getString('entrepriseNom') ?? '';
      _adresseController.text = prefs.getString('entrepriseAdresse') ?? '';
      _codePostalController.text = prefs.getString('entrepriseCodePostal') ?? '';
      _villeController.text = prefs.getString('entrepriseVille') ?? '';
      _telephoneController.text = prefs.getString('entrepriseTelephone') ?? '';
      _emailController.text = prefs.getString('entrepriseEmail') ?? '';
      _siretController.text = prefs.getString('entrepriseSiret') ?? '';
      _technicienNomController.text = prefs.getString('technicienNom') ?? '';
      _technicienQualificationController.text = prefs.getString('technicienQualification') ?? '';
      _technicienCertificationController.text = prefs.getString('technicienCertification') ?? '';
      _isPremium = prefs.getBool('isPremium') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _sauvegarderDonnees() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    
    await Future.wait([
      prefs.setString('entrepriseNom', _nomController.text),
      prefs.setString('entrepriseAdresse', _adresseController.text),
      prefs.setString('entrepriseCodePostal', _codePostalController.text),
      prefs.setString('entrepriseVille', _villeController.text),
      prefs.setString('entrepriseTelephone', _telephoneController.text),
      prefs.setString('entrepriseEmail', _emailController.text),
      prefs.setString('entrepriseSiret', _siretController.text),
      prefs.setString('technicienNom', _technicienNomController.text),
      prefs.setString('technicienQualification', _technicienQualificationController.text),
      prefs.setString('technicienCertification', _technicienCertificationController.text),
      prefs.setBool('isPremium', _isPremium),
    ]);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration sauvegardée avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration Entreprise'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _sauvegarderDonnees,
              tooltip: 'Sauvegarder',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations entreprise
                    _buildSection(
                      'Informations Entreprise',
                      Icons.business,
                      [
                        _buildTextField(
                          controller: _nomController,
                          label: 'Nom de l\'entreprise',
                          icon: Icons.business,
                          validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
                        ),
                        _buildTextField(
                          controller: _adresseController,
                          label: 'Adresse',
                          icon: Icons.location_on,
                          maxLines: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildTextField(
                                controller: _codePostalController,
                                label: 'Code postal',
                                icon: Icons.mail,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                controller: _villeController,
                                label: 'Ville',
                                icon: Icons.location_city,
                              ),
                            ),
                          ],
                        ),
                        _buildTextField(
                          controller: _telephoneController,
                          label: 'Téléphone',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isNotEmpty == true && !value!.contains('@')) {
                              return 'Email invalide';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _siretController,
                          label: 'SIRET',
                          icon: Icons.badge,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isNotEmpty == true && value!.length != 14) {
                              return 'SIRET doit contenir 14 chiffres';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Informations technicien
                    _buildSection(
                      'Informations Technicien',
                      Icons.person,
                      [
                        _buildTextField(
                          controller: _technicienNomController,
                          label: 'Nom du technicien',
                          icon: Icons.person,
                          validator: (value) => value?.isEmpty == true ? 'Champ requis' : null,
                        ),
                        _buildTextField(
                          controller: _technicienQualificationController,
                          label: 'Qualification',
                          icon: Icons.school,
                          helperText: 'Ex: PGN, PGP, Qualigaz...',
                        ),
                        _buildTextField(
                          controller: _technicienCertificationController,
                          label: 'Certifications',
                          icon: Icons.verified,
                          maxLines: 2,
                          helperText: 'Certifications professionnelles',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Options premium
                    _buildSection(
                      'Options Avancées',
                      Icons.star,
                      [
                        SwitchListTile(
                          title: const Text('Mode Premium'),
                          subtitle: Text(
                            _isPremium
                                ? 'Fonctionnalités avancées activées'
                                : 'Accès aux fonctionnalités de base uniquement',
                          ),
                          value: _isPremium,
                          onChanged: (value) {
                            setState(() => _isPremium = value);
                          },
                          secondary: Icon(
                            _isPremium ? Icons.star : Icons.star_border,
                            color: _isPremium ? Colors.amber : null,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Bouton de sauvegarde
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _sauvegarderDonnees,
                        icon: const Icon(Icons.save),
                        label: const Text('Sauvegarder la configuration'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Informations
                    Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informations',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '• Ces informations seront utilisées dans les rapports PDF\n'
                              '• Le mode Premium débloque les fonctionnalités avancées\n'
                              '• Toutes les données sont stockées localement sur l\'appareil',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? helperText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _adresseController.dispose();
    _codePostalController.dispose();
    _villeController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _siretController.dispose();
    _technicienNomController.dispose();
    _technicienQualificationController.dispose();
    _technicienCertificationController.dispose();
    super.dispose();
  }
}
