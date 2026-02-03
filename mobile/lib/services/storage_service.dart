import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';
import '../models/chantier.dart';

class StorageService {
  static const String _fileName = 'chantiers.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  // Charger tous les chantiers au démarrage
  Future<List<Chantier>> loadChantiers() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Chantier.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Erreur lors du chargement des chantiers: $e');
      return [];
    }
  }

  // Sauvegarder la liste complète
  Future<void> saveChantiers(List<Chantier> chantiers) async {
    try {
      final file = await _localFile;
      final json = jsonEncode(chantiers.map((c) => c.toJson()).toList());
      await file.writeAsString(json);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde: $e');
    }
  }
}