import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/preferences_provider.dart';
import '../utils/mixins/controller_dispose_mixin.dart';
import '../services/github_update_service.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préférences'),
      ),
      body: const PreferencesPanel(),
    );
  }
}

class PreferencesPanel extends StatefulWidget {
  const PreferencesPanel({super.key});

  @override
  State<PreferencesPanel> createState() => _PreferencesPanelState();
}

class _PreferencesPanelState extends State<PreferencesPanel>
  with ControllerDisposeMixin {
  late final _technicianController = registerController(TextEditingController());
  late final _companyController = registerController(TextEditingController());
  String _appVersion = 'Chargement...';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    final preferences = Provider.of<PreferencesProvider>(context, listen: false);
    _technicianController.text = preferences.technician;
    _companyController.text = preferences.company;
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, preferences, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bannière d'affichage des infos enregistrées
              if (preferences.technician.isNotEmpty || preferences.company.isNotEmpty)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.person_pin, color: Colors.blue.shade700, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (preferences.technician.isNotEmpty)
                                Text(
                                  preferences.technician,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              if (preferences.company.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  preferences.company,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Informations personnelles
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations personnelles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _technicianController,
                        decoration: InputDecoration(
                          labelText: 'Nom du technicien',
                          prefixIcon: const Icon(Icons.person),
                          helperText: _technicianController.text.isEmpty 
                            ? 'Entrez votre nom' 
                            : 'Actuellement: ${_technicianController.text}',
                        ),
                        onChanged: (value) {
                          preferences.setTechnician(value);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _companyController,
                        decoration: InputDecoration(
                          labelText: 'Entreprise',
                          prefixIcon: const Icon(Icons.business),
                          helperText: _companyController.text.isEmpty 
                            ? 'Entrez votre entreprise' 
                            : 'Actuellement: ${_companyController.text}',
                        ),
                        onChanged: (value) {
                          preferences.setCompany(value);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Paramètres d'affichage
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Affichage',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Mode sombre'),
                        subtitle: const Text('Utiliser le thème sombre'),
                        value: preferences.isDarkMode,
                        onChanged: (value) {
                          preferences.setDarkMode(value);
                        },
                        secondary: Icon(
                          preferences.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Module par défaut
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Module par défaut',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: preferences.defaultModule,
                        decoration: const InputDecoration(
                          labelText: 'Module de démarrage',
                          prefixIcon: Icon(Icons.home),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'home', child: Text('Accueil')),
                          DropdownMenuItem(value: 'puissance', child: Text('Puissance Chauffage')),
                          DropdownMenuItem(value: 'vmc', child: Text('VMC')),
                          DropdownMenuItem(value: 'chaudiere', child: Text('Chaudière')),
                          DropdownMenuItem(value: 'reglementation', child: Text('Réglementation Gaz')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            preferences.setDefaultModule(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Informations sur l'application
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À propos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('Version'),
                        subtitle: Text('$_appVersion (build $_buildNumber)'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.code),
                        title: Text('Développé avec'),
                        subtitle: Text('Flutter & Dart'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.system_update),
                        title: const Text('Vérifier les mises à jour'),
                        subtitle: const Text('Rechercher une nouvelle version'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          GitHubUpdateService().checkManually(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Version $_appVersion (build $_buildNumber)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}