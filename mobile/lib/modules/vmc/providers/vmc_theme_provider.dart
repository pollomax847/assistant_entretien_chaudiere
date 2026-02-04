import 'package:flutter/material.dart';
import '../../../utils/mixins/theme_state_mixin.dart';

/// Provider pour la gestion du thème du module VMC
class VmcThemeProvider with ChangeNotifier, ThemeStateMixin {
  static const String _themeKey = 'vmc_isDarkMode';

  VmcThemeProvider() {
    loadTheme(_themeKey);
  }

  /// Bascule entre le mode clair et le mode sombre
  void toggleTheme() {
    super.toggleTheme(_themeKey);
  }
}
