import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'utils/preferences_provider.dart';

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
          );
        },
      ),
    );
  }
}
