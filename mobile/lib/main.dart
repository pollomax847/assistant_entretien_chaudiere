import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'utils/preferences_provider.dart';
import 'screens/preferences_screen.dart';
// import 'modules/equilibrage/equilibrage_screen.dart';
import 'modules/vase_expansion/vase_expansion_screen.dart';
import 'modules/ecs/ecs_screen.dart';
import 'modules/puissance_chauffage/gestion_pieces_screen.dart';
import 'modules/vmc/vmc_integration_screen.dart';
import 'modules/chaudiere/chaudiere_screen.dart';
import 'modules/reglementation_gaz/reglementation_gaz_screen.dart';
import 'modules/tests/enhanced_top_gaz_screen.dart';
// import 'modules/releves/releve_technique_screen.dart';
import 'modules/tirage/tirage_screen.dart';

enum TypeReleve {
  chaudiere,
  pac,
  clim,
}

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
            home: const HomeScreen(),
            routes: {
              '/preferences': (context) => const PreferencesScreen(),
              '/puissance-simple': (context) => const GestionPiecesScreen(),
              '/vmc': (context) => const VMCIntegrationScreen(),
              '/test-compteur-gaz': (context) => const EnhancedTopGazScreen(),
'/tirage': (context) => const TirageScreen(),
              // '/releve-chaudiere': (context) => ReleveTechniqueScreen(type: TypeReleve.chaudiere),
              // '/releve-pac': (context) => ReleveTechniqueScreen(type: TypeReleve.pac),
              // '/releve-clim': (context) => ReleveTechniqueScreen(type: TypeReleve.clim),
              '/ecs': (context) => const EcsScreen(),
              '/vase-expansion': (context) => const VaseExpansionScreen(),
              // '/equilibrage': (context) => const EquilibrageScreen(),
              '/reglementation-gaz': (context) => const ReglementationGazScreen(),
              '/chaudiere': (context) => const ChaudiereScreen(),
            },
          );
        },
      ),
    );
  }
}