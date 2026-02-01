import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DiagnosticQuestion {
  final String id;
  final String text;
  final String? type; // e.g., 'select', 'boolean', null -> text/default
  final String severity;
  final String? description;
  final List<dynamic>? options; // list of {value,label}
  final List<dynamic>? conditions;

  DiagnosticQuestion({
    required this.id,
    required this.text,
    this.type,
    required this.severity,
    this.description,
    this.options,
    this.conditions,
  });

  factory DiagnosticQuestion.fromMap(Map<String, dynamic> m) {
    return DiagnosticQuestion(
      id: m['id'] as String,
      text: m['text'] as String,
      type: m['type'] as String?,
      severity: m['severity'] as String? ?? 'low',
      description: m['description'] as String?,
      options: m['options'] as List<dynamic>?,
      conditions: m['conditions'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'type': type,
        'severity': severity,
        'description': description,
        'options': options,
        'conditions': conditions,
      };
}

class DiagnosticSection {
  final String id;
  final String titre;
  final String? icone;
  final List<DiagnosticQuestion> questions;

  DiagnosticSection({
    required this.id,
    required this.titre,
    this.icone,
    required this.questions,
  });

  factory DiagnosticSection.fromMap(Map<String, dynamic> m) {
    final qs = (m['questions'] as List<dynamic>?)
            ?.map((e) => DiagnosticQuestion.fromMap(e as Map<String, dynamic>))
            .toList() ??
        <DiagnosticQuestion>[];

    return DiagnosticSection(
      id: m['id'] as String,
      titre: m['titre'] as String,
      icone: m['icone'] as String?,
      questions: qs,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'titre': titre,
        'icone': icone,
        'questions': questions.map((q) => q.toMap()).toList(),
      };
}

class ReglementationQuestions {
  final List<DiagnosticSection> sections;

  ReglementationQuestions({required this.sections});

  factory ReglementationQuestions.fromMap(Map<String, dynamic> m) {
    final sections = (m['sections'] as List<dynamic>?)
            ?.map((s) => DiagnosticSection.fromMap(s as Map<String, dynamic>))
            .toList() ??
        <DiagnosticSection>[];
    return ReglementationQuestions(sections: sections);
  }

  static Future<ReglementationQuestions> loadFromAsset() async {
    final raw = await rootBundle.loadString('lib/data/reglementation_questions.json');
    final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
    return ReglementationQuestions.fromMap(decoded);
  }
}
