import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/chantier.dart';

// Provider pour la liste des chantiers
final chantiersProvider = StateNotifierProvider<ChantiersNotifier, List<Chantier>>((ref) {
  return ChantiersNotifier();
});

class ChantiersNotifier extends StateNotifier<List<Chantier>> {
  ChantiersNotifier() : super([]) {
    _chargerChantiers();
  }

  // Fichier de sauvegarde
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/chantiers.json';
  }

  // Charger les chantiers depuis le fichier JSON
  Future<void> _chargerChantiers() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        final chantiers = jsonList.map((json) => Chantier.fromJson(json)).toList();
        state = chantiers;
      }
    } catch (e) {
      // En cas d'erreur, on garde la liste vide
      debugPrint('Erreur lors du chargement des chantiers: $e');
    }
  }

  // Sauvegarder les chantiers dans le fichier JSON
  Future<void> _sauvegarderChantiers() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      final jsonList = state.map((chantier) => chantier.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des chantiers: $e');
    }
  }

  // Ajouter un nouveau chantier
  void ajouterChantier(Chantier chantier) {
    state = [...state, chantier];
    _sauvegarderChantiers();
  }

  // Supprimer un chantier
  void supprimerChantier(String id) {
    state = state.where((chantier) => chantier.id != id).toList();
    _sauvegarderChantiers();
  }

  // Mettre à jour un chantier
  void mettreAJourChantier(Chantier chantierMisAJour) {
    state = state.map((chantier) =>
        chantier.id == chantierMisAJour.id ? chantierMisAJour : chantier
    ).toList();
    _sauvegarderChantiers();
  }

  // Obtenir un chantier par ID
  Chantier? getChantierParId(String id) {
    try {
      return state.firstWhere((chantier) => chantier.id == id);
    } catch (_) {
      return null;
    }
  }

  // Obtenir la liste des chantiers triés par date de création (plus récent en premier)
  List<Chantier> getChantiersTries() {
    final chantiersTries = List<Chantier>.from(state);
    chantiersTries.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
    return chantiersTries;
  }
}