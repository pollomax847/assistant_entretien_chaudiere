import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/diagnostic_question.dart';

// Small reusable radio group widget to consolidate radio options
class RadioOption<T> {
  final T value;
  final String label;
  const RadioOption(this.value, this.label);
}

class RadioGroup<T> extends StatelessWidget {
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final List<RadioOption<T>> options;
  const RadioGroup({super.key, required this.groupValue, required this.onChanged, required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final selected = groupValue == opt.value;
        return ListTile(
          leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: Theme.of(context).colorScheme.primary),
          title: Text(opt.label),
          onTap: () => onChanged(opt.value),
          dense: true,
        );
      }).toList(),
    );
  }
}

class DynamicReglementationForm extends StatefulWidget {
  const DynamicReglementationForm({super.key});

  @override
  State<DynamicReglementationForm> createState() => _DynamicReglementationFormState();
}

class _DynamicReglementationFormState extends State<DynamicReglementationForm> {
  ReglementationQuestions? _questions;
  final Map<String, dynamic> _answers = {}; // id -> value
  final Map<String, TextEditingController> _obsControllers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final q = await ReglementationQuestions.loadFromAsset();
    final prefs = await SharedPreferences.getInstance();
    // initialize answers from prefs or defaults
    for (final section in q.sections) {
      for (final quest in section.questions) {
        final key = quest.id;
        if (prefs.containsKey(key)) {
          _answers[key] = prefs.getString(key);
        } else {
          if (quest.type == 'select') {
            if (quest.options != null && quest.options!.isNotEmpty) {
              _answers[key] = quest.options![0]['value'];
            } else {
              _answers[key] = '';
            }
          } else {
            // tri-state default 'NC'
            _answers[key] = 'NC';
          }
        }
        // observation controller
        final obsKey = '${key}_obs';
        _obsControllers[obsKey] = TextEditingController(text: prefs.getString(obsKey) ?? '');
      }
    }

    setState(() {
      _questions = q;
      _loading = false;
    });
  }

  @override
  void dispose() {
    for (final controller in _obsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildQuestionTile(DiagnosticQuestion q) {
    // Evaluate conditions for this question; hide if not satisfied
    if (!_evaluateConditions(q.conditions)) {
      return const SizedBox.shrink();
    }
    final id = q.id;
    final value = _answers[id];
    final obsController = _obsControllers['${id}_obs']!;

    if (q.type == 'select') {
      final items = (q.options ?? []).map<DropdownMenuItem<String>>((opt) {
        final v = opt['value']?.toString() ?? '';
        final l = opt['label']?.toString() ?? v;
        return DropdownMenuItem(value: v, child: Text(l));
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: (value is String && value.isNotEmpty) ? value : null,
            decoration: InputDecoration(labelText: q.text),
            items: items,
            onChanged: (v) {
              setState(() {
                _answers[id] = v ?? '';
              });
              _saveAnswer(id, v ?? '');
            },
          ),
          if (q.description != null) Padding(padding: const EdgeInsets.only(top:4.0), child: Text(q.description!, style: const TextStyle(color: Colors.grey))),
          const SizedBox(height:8),
          TextFormField(
            controller: obsController,
            decoration: const InputDecoration(labelText: 'Observations (optionnel)'),
            maxLines: 2,
            onChanged: (value) => _saveObservation(id, value),
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    // default: tri-state Oui/Non/NC
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (q.description != null) Padding(padding: const EdgeInsets.only(top:4.0), child: Text(q.description!, style: const TextStyle(color: Colors.grey))),
        RadioGroup<String>(
          groupValue: value as String?,
          onChanged: (v) => setState(() => _onAnswerChanged(id, v)),
          options: const [
            RadioOption('Oui', 'Oui'),
            RadioOption('Non', 'Non'),
            RadioOption('NC', 'NC'),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: obsController,
          decoration: const InputDecoration(labelText: 'Observations (optionnel)'),
          maxLines: 2,
          onChanged: (value) => _saveObservation(id, value),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  bool _evaluateConditions(List<dynamic>? conditions) {
    if (conditions == null || conditions.isEmpty) return true;
    for (final c in conditions) {
      if (c is! Map) continue;
      final key = c['key']?.toString();
      final operator = c['operator']?.toString() ?? 'equals';
      final expected = c['value'];

      if (key == null) continue;
      final actual = _answers.containsKey(key) ? _answers[key] : null;

      switch (operator) {
        case 'equals':
          if (actual?.toString() != expected?.toString()) return false;
          break;
        case 'not_equals':
          if (actual?.toString() == expected?.toString()) return false;
          break;
        case 'in':
          if (expected is List) {
            if (!expected.map((e) => e.toString()).contains(actual?.toString())) return false;
          } else {
            if (actual?.toString() != expected?.toString()) return false;
          }
          break;
        case 'not_in':
          if (expected is List) {
            if (expected.map((e) => e.toString()).contains(actual?.toString())) return false;
          } else {
            if (actual?.toString() == expected?.toString()) return false;
          }
          break;
        case 'exists':
          if (actual == null) return false;
          final s = actual.toString();
          if (s.isEmpty || s == 'NC') return false;
          break;
        case 'not_exists':
          if (actual != null) {
            final s2 = actual.toString();
            if (s2.isNotEmpty && s2 != 'NC') return false;
          }
          break;
        default:
          // unknown operator: treat as not satisfied
          return false;
      }
    }
    return true;
  }

  void _onAnswerChanged(String id, String? v) {
    _answers[id] = v ?? '';
    _saveAnswer(id, v ?? '');
  }

  Future<void> _saveAnswer(String id, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(id, value);
  }

  Future<void> _saveObservation(String id, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${id}_obs', value);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_questions == null) {
      return const Center(child: Text('Erreur de chargement des questions'));
    }

    return DefaultTabController(
      length: _questions!.sections.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Diagnostic Réglementation Gaz'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _questions!.sections.map((section) => Tab(text: section.titre)).toList(),
          ),
        ),
        body: TabBarView(
          children: _questions!.sections.map((section) => _buildSection(section)).toList(),
        ),
      ),
    );
  }

  Widget _buildSection(DiagnosticSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (section.icone != null)
                    Icon(_getIconForSection(section.icone!), size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      section.titre,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...section.questions.map((question) => Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildQuestionTile(question),
            ),
          )),
        ],
      ),
    );
  }

  IconData _getIconForSection(String iconName) {
    switch (iconName) {
      case 'build': return Icons.build;
      case 'security': return Icons.security;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'call_split': return Icons.call_split;
      case 'gavel': return Icons.gavel;
      case 'lightbulb': return Icons.lightbulb;
      default: return Icons.help;
    }
  }
}