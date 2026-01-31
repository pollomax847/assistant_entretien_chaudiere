import 'package:flutter/material.dart';
import '../modules/equilibrage/equilibrage_screen.dart';
import '../modules/vase_expansion/vase_expansion_screen.dart';
import '../modules/ecs/ecs_screen.dart';
import 'package:provider/provider.dart';
import '../utils/preferences_provider.dart';
import '../utils/app_theme.dart';
import '../modules/puissance_chauffage/gestion_pieces_screen.dart';
import '../modules/vmc/vmc_integration_screen.dart';
import '../modules/chaudiere/chaudiere_screen.dart';
import '../modules/reglementation_gaz/reglementation_gaz_screen.dart';
import '../modules/tests/enhanced_top_gaz_screen.dart';
import '../modules/tests/valeurs_sondes_screen.dart';
import '../modules/releves/releve_technique_screen.dart';
import 'preferences_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _animationController.reset();
    _animationController.forward();
    Navigator.pop(context); // Close drawer
  }

  void _navigateToModule(String route) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Chauffage Expert'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/preferences'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                // Welcome section with improved design
                if (preferences.technician.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.secondaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.secondaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.waving_hand, color: Colors.white, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour ${preferences.technician}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (preferences.company.isNotEmpty)
                                Text(
                                  preferences.company,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Quick access modules in a horizontal scroll
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildQuickAccessCard(
                        'Puissance',
                        Icons.calculate,
                        Colors.blue,
                        () => Navigator.pushNamed(context, '/puissance-simple'),
                      ),
                      _buildQuickAccessCard(
                        'VMC',
                        Icons.air,
                        Colors.green,
                        () => Navigator.pushNamed(context, '/vmc'),
                      ),
                      _buildQuickAccessCard(
                        'Test Gaz',
                        Icons.security,
                        Colors.red,
                        () => Navigator.pushNamed(context, '/test-compteur-gaz'),
                      ),
                      _buildQuickAccessCard(
                        'Relevé',
                        Icons.assignment,
                        Colors.orange,
                        () => Navigator.pushNamed(context, '/releve-chaudiere'),
                      ),
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildMainContent(),
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

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.build, color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Chauffage Expert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Assistant Technique',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.calculate, 'Calculs', 0),
            _buildDrawerItem(Icons.science, 'Tests', 1),
            _buildDrawerItem(Icons.assignment, 'Relevés', 2),
            _buildDrawerItem(Icons.check_circle, 'Contrôles', 3),
            const Divider(),
            _buildDrawerSubItem('Puissance Chauffage', () => _navigateToModule('/puissance-simple')),
            _buildDrawerSubItem('VMC Integration', () => _navigateToModule('/vmc')),
            _buildDrawerSubItem('Test Compteur Gaz', () => _navigateToModule('/test-compteur-gaz')),
            _buildDrawerSubItem('ECS', () => _navigateToModule('/ecs')),
            _buildDrawerSubItem('Vase Expansion', () => _navigateToModule('/vase-expansion')),
            _buildDrawerSubItem('Équilibrage', () => _navigateToModule('/equilibrage')),
            _buildDrawerSubItem('Réglementation Gaz', () => _navigateToModule('/reglementation-gaz')),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Préférences'),
              onTap: () => _navigateToModule('/preferences'),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () => _navigateToModule('/about'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? AppTheme.primaryColor : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? AppTheme.primaryColor : Colors.black,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => _onItemTapped(index),
    );
  }

  Widget _buildDrawerSubItem(String title, VoidCallback onTap) {
    return ListTile(
      leading: const SizedBox(width: 24),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modules Disponibles',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildModuleCard('Calculs', _getCalculModules(), Icons.calculate, Colors.blue),
              _buildModuleCard('Tests', _getTestModules(), Icons.science, Colors.green),
              _buildModuleCard('Relevés', _getReleveModules(), Icons.assignment, Colors.orange),
              _buildModuleCard('Contrôles', _getControleModules(), Icons.check_circle, Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(String title, List<ModuleItem> modules, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showModuleDialog(title, modules),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '${modules.length} modules',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModuleDialog(String category, List<ModuleItem> modules) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modules $category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return ListTile(
                leading: Icon(module.icon, color: module.color),
                title: Text(module.title),
                subtitle: Text(module.subtitle),
                onTap: () {
                  Navigator.pop(context);
                  module.onTap();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  List<ModuleItem> _getCalculModules() {
    return [
      ModuleItem(
        title: 'Puissance Chauffage',
        subtitle: 'Calcul de la puissance nécessaire',
        icon: Icons.thermostat,
        color: Colors.blue,
        onTap: () => Navigator.pushNamed(context, '/puissance-simple'),
      ),
    ];
  }

  List<ModuleItem> _getTestModules() {
    return [
      ModuleItem(
        title: 'Test Compteur Gaz',
        subtitle: 'Test d\'arrêt sécurité (36 sec)',
        icon: Icons.security,
        color: Colors.red,
        onTap: () => Navigator.pushNamed(context, '/test-compteur-gaz'),
      ),
      ModuleItem(
        title: 'Valeurs Sondes',
        subtitle: 'Test des valeurs de sondes',
        icon: Icons.device_thermostat,
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ValeursSondesScreen()),
        ),
      ),
    ];
  }

  List<ModuleItem> _getReleveModules() {
    return [
      ModuleItem(
        title: 'Relevé Chaudière',
        subtitle: 'Relevé technique chaudière',
        icon: Icons.local_fire_department,
        color: Colors.red,
        onTap: () => Navigator.pushNamed(context, '/releve-chaudiere'),
      ),
      ModuleItem(
        title: 'Relevé PAC',
        subtitle: 'Relevé pompe à chaleur',
        icon: Icons.heat_pump,
        color: Colors.cyan,
        onTap: () => Navigator.pushNamed(context, '/releve-pac'),
      ),
      ModuleItem(
        title: 'Relevé Clim',
        subtitle: 'Relevé climatisation',
        icon: Icons.ac_unit,
        color: Colors.teal,
        onTap: () => Navigator.pushNamed(context, '/releve-clim'),
      ),
    ];
  }

  List<ModuleItem> _getControleModules() {
    return [
      ModuleItem(
        title: 'VMC',
        subtitle: 'Vérification conformité VMC',
        icon: Icons.air,
        color: Colors.green,
        onTap: () => Navigator.pushNamed(context, '/vmc'),
      ),
      ModuleItem(
        title: 'ECS',
        subtitle: 'Eau Chaude Sanitaire',
        icon: Icons.opacity,
        color: Colors.pink,
        onTap: () => Navigator.pushNamed(context, '/ecs'),
      ),
      ModuleItem(
        title: 'Vase Expansion',
        subtitle: "Pression vase d'expansion",
        icon: Icons.invert_colors,
        color: Colors.deepPurple,
        onTap: () => Navigator.pushNamed(context, '/vase-expansion'),
      ),
      ModuleItem(
        title: 'Équilibrage',
        subtitle: 'Radiateurs et plancher',
        icon: Icons.balance,
        color: Colors.amber,
        onTap: () => Navigator.pushNamed(context, '/equilibrage'),
      ),
      ModuleItem(
        title: 'Réglementation Gaz',
        subtitle: 'Contrôles sécurité gaz',
        icon: Icons.security,
        color: Colors.brown,
        onTap: () => Navigator.pushNamed(context, '/reglementation-gaz'),
      ),
    ];
  }
}

class ModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
