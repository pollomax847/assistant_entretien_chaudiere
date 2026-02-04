import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/chantier.dart';

class StorageService {
  static const String _chantiersFileName = 'chantiers.json';

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_chantiersFileName';
  }

  Future<List<Chantier>> loadChantiers() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        return jsonList.map((json) => Chantier.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erreur lors du chargement des chantiers: $e');
    }
    return [];
  }

  Future<void> saveChantiers(List<Chantier> chantiers) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      final jsonList = chantiers.map((chantier) => chantier.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Erreur lors de la sauvegarde des chantiers: $e');
    }
  }
}
