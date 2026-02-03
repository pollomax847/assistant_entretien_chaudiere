import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'utils/preferences_provider.dart';
import 'screens/preferences_screen.dart';
import 'modules/equilibrage/equilibrage_screen.dart';
import 'modules/vase_expansion/vase_expansion_screen.dart';
import 'modules/ecs/ecs_screen.dart';
import 'modules/puissance_chauffage/gestion_pieces_screen.dart';
import 'modules/vmc/vmc_integration_screen.dart';
import 'modules/reglementation_gaz/reglementation_gaz_screen.dart';
import 'modules/tests/enhanced_top_gaz_screen.dart';
import 'modules/releves/releve_technique_screen.dart';
import 'modules/releves/releve_technique_model.dart';
import 'modules/chaudiere/chaudiere_screen.dart';
import 'modules/tirage/tirage_screen.dart';
import 'services/github_update_service.dart';

void main() {
  runApp(const ChauffageExpertApp());
}

class ChauffageExpertApp extends StatelessWidget {
  const ChauffageExpertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreferencesProvider()..loadPreferences(),
      child: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return MaterialApp(
            title: 'Chauffage Expert',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AppWithUpdateCheck(),
            routes: {
              '/preferences': (context) => const PreferencesScreen(),
              '/puissance-simple': (context) => const GestionPiecesScreen(),
              '/vmc': (context) => const VMCIntegrationScreen(),
              '/test-compteur-gaz': (context) => const EnhancedTopGazScreen(),
              '/releve-chaudiere': (context) => const ReleveTechniqueScreen(type: TypeReleve.chaudiere),
              '/releve-pac': (context) => const ReleveTechniqueScreen(type: TypeReleve.pac),
              '/releve-clim': (context) => const ReleveTechniqueScreen(type: TypeReleve.clim),
              '/ecs': (context) => const EcsScreen(),
              '/vase-expansion': (context) => const VaseExpansionScreen(),
              '/equilibrage': (context) => const EquilibrageScreen(),
              '/reglementation-gaz': (context) => const ReglementationGazScreen(),
              '/chaudiere': (context) => const ChaudiereScreen(),
              '/tirage': (context) => const TirageScreen(),
            },
          );
        },
      ),
    );
  }
}

// Widget wrapper qui vérifie les mises à jour au démarrage
class AppWithUpdateCheck extends StatefulWidget {
  const AppWithUpdateCheck({super.key});

  @override
  State<AppWithUpdateCheck> createState() => _AppWithUpdateCheckState();
}

class _AppWithUpdateCheckState extends State<AppWithUpdateCheck> {
  @override
  void initState() {
    super.initState();
    // Vérifier les mises à jour après le build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GitHubUpdateService().checkOnAppStart(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

 
