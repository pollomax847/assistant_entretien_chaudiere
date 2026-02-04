import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modules/puissance_chauffage/puissance_chauffage_expert_screen.dart';
import '../modules/reglementation_gaz/reglementation_gaz_screen.dart';
import '../modules/vmc/vmc_integration_screen.dart';
import '../modules/tests/enhanced_top_gaz_screen.dart';
import '../modules/chaudiere/chaudiere_screen.dart';
import '../modules/tirage/tirage_screen.dart';
import '../modules/ecs/ecs_screen.dart';
import '../modules/vase_expansion/vase_expansion_screen.dart';
import '../modules/equilibrage/equilibrage_screen.dart';
import '../modules/releves/screens/releve_technique_screen.dart';
import '../services/github_update_service.dart';
import '../services/update_service.dart';
import '../theme/app_theme.dart';
import '../utils/preferences_provider.dart';
import '../utils/widgets/update_banner_widget.dart';
import 'modules_list_screen.dart';
import 'first_launch_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  UpdateInfo? _updateInfo;
  bool _dismissedUpdate = false;

  @override
  void initState() {
    super.initState();
    // Charger le nom du technicien depuis les préférences
    final preferences = Provider.of<PreferencesProvider>(context, listen: false);
    _userName = preferences.technician ?? 'Utilisateur';
    
    // Vérifier les mises à jour au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
      // Essayer la mise à jour in-app Google Play d'abord, puis fallback GitHub
      _checkForUpdates();
    });
  }

  /// Vérifie les mises à jour (Google Play en priorité, puis GitHub en fallback)
  Future<void> _checkForUpdates() async {
    try {
      // Essayer Google Play d'abord
      await UpdateService().checkOnAppStart(context);
    } catch (e) {
      debugPrint('⚠️ Mise à jour Google Play échouée: $e, fallback GitHub...');
      // En cas d'erreur, utiliser GitHub comme fallback
      _checkGitHubUpdate();
    }
  }

  /// Vérifie les mises à jour GitHub et affiche la bannière
  Future<void> _checkGitHubUpdate() async {
    try {
      final updateInfo = await GitHubUpdateService().checkForUpdate();
      if (updateInfo != null && mounted && !_dismissedUpdate) {
        setState(() {
          _updateInfo = updateInfo;
        });
        // Affiche aussi le dialogue si c'est une mise à jour forcée
        if (updateInfo.forceUpdate && mounted) {
          await GitHubUpdateService().showUpdateDialog(context, updateInfo);
        }
      }
    } catch (e) {
      debugPrint('Erreur vérification mise à jour GitHub: $e');
    }
  }

  /// Vérifie si c'est le premier lancement et affiche le dialogue si nécessaire
  void _checkFirstLaunch() {
    final preferences = Provider.of<PreferencesProvider>(context, listen: false);
    
    if (preferences.isFirstLaunch) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const FirstLaunchDialog(),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Chauffage Expert',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2F5BB7),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download, color: Colors.white),
            tooltip: 'Vérifier les mises à jour',
            onPressed: () => GitHubUpdateService().checkManually(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Paramètres',
            onPressed: () => Navigator.pushNamed(context, '/preferences'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière de mise à jour (si disponible et non ignorée)
            if (_updateInfo != null && !_dismissedUpdate)
              UpdateBannerWidget(
                updateInfo: _updateInfo!,
                onDismiss: () => setState(() => _dismissedUpdate = true),
              ),
            
            // Carte de bienvenue orange
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Text(
                      '👋',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour $_userName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Expert en chauffage',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Raccourcis modules principaux
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildQuickAccessCard(
                      'Puissance',
                      Icons.calculate_outlined,
                      const Color(0xFF2196F3),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PuissanceChauffageExpertScreen(),
                        ),
                      ),
                    ),
                    _buildQuickAccessCard(
                      'VMC',
                      Icons.wind_power,
                      const Color(0xFF4CAF50),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VMCIntegrationScreen(),
                        ),
                      ),
                    ),
                    _buildQuickAccessCard(
                      'Test Gaz',
                      Icons.shield_outlined,
                      const Color(0xFFF44336),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EnhancedTopGazScreen(),
                        ),
                      ),
                    ),
                    _buildQuickAccessCard(
                      'Rapports',
                      Icons.description_outlined,
                      const Color(0xFF9C27B0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReleveTechniqueScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Carte Mise à Jour - VISIBLE & PROMINENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: Colors.blue.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_download_outlined,
                        size: 32,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vérifier les mises à jour',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rechercher de nouvelles versions',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => GitHubUpdateService().checkManually(context),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text('Vérifier'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section Modules Disponibles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Modules Disponibles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary.withOpacity(0.8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Catégories de modules
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryCard(
                          context,
                          'Calculs',
                          '1 modules',
                          Icons.calculate,
                          const Color(0xFF2196F3),
                          () => _showCalculsModules(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCategoryCard(
                          context,
                          'Tests',
                          '2 modules',
                          Icons.science,
                          const Color(0xFF4CAF50),
                          () => _showTestsModules(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryCard(
                          context,
                          'Relevés',
                          '3 modules',
                          Icons.assignment,
                          const Color(0xFFFF9800),
                          () => _showRelevesModules(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCategoryCard(
                          context,
                          'Contrôles',
                          '5 modules',
                          Icons.check_circle,
                          const Color(0xFF9C27B0),
                          () => _showControlesModules(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: color.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: color.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 36,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthodes pour afficher les listes de modules par catégorie
  void _showCalculsModules(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulesListScreen(
          title: 'Calculs',
          modules: [
            {
              'title': 'Puissance Chauffage',
              'subtitle': 'Calculs thermiques avancés',
              'icon': Icons.thermostat,
              'color': const Color(0xFFFF9800),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PuissanceChauffageExpertScreen(),
                    ),
                  ),
            },
          ],
        ),
      ),
    );
  }

  void _showTestsModules(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulesListScreen(
          title: 'Tests',
          modules: [
            {
              'title': 'Test Compteur Gaz',
              'subtitle': 'Mesure débit gaz',
              'icon': Icons.science,
              'color': const Color(0xFF4CAF50),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnhancedTopGazScreen(),
                    ),
                  ),
            },
            {
              'title': 'Tirage Cheminée',
              'subtitle': 'Simulation et analyse',
              'icon': Icons.air,
              'color': const Color(0xFF2196F3),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TirageScreen(),
                    ),
                  ),
            },
          ],
        ),
      ),
    );
  }

  void _showRelevesModules(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulesListScreen(
          title: 'Relevés',
          modules: [
            {
              'title': 'Relevé Technique',
              'subtitle': 'Chaudière, PAC, Clim',
              'icon': Icons.assignment,
              'color': const Color(0xFFFF9800),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReleveTechniqueScreen(),
                    ),
                  ),
            },
            {
              'title': 'Chaudière',
              'subtitle': 'Paramètres et mesures',
              'icon': Icons.fireplace,
              'color': const Color(0xFFE91E63),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChaudiereScreen(),
                    ),
                  ),
            },
            {
              'title': 'ECS',
              'subtitle': 'Eau chaude sanitaire',
              'icon': Icons.water_drop,
              'color': const Color(0xFF00BCD4),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EcsScreen(),
                    ),
                  ),
            },
          ],
        ),
      ),
    );
  }

  void _showControlesModules(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModulesListScreen(
          title: 'Contrôles',
          modules: [
            {
              'title': 'Réglementation Gaz',
              'subtitle': 'Contrôles Qualigaz',
              'icon': Icons.gas_meter,
              'color': const Color(0xFFF44336),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReglementationGazScreen(),
                    ),
                  ),
            },
            {
              'title': 'VMC',
              'subtitle': 'Ventilation mécanique',
              'icon': Icons.wind_power,
              'color': const Color(0xFF9C27B0),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VMCIntegrationScreen(),
                    ),
                  ),
            },
            {
              'title': 'Vase Expansion',
              'subtitle': 'Dimensionnement vase',
              'icon': Icons.storage,
              'color': const Color(0xFF607D8B),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VaseExpansionScreen(),
                    ),
                  ),
            },
            {
              'title': 'Équilibrage',
              'subtitle': 'Équilibrage hydraulique',
              'icon': Icons.balance,
              'color': const Color(0xFF795548),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EquilibrageScreen(),
                    ),
                  ),
            },
            {
              'title': 'Tirage',
              'subtitle': 'Analyse du tirage',
              'icon': Icons.air,
              'color': const Color(0xFFFF5722),
              'onTap': () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TirageScreen(),
                    ),
                  ),
            },
          ],
        ),
      ),
    );
  }
}