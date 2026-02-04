import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'radiateur.dart';

class Chantier {
  final String id; // UUID
  String nom; // ex. "Maison Dupont - Paris"
  String? adresse;
  String? descriptionChaudiere; // ex. "Chaudière gaz Viessmann 2020"
  DateTime dateCreation;
  List<Radiateur> radiateurs;

  Chantier({
    required this.id,
    required this.nom,
    this.adresse,
    this.descriptionChaudiere,
    DateTime? dateCreation,
    List<Radiateur>? radiateurs,
  })  : dateCreation = dateCreation ?? DateTime.now(),
        radiateurs = radiateurs ?? [];

  // Méthode pour créer un nouveau chantier vide
  factory Chantier.nouveau(String nom) {
    return Chantier(
      id: const Uuid().v4(),
      nom: nom,
    );
  }

  // Tri des radiateurs par ordre (proche → loin)
  void trierRadiateurs() {
    radiateurs.sort((a, b) => a.ordre.compareTo(b.ordre));
  }

  // Ajout d'un radiateur avec ordre auto-incrémenté
  void ajouterRadiateur(Radiateur rad) {
    rad.ordre = radiateurs.length; // 0,1,2... → suggéré proche à loin
    radiateurs.add(rad);
    trierRadiateurs();
  }

  // Pour sauvegarde JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'descriptionChaudiere': descriptionChaudiere,
      'dateCreation': dateCreation.toIso8601String(),
      'radiateurs': radiateurs.map((r) => r.toJson()).toList(),
    };
  }

  factory Chantier.fromJson(Map<String, dynamic> json) {
    final radiateursList = (json['radiateurs'] as List<dynamic>)
        .map((r) => Radiateur.fromJson(r as Map<String, dynamic>))
        .toList();

    return Chantier(
      id: json['id'] as String,
      nom: json['nom'] as String,
      adresse: json['adresse'] as String?,
      descriptionChaudiere: json['descriptionChaudiere'] as String?,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      radiateurs: radiateursList,
    );
  }
}
