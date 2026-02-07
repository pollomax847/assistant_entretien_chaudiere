import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/releve_technique.dart';

/// Service d'export pour ReleveTechnique
/// Gère l'export en TXT et PDF
class RelevelExportService {
  /// Exporte un relevé en format texte
  static Future<String> exportToTxt(ReleveTechnique releve) async {
    final buffer = StringBuffer();
    
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln('RELEVÉ TECHNIQUE');
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln();
    
    // En-tête
    buffer.writeln('ID: ${releve.id}');
    buffer.writeln('Date de visite: ${releve.dateVisite}');
    buffer.writeln('Créé: ${releve.dateCreation}');
    buffer.writeln('Modifié: ${releve.dateModification}');
    buffer.writeln('Type équipement: ${releve.typeEquipement}');
    buffer.writeln();
    
    // Client
    if (releve.client != null) {
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln('CLIENT');
      buffer.writeln('───────────────────────────────────────────────────────');
      final client = releve.client!;
      if (client.numero != null) buffer.writeln('Numéro: ${client.numero}');
      if (client.nom != null) buffer.writeln('Nom: ${client.nom}');
      if (client.email != null) buffer.writeln('Email: ${client.email}');
      if (client.telephone != null) buffer.writeln('Tél: ${client.telephone}');
      if (client.telephonePortable != null) buffer.writeln('Portable: ${client.telephonePortable}');
      if (client.adresseChantier != null) buffer.writeln('Adresse: ${client.adresseChantier}');
      if (client.nomTechnicien != null) buffer.writeln('Technicien: ${client.nomTechnicien}');
      if (client.matriculeTechnicien != null) buffer.writeln('Matricule: ${client.matriculeTechnicien}');
      if (client.surface != null) buffer.writeln('Surface: ${client.surface} m²');
      if (client.nombreOccupants != null) buffer.writeln('Occupants: ${client.nombreOccupants}');
      if (client.anneeConstruction != null) buffer.writeln('Année construction: ${client.anneeConstruction}');
      buffer.writeln();
    }
    
    // Chaudière
    if (releve.chaudiere != null) {
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln('CHAUDIÈRE');
      buffer.writeln('───────────────────────────────────────────────────────');
      final chaudiere = releve.chaudiere!;
      if (chaudiere.marque != null) buffer.writeln('Marque: ${chaudiere.marque}');
      if (chaudiere.modele != null) buffer.writeln('Modèle: ${chaudiere.modele}');
      if (chaudiere.anneeInstallation != null) buffer.writeln('Année: ${chaudiere.anneeInstallation}');
      if (chaudiere.energie != null) buffer.writeln('Énergie: ${chaudiere.energie}');
      if (chaudiere.puissance != null) buffer.writeln('Puissance: ${chaudiere.puissance}');
      if (chaudiere.volumeBallon != null) buffer.writeln('Volume ballon: ${chaudiere.volumeBallon} L');
      buffer.writeln();
    }
    
    // ECS
    if (releve.ecs != null) {
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln('ECS');
      buffer.writeln('───────────────────────────────────────────────────────');
      final ecs = releve.ecs!;
      if (ecs.typeEcs != null) buffer.writeln('Type: ${ecs.typeEcs}');
      if (ecs.debitSimultaneL != null) buffer.writeln('Débit: ${ecs.debitSimultaneL} L/min');
      if (ecs.temperatureChaudeConsigne != null) buffer.writeln('Température consigne: ${ecs.temperatureChaudeConsigne}°C');
      buffer.writeln();
    }
    
    // Tirage
    if (releve.tirage != null) {
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln('TIRAGE');
      buffer.writeln('───────────────────────────────────────────────────────');
      final tirage = releve.tirage!;
      if (tirage.tirage != null) buffer.writeln('Tirage: ${tirage.tirage} hPa');
      if (tirage.co != null) buffer.writeln('CO: ${tirage.co} ppm');
      if (tirage.co2 != null) buffer.writeln('CO₂: ${tirage.co2}%');
      if (tirage.o2 != null) buffer.writeln('O₂: ${tirage.o2}%');
      buffer.writeln('Tirage conforme: ${tirage.tirageConforme == true ? "✓" : "✗"}');
      buffer.writeln('CO conforme: ${tirage.coConforme == true ? "✓" : "✗"}');
      buffer.writeln();
    }
    
    // Conformité
    if (releve.conformite != null) {
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln('CONFORMITÉ');
      buffer.writeln('───────────────────────────────────────────────────────');
      final conf = releve.conformite!;
      buffer.writeln('Conforme réglementation gaz: ${conf.conformeReglementationGaz == true ? "✓" : "✗"}');
      if (conf.raison != null) buffer.writeln('Raison: ${conf.raison}');
      buffer.writeln();
    }
    
    // Commentaire global
    if (releve.commentaireGlobal != null && releve.commentaireGlobal!.isNotEmpty) {
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln('COMMENTAIRES GÉNÉRAUX');
      buffer.writeln('───────────────────────────────────────────────────────');
      buffer.writeln(releve.commentaireGlobal);
      buffer.writeln();
    }
    
    buffer.writeln('═══════════════════════════════════════════════════════');
    buffer.writeln('Fin du relevé');
    buffer.writeln('═══════════════════════════════════════════════════════');
    
    return buffer.toString();
  }

  /// Sauvegarde le relevé en fichier TXT
  static Future<File?> saveToFile(
    ReleveTechnique releve,
    String filename,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename.txt');
      final content = await exportToTxt(releve);
      return await file.writeAsString(content);
    } catch (e) {
      debugPrint('Erreur sauvegarde fichier: $e');
      return null;
    }
  }

  /// Exporte complètement le relevé avec tous les détails
  static Future<String> exportComplet(ReleveTechnique releve) async {
    return await exportToTxt(releve);
  }

  /// Génère un résumé court du relevé
  static String generateSummary(ReleveTechnique releve) {
    final buffer = StringBuffer();
    
    buffer.writeln('RELEVÉ ${releve.id}');
    buffer.writeln(releve.client?.nom ?? 'Sans nom');
    buffer.writeln(releve.client?.adresseChantier ?? 'Adresse inconnue');
    buffer.writeln('Créé: ${releve.dateCreation.day}/${releve.dateCreation.month}/${releve.dateCreation.year}');
    buffer.writeln('Complétion: ${releve.pourcentageCompletion}%');
    
    return buffer.toString();
  }
}
