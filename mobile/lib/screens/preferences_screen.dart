import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/preferences_provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _technicianController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final preferences = Provider.of<PreferencesProvider>(context, listen: false);
    _technicianController.text = preferences.technician;
    _companyController.text = preferences.company;
  }

  @override
  void dispose() {
    _technicianController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préférences'),
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          decoration: const InputDecoration(
                            labelText: 'Nom du technicien',
                            prefixIcon: Icon(Icons.person),
                          ),
                          onChanged: (value) {
                            preferences.setTechnician(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _companyController,
                          decoration: const InputDecoration(
                            labelText: 'Entreprise',
                            prefixIcon: Icon(Icons.business),
                          ),
                          onChanged: (value) {
                            preferences.setCompany(value);
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
                        const ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Version'),
                          subtitle: Text('1.0.0'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.code),
                          title: Text('Développé avec'),
                          subtitle: Text('Flutter & Dart'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}