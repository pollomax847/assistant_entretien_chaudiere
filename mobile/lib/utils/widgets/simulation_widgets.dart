import 'package:flutter/material.dart';

/// Widgets communs pour les écrans de simulation et de calcul
class SimulationWidgets {
  /// Construit un affichage de valeur principale avec couleur
  static Widget buildMainValue({
    required String value,
    required String label,
    required Color color,
    double fontSize = 52,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Construit une carte d'information avec icône
  static Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.blue, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit une jauge de statut avec message
  static Widget buildStatusGauge({
    required String message,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un slider personnalisé avec étiquettes
  static Widget buildLabeledSlider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String label,
    String Function(double)? valueFormatter,
    int? divisions,
    Color? activeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Text(
              valueFormatter?.call(min) ?? min.toStringAsFixed(2),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                activeColor: activeColor,
                onChanged: onChanged,
              ),
            ),
            Text(
              valueFormatter?.call(max) ?? max.toStringAsFixed(2),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  /// Construit un champ de saisie numérique
  static Widget buildNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? suffix,
    TextInputType keyboardType = const TextInputType.numberWithOptions(decimal: true),
    String? Function(String?)? validator,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Construit une section pliable pour les détails
  static Widget buildExpandableSection({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
    IconData? icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: icon != null ? Icon(icon) : null,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un indicateur de plage (ex: optimal, acceptable, danger)
  static Widget buildRangeIndicator({
    required double value,
    required double min,
    required double max,
    required List<RangeZone> zones,
  }) {
    final currentZone = zones.firstWhere(
      (zone) => value >= zone.min && value <= zone.max,
      orElse: () => zones.first,
    );

    return Column(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: zones.map((z) => z.color).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          currentZone.label,
          style: TextStyle(
            color: currentZone.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Construit un tableau de résultats
  static Widget buildResultsTable({
    required Map<String, String> data,
    Color? headerColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Classe pour définir une zone de plage avec couleur et label
class RangeZone {
  final double min;
  final double max;
  final Color color;
  final String label;

  RangeZone({
    required this.min,
    required this.max,
    required this.color,
    required this.label,
  });
}
