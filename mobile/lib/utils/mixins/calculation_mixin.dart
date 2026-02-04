import 'package:flutter/material.dart';
import 'package:assistant_entreiten_chaudiere/utils/widgets/app_snackbar.dart';
import 'package:assistant_entreiten_chaudiere/utils/mixins/shared_preferences_mixin.dart';

/// Mixin pour les écrans de calcul (ECS, Vase d'expansion, Puissance, etc.)
/// 
/// Fournit des fonctionnalités communes :
/// - Gestion de l'état de calcul
/// - Affichage des résultats
/// - Widgets standardisés pour les champs de saisie
/// - Gestion de l'état de validité
mixin CalculationMixin<T extends StatefulWidget> on State<T>, SharedPreferencesMixin {
  /// État du calcul
  bool get isCalculated => _calculationResult != null;
  dynamic _calculationResult;
  
  /// Obtenir le résultat du calcul
  dynamic get calculationResult => _calculationResult;
  
  /// Définir le résultat du calcul
  set calculationResult(dynamic result) {
    setState(() {
      _calculationResult = result;
    });
  }
  
  /// Réinitialiser le calcul
  void resetCalculation() {
    setState(() {
      _calculationResult = null;
    });
  }
  
  /// Construit un champ de texte pour un nombre
  Widget buildNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? suffix,
    String? prefix,
    IconData? icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixText: prefix,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
  
  /// Construit un champ de texte avec validation
  Widget buildValidatedNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? suffix,
    IconData? icon,
    double? min,
    double? max,
    bool required = true,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Ce champ est requis';
        }
        
        final number = double.tryParse(value ?? '');
        if (number == null && value != null && value.isNotEmpty) {
          return 'Valeur numérique invalide';
        }
        
        if (number != null) {
          if (min != null && number < min) {
            return 'Minimum: $min';
          }
          if (max != null && number > max) {
            return 'Maximum: $max';
          }
        }
        
        return null;
      },
    );
  }
  
  /// Construit un dropdown
  Widget buildDropdown<V>({
    required V value,
    required List<V> items,
    required String Function(V) labelBuilder,
    required void Function(V?) onChanged,
    String? label,
    IconData? icon,
  }) {
    return DropdownButtonFormField<V>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(labelBuilder(item)),
      )).toList(),
      onChanged: onChanged,
    );
  }
  
  /// Construit une carte de résultat
  Widget buildResultCard({
    required String title,
    required String value,
    String? subtitle,
    Color? color,
    IconData? icon,
  }) {
    return Card(
      color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Construit une carte de résultat avec statut (succès/avertissement/erreur)
  Widget buildStatusResultCard({
    required String title,
    required String value,
    required String status, // 'success', 'warning', 'error'
    String? subtitle,
  }) {
    Color cardColor;
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'success':
        cardColor = Colors.green.shade50;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'warning':
        cardColor = Colors.orange.shade50;
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'error':
        cardColor = Colors.red.shade50;
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        cardColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        statusColor = Theme.of(context).colorScheme.onSurface;
        statusIcon = Icons.info;
    }
    
    return Card(
      color: cardColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  /// Construit un slider avec label
  Widget buildLabeledSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required void Function(double) onChanged,
    int? divisions,
    String? unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleSmall),
            Text(
              '${value.toStringAsFixed(1)}${unit ?? ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
  
  /// Construit un bouton de calcul
  Widget buildCalculateButton({
    required VoidCallback onPressed,
    String label = 'Calculer',
    IconData icon = Icons.calculate,
    bool enabled = true,
  }) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
  
  /// Construit un bouton de réinitialisation
  Widget buildResetButton({
    required VoidCallback onPressed,
    String label = 'Réinitialiser',
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
  
  /// Parse un nombre depuis un contrôleur de texte
  double? parseNumber(TextEditingController controller, {double? defaultValue}) {
    final value = double.tryParse(controller.text);
    return value ?? defaultValue;
  }
  
  /// Valide que tous les contrôleurs ont des valeurs valides
  bool validateControllers(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      if (controller.text.isEmpty || double.tryParse(controller.text) == null) {
        AppSnackBar.showError(
          context,
          'Veuillez remplir tous les champs avec des valeurs valides',
        );
        return false;
      }
    }
    return true;
  }
}
