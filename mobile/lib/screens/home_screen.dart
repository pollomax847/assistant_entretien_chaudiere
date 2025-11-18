import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/preferences_provider.dart';
import '../modules/puissance_chauffage/puissance_chauffage_screen.dart';
import '../modules/puissance_chauffage/puissance_expert_screen.dart';
import '../modules/vmc/vmc_screen.dart';
import '../modules/chaudiere/chaudiere_screen.dart';
import '../modules/reglementation_gaz/reglementation_gaz_screen.dart';
import '../modules/tests/top_compteur_gaz_screen.dart';
import '../modules/tests/valeurs_sondes_screen.dart';
import '../modules/releves/releve_technique_screen.dart';
import '../modules/config/entreprise_config_screen.dart';
import 'preferences_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chauffage Expert'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferencesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message de bienvenue
                if (preferences.technician.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.person, size: 32),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour ${preferences.technician}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              if (preferences.company.isNotEmpty)
                                Text(
                                  preferences.company,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                
                // Modules disponibles
                Text(
                  'Modules disponibles',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildModuleCard(
                        context,
                        'Puissance Simple',
                        'Calcul de puissance rapide',
                        Icons.calculate,
                        Colors.blue,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PuissanceChauffageScreen(),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'Puissance Expert',
                        'Calcul avancé détaillé',
                        Icons.engineering,
                        Colors.indigo,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PuissanceChaudiereExpertScreen(),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'VMC',
                        'Vérification conformité VMC',
                        Icons.air,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VMCScreen(),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'Test Compteur Gaz',
                        'Test débit et puissance',
                        Icons.gas_meter,
                        Colors.orange,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TopCompteurGazScreen(),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'Valeurs Sondes',
                        'Contrôle des sondes',
                        Icons.sensors,
                        Colors.purple,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ValeursSondesScreen(),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'Relevé Chaudière',
                        'Relevé technique chaudière',
                        Icons.local_fire_department,
                        Colors.red,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReleveTechniqueScreen(
                              type: TypeReleve.chaudiere,
                            ),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'Relevé PAC',
                        'Relevé pompe à chaleur',
                        Icons.heat_pump,
                        Colors.cyan,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReleveTechniqueScreen(
                              type: TypeReleve.pac,
                            ),
                          ),
                        ),
                      ),
                      _buildModuleCard(
                        context,
                        'Configuration',
                        'Paramètres entreprise',
                        Icons.business,
                        Colors.teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EntrepriseConfigScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
