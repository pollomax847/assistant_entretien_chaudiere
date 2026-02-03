import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chauffageexpert/modules/reglementation_gaz/models/diagnostic_question.dart';

/// Mixin pour gérer la réglementation gaz commune à tous les relevés techniques
/// Utilise le système JSON dynamique pour charger les questions
mixin ReglementationGazMixin<T extends StatefulWidget> on State<T> {
  ReglementationQuestions? _reglementationQuestions;
  final Map<String, dynamic> _reglementationAnswers = {};
  final Map<String, TextEditingController> _reglementationObsControllers = {};
  bool _reglementationLoading = true;

  /// Charge les questions de réglementation depuis le JSON
  Future<void> loadReglementationQuestions() async {
    _reglementationQuestions = await ReglementationQuestions.loadFromAsset();
    
    // Charger les réponses sauvegardées
    for (final section in _reglementationQuestions!.sections) {
      for (final question in section.questions) {
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getString(question.id);
        if (saved != null) {
          _reglementationAnswers[question.id] = saved;
        }
        
        // Charger les observations
        final obsKey = '${question.id}_observation';
        final savedObs = prefs.getString(obsKey);
        if (savedObs != null && savedObs.isNotEmpty) {
          _reglementationObsControllers[question.id] = TextEditingController(text: savedObs);
        }
      }
    }
    
    setState(() => _reglementationLoading = false);
  }

  /// Dispose des controllers d'observations
  void disposeReglementationControllers() {
    for (final controller in _reglementationObsControllers.values) {
      controller.dispose();
    }
  }

  /// Sauvegarde toutes les réponses de réglementation
  Future<void> saveReglementationToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Sauvegarder toutes les réponses
    for (final entry in _reglementationAnswers.entries) {
      await prefs.setString(entry.key, entry.value.toString());
    }
    
    // Sauvegarder les observations
    for (final entry in _reglementationObsControllers.entries) {
      final obsKey = '${entry.key}_observation';
      await prefs.setString(obsKey, entry.value.text);
    }
  }

  /// Construit la section réglementation complète
  Widget buildSectionReglementation({bool showAllFields = true}) {
    if (_reglementationLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_reglementationQuestions == null) {
      return const Text('Erreur de chargement des questions');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _reglementationQuestions!.sections.map((section) {
        return _buildDynamicSection(section, showAllFields);
      }).toList(),
    );
  }

  /// Construit une section dynamique
  Widget _buildDynamicSection(DiagnosticSection section, bool showAllFields) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Row(
          children: [
            if (section.icone != null) ...[
              Text(section.icone!, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(section.titre)),
          ],
        ),
        children: section.questions.map((question) {
          return _buildQuestionWidget(question, showAllFields);
        }).toList(),
      ),
    );
  }

  /// Construit le widget pour une question
  Widget _buildQuestionWidget(DiagnosticQuestion question, bool showAllFields) {
    final currentValue = _reglementationAnswers[question.id];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            question.text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          if (question.description != null) ...[
            const SizedBox(height: 4),
            Text(
              question.description!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 8),
          
          // Input selon le type
          if (question.type == 'boolean')
            _buildBooleanField(question, currentValue)
          else if (question.type == 'select' && question.options != null)
            _buildSelectField(question, currentValue)
          else
            _buildDefaultField(question, currentValue),
          
          // Observations (si champ non conforme)
          if (showAllFields && currentValue == 'Non') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _reglementationObsControllers.putIfAbsent(
                question.id,
                () => TextEditingController(),
              ),
              decoration: const InputDecoration(
                labelText: 'Observations',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
            ),
          ],
          
          const Divider(),
        ],
      ),
    );
  }

  /// Champ booléen Oui/Non
  Widget _buildBooleanField(DiagnosticQuestion question, dynamic currentValue) {
    return Row(
      children: ['Oui', 'Non', 'NC'].map((option) {
        final isSelected = currentValue == option;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Center(child: Text(option)),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _reglementationAnswers[question.id] = option);
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Champ select avec options
  Widget _buildSelectField(DiagnosticQuestion question, dynamic currentValue) {
    return DropdownButtonFormField<String>(
      value: currentValue?.toString(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: question.options!.map((opt) {
        final value = opt['value'].toString();
        final label = opt['label'].toString();
        return DropdownMenuItem(value: value, child: Text(label));
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _reglementationAnswers[question.id] = value);
        }
      },
    );
  }

  /// Champ par défaut (Oui/Non/NC)
  Widget _buildDefaultField(DiagnosticQuestion question, dynamic currentValue) {
    return Row(
      children: ['Oui', 'Non', 'NC'].map((option) {
        final isSelected = currentValue == option;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Center(child: Text(option)),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _reglementationAnswers[question.id] = option);
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Récupère les données pour le PDF
  Map<String, String> getReglementationDataForPDF() {
    final Map<String, String> data = {};
    
    if (_reglementationQuestions == null) return data;
    
    for (final section in _reglementationQuestions!.sections) {
      for (final question in section.questions) {
        final value = _reglementationAnswers[question.id]?.toString() ?? 'NC';
        data[question.text] = value;
        
        // Ajouter les observations si présentes
        final obs = _reglementationObsControllers[question.id]?.text;
        if (obs != null && obs.isNotEmpty) {
          data['${question.text} - Observation'] = obs;
        }
      }
    }
    
    return data;
  }
}
