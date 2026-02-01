import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/diagnostic_question.dart';

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
            value: (value is String && value.isNotEmpty) ? value : null,
            decoration: InputDecoration(labelText: q.text),
            items: items,
            onChanged: (v) {
              setState(() {
                _answers[id] = v ?? '';
              });
            },
          ),
          if (q.description != null) Padding(padding: const EdgeInsets.only(top:4.0), child: Text(q.description!, style: const TextStyle(color: Colors.grey))),
          const SizedBox(height:8),
        ],
      );
    }

    // default: tri-state Oui/Non/NC
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (q.description != null) Padding(padding: const EdgeInsets.only(top:4.0), child: Text(q.description!, style: const TextStyle(color: Colors.grey))),
        RadioListTile<String>(
          title: const Text('Oui'),
          value: 'Oui',
          groupValue: value as String?,
          onChanged: (v) => setState(() => _answers[id] = v),
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('Non'),
          value: 'Non',
          groupValue: value as String?,
          onChanged: (v) => setState(() => _answers[id] = v),
          dense: true,
        ),
        RadioListTile<String>(
          title: const Text('NC'),
          value: 'NC',
          groupValue: value as String?,
          onChanged: (v) => setState(() => _onAnswerChanged(id, v)),
          dense: true,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: obsController,
          decoration: const InputDecoration(labelText: 'Observations (optionnel)'),
          maxLines: 2,
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
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final e in _answers.entries) {
      final key = e.key;
      final val = e.value?.toString() ?? '';
      await prefs.setString(key, val);
    }
    for (final obs in _obsControllers.entries) {
      await prefs.setString(obs.key, obs.value.text);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Réponses de la réglementation sauvegardées')));
  }

  @override
  void dispose() {
    for (final c in _obsControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_questions == null) return const Center(child: Text('Aucune question trouvée'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ..._questions!.sections.map((section) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [ if (section.icone!=null) Text(section.icone!), const SizedBox(width:8), Text(section.titre, style: const TextStyle(fontSize:18, fontWeight: FontWeight.bold)) ]),
                      const SizedBox(height:8),
                      ...section.questions.map((q) => _buildQuestionTile(q)).toList(),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _saveAll,
            icon: const Icon(Icons.save),
            label: const Text('Sauvegarder réponses'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
