import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:chauffageexpert/modules/releves/releve_technique_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/reglementation_gaz/models/diagnostic_question.dart';

// Exporter un relevé technique en JSON (inclut les champs de réglementation gaz)
class JSONExporter {
  static Future<File> exportReleveTechniqueJson(
    ReleveTechnique releve,
    String typeReleve,
  ) async {
    final output = await getApplicationDocumentsDirectory();
    final filename = 'releve_${typeReleve}_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${output.path}/$filename');
    final Map<String, dynamic> base = releve.toJson();
    // collect diagnostic gaz answers from SharedPreferences and asset
    final diagnostic = await collectDiagnosticGaz();
    base['diagnostic_gaz'] = diagnostic;
    final jsonContent = jsonEncode(base);
    await file.writeAsString(jsonContent, flush: true);
    return file;
  }

  static Future<Map<String, dynamic>> collectDiagnosticGaz() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> out = {};
    try {
      final q = await ReglementationQuestions.loadFromAsset();
      for (final section in q.sections) {
        final List<Map<String, dynamic>> qs = [];
        for (final quest in section.questions) {
          final id = quest.id;
          final val = prefs.getString(id) ?? '';
          final obs = prefs.getString('${id}_obs') ?? '';
          qs.add({
            'id': id,
            'text': quest.text,
            'value': val,
            'observation': obs,
            'severity': quest.severity,
          });
        }
        out[section.id] = {
          'titre': section.titre,
          'questions': qs,
        };
      }
    } catch (e) {
      // If asset load fails, return empty map
    }
    return out;
  }
}
