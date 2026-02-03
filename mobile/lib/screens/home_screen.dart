import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chauffageexpert/utils/app_utils.dart';
import '../utils/preferences_provider.dart';
import '../modules/puissance_chauffage/gestion_pieces_screen.dart';
import '../modules/vmc/vmc_integration_screen.dart';
import '../modules/tests/top_compteur_gaz_screen.dart';
import '../modules/tests/valeurs_sondes_screen.dart';
import '../modules/releves/releve_technique_screen.dart';
import '../modules/releves/releve_technique_model.dart';
import '../modules/ecs/ecs_screen.dart';
import '../modules/equilibrage/equilibrage_screen.dart';
import '../modules/reglementation_gaz/reglementation_gaz_screen.dart';
import '../modules/vase_expansion/vase_expansion_screen.dart';
import '../modules/chaudiere/chaudiere_screen.dart';
import '../modules/tirage/tirage_screen.dart';
import 'preferences_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Définition de tous les modules disponibles
  late final List<Map<String, dynamic>> _allModules;

  @override
  void initState() {
    super.initState();
    _initializeModules();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  void _initializeModules() {
    _allModules = [
      {
        'id': 'puissance',
        'title': 'Puissance',
        'icon': Icons.calculate,
        'color': Colors.blue,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GestionPiecesScreen()),
        ),
      },
      {
        'id': 'vmc',
        'title': 'VMC',
        'icon': Icons.air,
        'color': Colors.purple,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VMCIntegrationScreen()),
        ),
      },
      {
        'id': 'test_gaz',
        'title': 'Test Gaz',
        'icon': Icons.security,
        'color': Colors.red,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TopCompteurGazScreen()),
        ),
      },
      {
        'id': 'releves',
        'title': 'Relevés',
        'icon': Icons.list_alt,
        'color': Colors.orange,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReleveTechniqueScreen(type: TypeReleve.chaudiere),
          ),
        ),
      },
      {
        'id': 'valeurs_sondes',
        'title': 'Sondes',
        'icon': Icons.thermostat,
        'color': Colors.green,
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ValeursSondesScreen()),
        ),
      },
      {
        'id': 'ecs',
        'title': 'ECS',
        'icon': Icons.water_drop,
        'color': Colors.lightBlue,
        'onTap': () => Navigator.pushNamed(context, '/ecs'),
      },
      {
        'id': 'equilibrage',
        'title': 'Équilibrage',
        'icon': Icons.balance,
        'color': Colors.indigo,
        'onTap': () => Navigator.pushNamed(context, '/equilibrage'),
      },
      {
        'id': 'reglementation',
        'title': 'Réglement.',
        'icon': Icons.gavel,
        'color': Colors.amber,
        'onTap': () => Navigator.pushNamed(context, '/reglementation-gaz'),
      },
      {
        'id': 'tirage',
        'title': 'Tirage',
        'icon': Icons.wind_power,
        'color': Colors.brown,
        'onTap': () => Navigator.pushNamed(context, '/tirage'),
      },
    ];
  }

  void _checkFirstLaunch() {
    final preferences = Provider.of<PreferencesProvider>(context, listen: false);
    if (preferences.isFirstLaunch) {
      _showFirstLaunchDialog();
    }
  }

  void _showFirstLaunchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêcher la fermeture en cliquant à l'extérieur
      builder: (context) => const FirstLaunchDialog(),
    );
  }

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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App banner / greeting
                if (preferences.technician.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB341), Color(0xFFF6A000)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.handshake, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour ${preferences.technician}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (preferences.company.isNotEmpty)
                              Text(
                                preferences.company,
                                style: const TextStyle(color: Colors.white70),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 18),

                // Favoris - horizontal scrollable cards
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: preferences.favoriteModules.isEmpty 
                        ? _allModules.take(6).length 
                        : preferences.favoriteModules.length,
                    itemBuilder: (context, index) {
                      // Si pas de favoris, afficher les 6 premiers modules
                      final moduleData = preferences.favoriteModules.isEmpty
                          ? _allModules[index]
                          : _allModules.firstWhere(
                              (m) => m['id'] == preferences.favoriteModules[index],
                              orElse: () => _allModules[0],
                            );
                      
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 6,
                          right: index == (preferences.favoriteModules.isEmpty ? 5 : preferences.favoriteModules.length - 1) ? 0 : 6,
                        ),
                        child: GestureDetector(
                          onTap: moduleData['onTap'] as VoidCallback,
                          onLongPress: () {
                            // Long press pour retirer des favoris
                            preferences.toggleFavorite(moduleData['id'] as String);
                          },
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (moduleData['color'] as Color).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    moduleData['icon'] as IconData,
                                    color: moduleData['color'] as Color,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  moduleData['title'] as String,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Modules Disponibles',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Grid modules - deux colonnes
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children: [
                    _buildLargeModuleCard(
                      context,
                      'Calculs',
                      '1 modules',
                      Icons.calculate,
                      Colors.blue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GestionPiecesScreen(),
                        ),
                      ),
                    ),
                    _buildLargeModuleCard(
                      context,
                      'Tests',
                      '2 modules',
                      Icons.science,
                      Colors.green,
                      () {},
                    ),
                    _buildLargeModuleCard(
                      context,
                      'Relevés',
                      '3 modules',
                      Icons.list_alt,
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReleveTechniqueScreen(type: TypeReleve.chaudiere),
                        ),
                      ),
                    ),
                    _buildLargeModuleCard(
                      context,
                      'Contrôles',
                      '5 modules',
                      Icons.check_circle,
                      Colors.purple,
                      () {},
                    ),
                  ],
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

  Widget _buildLargeModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 46, color: color),
            const SizedBox(height: 18),
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
    );
  }
}

class FirstLaunchDialog extends StatefulWidget {
  const FirstLaunchDialog({super.key});

  @override
  State<FirstLaunchDialog> createState() => _FirstLaunchDialogState();
}

class _FirstLaunchDialogState extends State<FirstLaunchDialog> {
  final _technicianController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _technicianController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _technicianController.removeListener(_updateButtonState);
    _technicianController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
  }

  void _saveAndContinue() {
    final preferences = Provider.of<PreferencesProvider>(context, listen: false);
    preferences.setTechnician(_technicianController.text.trim());
    preferences.setCompany(_companyController.text.trim());
    preferences.setFirstLaunchCompleted();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bienvenue !'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pour commencer, veuillez saisir vos informations personnelles :',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _technicianController,
            decoration: const InputDecoration(
              labelText: 'Nom du technicien',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Entreprise',
              prefixIcon: Icon(Icons.business),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _technicianController.text.trim().isNotEmpty ? _saveAndContinue : null,
          child: const Text('Continuer'),
        ),
      ],
    );
  }
}
