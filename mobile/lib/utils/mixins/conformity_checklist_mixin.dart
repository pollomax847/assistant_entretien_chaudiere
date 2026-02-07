import 'package:flutter/material.dart';

/// Mixin pour gérer les checklists de conformité (chaudière & PAC)
mixin ConformityChecklistMixin<T extends StatefulWidget> on State<T> {
  
  /// Les 22 règles de conformité gaz pour chaudière
  final List<Map<String, String>> conformityRules = [
    {'id': 'compteur20m', 'label': 'Compteur à plus de 20m'},
    {'id': 'organeCoupure', 'label': 'Organe de coupure gaz accessible'},
    {'id': 'volume15m3', 'label': 'Volume supérieur à 15m³'},
    {'id': 'ameneeAir', 'label': 'Amenée d\'air conforme'},
    {'id': 'ligneSepar', 'label': 'Alimentée par ligne séparée'},
    {'id': 'robinetSapin', 'label': 'Robinet sapin installé'},
    {'id': 'extracteur', 'label': 'Présence extracteur motorisé'},
    {'id': 'boucheVMC', 'label': 'Présence bouche VMC sanitaire'},
    {'id': 'voyerOuvert', 'label': 'Présence foyer ouvert'},
    {'id': 'coudes3', 'label': 'Inférieur à 3 coudes'},
    {'id': 'priseElec', 'label': 'Prise électrique 230V accessible'},
    {'id': 'compteurMiPalier', 'label': 'Compteur gaz à mi-palier'},
    {'id': 'testRotation', 'label': 'Test non-rotation effectué'},
    {'id': 'ouvrant040', 'label': 'Ouvrant de 0,40m² minimum'},
    {'id': 'sortieAir', 'label': 'Sortie d\'air présente'},
    {'id': 'terre', 'label': 'Présence de la terre (PE)'},
    {'id': 'flexiblePerime', 'label': 'Flexible gaz périmé'},
    {'id': 'hotte', 'label': 'Présence hotte à raccorder'},
    {'id': 'ramonage', 'label': 'Ramonage effectué'},
    {'id': 'faitageDepassement', 'label': 'Dépasse faîtage sup. à 0,40m'},
    {'id': 'relaisDSC', 'label': 'Relais DSC installé'},
    {'id': 'boucheVMCGaz', 'label': 'Bouche VMC gaz présente'},
  ];

  /// Construit la section conformité gaz complète
  Widget buildConformitySection(Map<String, bool> conformityAnswers, Function(String, bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.red[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.assignment_turned_in, color: Colors.red),
        title: const Text(
          '✅ Conformité Gaz & Sécurité (22 Points)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
        ),
        subtitle: const Text('Vérifications réglementaires obligatoires'),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: buildConformityChecklist(conformityAnswers, onChanged),
          ),
          const SizedBox(height: 12),
          _buildConformitySummary(conformityAnswers),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Construit la checklist conformité interactive
  Widget buildConformityChecklist(Map<String, bool> answers, Function(String, bool) onChanged) {
    return Column(
      children: conformityRules
          .map((rule) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: CheckboxListTile(
                  value: answers[rule['id']!] ?? false,
                  onChanged: (bool? val) {
                    if (val != null) {
                      onChanged(rule['id']!, val);
                      setState(() {});
                    }
                  },
                  title: Text(rule['label']!),
                  tileColor: answers[rule['id']!] == true ? Colors.green[100] : Colors.grey[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  activeColor: Colors.green,
                ),
              ))
          .toList(),
    );
  }

  /// Affiche un résumé de la conformité
  Widget _buildConformitySummary(Map<String, bool> answers) {
    final checked = answers.values.where((v) => v).length;
    final total = conformityRules.length;
    final percentage = ((checked / total) * 100).toStringAsFixed(0);

    Color statusColor = checked < 10
        ? Colors.red
        : checked < 15
            ? Colors.orange
            : Colors.green;

    String statusText = checked < 10
        ? '⚠️ Conformité insuffisante'
        : checked < 15
            ? '⚠️ Conformité partielle'
            : '✅ Conformité complète';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 14),
              ),
              Text(
                '$checked/$total points',
                style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: checked / total,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% de conformité',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  /// Construit une section observations pour chaque règle (optionnel)
  Widget buildConformityObservations(
    Map<String, TextEditingController> observationControllers,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.amber[50],
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(Icons.edit_note, color: Colors.amber),
        title: const Text(
          '📝 Observations Conformité',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
        ),
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: conformityRules
                  .map((rule) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: observationControllers[rule['id']!] ??
                              TextEditingController(),
                          decoration: InputDecoration(
                            labelText: 'Observation: ${rule['label']!}',
                            hintText: 'Notes optionnelles...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 2,
                          minLines: 1,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Valide que le minimum de conformité est atteint
  bool validateMinimumConformity(Map<String, bool> answers, int minimumRequired) {
    final checked = answers.values.where((v) => v).length;
    return checked >= minimumRequired;
  }
}
