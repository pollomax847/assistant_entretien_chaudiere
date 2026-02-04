import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../modules/releves/releve_technique_model_complet.dart';

class ExportService {
  static String genererContenuTXT(ReleveTechnique releve, TypeReleve type) {
    final buffer = StringBuffer();

    // En-tête du document
    buffer.writeln('RELEVE TECHNIQUE');
    buffer.writeln('================');
    buffer.writeln();

    // Informations générales
    buffer.writeln('INFORMATIONS GENERALES');
    buffer.writeln('----------------------');
    buffer.writeln('Nom du relevé: ${releve.releveNom ?? ''}');
    buffer.writeln('Technicien: ${releve.technicienNom ?? ''}');
    buffer.writeln('Matricule: ${releve.technicienMatricule ?? ''}');
    buffer.writeln('Adresse d\'installation: ${releve.adresseInstallation ?? ''}');
    buffer.writeln('Type d\'équipement: ${releve.typeEquipement ?? ''}');
    buffer.writeln('RT lié à un devis: ${releve.rtLieADevis == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Informations client
    buffer.writeln('CLIENT');
    buffer.writeln('------');
    buffer.writeln('Numéro client: ${releve.clientNumber ?? ''}');
    buffer.writeln('Nom: ${releve.clientName ?? ''}');
    buffer.writeln('Email: ${releve.clientEmail ?? ''}');
    buffer.writeln('Téléphone fixe: ${releve.clientPhone ?? ''}');
    buffer.writeln('Téléphone mobile: ${releve.clientPhoneMobile ?? ''}');
    buffer.writeln('Adresse de facturation: ${releve.chantierAddress ?? ''}');
    buffer.writeln();

    // Environnement
    buffer.writeln('ENVIRONNEMENT');
    buffer.writeln('-------------');
    buffer.writeln('Appartement: ${releve.appartement == true ? 'Oui' : 'Non'}');
    buffer.writeln('Pavillon: ${releve.pavillon == true ? 'Oui' : 'Non'}');
    buffer.writeln('Surface: ${releve.surface ?? ''} m²');
    buffer.writeln('Nombre d\'occupants: ${releve.occupants ?? ''}');
    buffer.writeln('Année de construction: ${releve.anneeConstruction ?? ''}');
    buffer.writeln('Pièces: ${releve.pieces ?? ''}');
    buffer.writeln('Repérage amiante établi: ${releve.reperageAmiante == true ? 'Oui' : 'Non'}');
    buffer.writeln('Accord copropriété: ${releve.accordCopropriete == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Équipement en place
    buffer.writeln('EQUIPEMENT EN PLACE');
    buffer.writeln('-------------------');
    buffer.writeln('Marque: ${releve.equipementMarque ?? ''}');
    buffer.writeln('Modèle: ${releve.modeleEquipement ?? ''}');
    buffer.writeln('Année: ${releve.equipementAnnee ?? ''}');
    buffer.writeln('Énergie:');
    if (releve.gn == true) buffer.writeln('  - Gaz naturel');
    if (releve.gpl == true) buffer.writeln('  - GPL');
    if (releve.fioul == true) buffer.writeln('  - Fioul');
    buffer.writeln('Puissance: ${releve.puissanceWatts ?? ''} W');
    buffer.writeln('Largeur: ${releve.largeurCm ?? ''} cm');
    buffer.writeln('Chauffage seul: ${releve.chauffageSeul == true ? 'Oui' : 'Non'}');
    buffer.writeln('Mixte instantanée: ${releve.mixteInstantanee == true ? 'Oui' : 'Non'}');
    buffer.writeln('Avec ballon: ${releve.avecBallon == true ? 'Oui' : 'Non'}');
    if (releve.avecBallon == true) {
      buffer.writeln('Litres ballon: ${releve.litresBallon ?? ''} L');
      buffer.writeln('Hauteur ballon: ${releve.hauteurBallon ?? ''} cm');
      buffer.writeln('Profondeur ballon: ${releve.profondeurBallon ?? ''} cm');
    }
    buffer.writeln('Radiateur: ${releve.radiateur == true ? 'Oui' : 'Non'}');
    buffer.writeln('Tuyauterie: ${releve.tuyauterie ?? ''}');
    buffer.writeln('Plancher chauffant: ${releve.plancherChauffant == true ? 'Oui' : 'Non'}');
    buffer.writeln('Tuyaux derrière chaudière: ${releve.tuyauxDerriereChaudiere == true ? 'Oui' : 'Non'}');
    buffer.writeln('Tuyaux côté chaudière: ${releve.tuyauxCoteChaudiere == true ? 'Oui' : 'Non'}');
    buffer.writeln('Raccordement évacuation eaux usées: ${releve.raccordementEvacuationEauxUsees == true ? 'Oui' : 'Non'}');
    buffer.writeln('Évacuation eaux usées à modifier: ${releve.evacuationEauxUseesAModifier == true ? 'Oui' : 'Non'}');
    buffer.writeln('Type raccordement eaux usées: ${releve.typeRaccordementEauxUsees ?? ''}');
    buffer.writeln('Diamètre raccordement eaux usées: ${releve.diametreRaccordementEauxUsees ?? ''} mm');
    buffer.writeln('Longueur raccordement eaux usées: ${releve.longueurRaccordementEauxUsees ?? ''} m');
    buffer.writeln('Besoin pompe relevage: ${releve.besoinPompeRelevage == true ? 'Oui' : 'Non'}');
    buffer.writeln('Nouvelle chaudière même endroit: ${releve.nouvelleChaudiereMemeEndroit == true ? 'Oui' : 'Non'}');
    buffer.writeln('Distance nouvelle chaudière: ${releve.distanceNouvelleChaudiere ?? ''} m');
    buffer.writeln('Nouvel emplacement appareil: ${releve.nouvelEmplacementAppareil ?? ''}');
    buffer.writeln('Tuyaux d\'arrivée:');
    buffer.writeln('  1er: ${releve.premierTuyauArrivee ?? ''}');
    buffer.writeln('  2e: ${releve.deuxiemeTuyauArrivee ?? ''}');
    buffer.writeln('  3e: ${releve.troisiemeTuyauArrivee ?? ''}');
    buffer.writeln('  4e: ${releve.quatriemeTuyauArrivee ?? ''}');
    buffer.writeln('  5e: ${releve.cinquiemeTuyauArrivee ?? ''}');
    buffer.writeln('Électricité: ${releve.electricite ?? ''}');
    buffer.writeln('Gaz: ${releve.gaz ?? ''}');
    buffer.writeln();

    // Souhait du client
    buffer.writeln('SOUHAIT DU CLIENT');
    buffer.writeln('-----------------');
    buffer.writeln('Offre de financement souhaitée: ${releve.offreFinancementSouhaitee == true ? 'Oui' : 'Non'}');
    buffer.writeln('Marque souhaitée: ${releve.marqueSouhait ?? ''}');
    buffer.writeln('Modèle souhaité: ${releve.modeleSouhait ?? ''}');
    buffer.writeln();

    // Type d'appareil souhaité
    buffer.writeln('TYPE D\'APPAREIL SOUHAITE');
    buffer.writeln('------------------------');
    buffer.writeln('Chaudière: ${releve.typeChaudiere == true ? 'Oui' : 'Non'}');
    buffer.writeln('VMC: ${releve.typeVmc == true ? 'Oui' : 'Non'}');
    buffer.writeln('ECS: ${releve.typeEsc == true ? 'Oui' : 'Non'}');
    buffer.writeln('Adoucisseur: ${releve.typeAdoucisseur == true ? 'Oui' : 'Non'}');
    buffer.writeln('Radiateur: ${releve.typeRadiateur == true ? 'Oui' : 'Non'}');
    buffer.writeln('PAC air-air: ${releve.typePacAirAir == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Énergie souhaitée
    buffer.writeln('ENERGIE SOUHAITEE');
    buffer.writeln('-----------------');
    buffer.writeln('GPL: ${releve.energieGpl == true ? 'Oui' : 'Non'}');
    buffer.writeln('FOD: ${releve.energieFod == true ? 'Oui' : 'Non'}');
    buffer.writeln('GN: ${releve.energieGn == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Fonction souhaitée
    buffer.writeln('FONCTION SOUHAITEE');
    buffer.writeln('------------------');
    buffer.writeln('Micro accumulateur: ${releve.fonctionMicroAccu == true ? 'Oui' : 'Non'}');
    buffer.writeln('Accumulateur: ${releve.fonctionAccu == true ? 'Oui' : 'Non'}');
    buffer.writeln('ECS instantanée: ${releve.fonctionEcsInstantanee == true ? 'Oui' : 'Non'}');
    buffer.writeln('Chauffage seul: ${releve.fonctionChauffageSeul == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ballon séparé: ${releve.fonctionBallonSepare == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Évacuation
    buffer.writeln('EVACUATION');
    buffer.writeln('----------');
    buffer.writeln('Conduit de fumée: ${releve.conduitFumee == true ? 'Oui' : 'Non'}');
    buffer.writeln('Conduit shunt: ${releve.conduitShunt == true ? 'Oui' : 'Non'}');
    buffer.writeln('Conduit VMC: ${releve.conduitVmc == true ? 'Oui' : 'Non'}');
    buffer.writeln('VMC: ${releve.vmc == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ventouse verticale: ${releve.ventouseVerticale == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ventouse horizontale: ${releve.ventouseHorizontale == true ? 'Oui' : 'Non'}');
    buffer.writeln('Shunt: ${releve.shunt == true ? 'Oui' : 'Non'}');
    buffer.writeln('Rigide:');
    buffer.writeln('  Conduit fumée: ${releve.conduitFumeeRigide == true ? 'Oui' : 'Non'}');
    buffer.writeln('  Conduit shunt: ${releve.conduitShuntRigide == true ? 'Oui' : 'Non'}');
    buffer.writeln('  Conduit VMC: ${releve.conduitVmcRigide == true ? 'Oui' : 'Non'}');
    buffer.writeln('Diamètres:');
    buffer.writeln('  Conduit fumée: ${releve.diametreConduitFumee ?? ''} mm');
    buffer.writeln('  Tubage conduit fumée: ${releve.diametreTubageConduitFumee ?? ''} mm');
    buffer.writeln('  Conduit shunt: ${releve.diametreConduitShunt ?? ''} mm');
    buffer.writeln('  Conduit VMC: ${releve.diametreConduitVmc ?? ''} mm');
    buffer.writeln('  Bouche VMC gaz: ${releve.diametreBoucheVmcGaz ?? ''} mm');
    buffer.writeln('  Bouchon gaz VMC: ${releve.diametreBouchonGazVmc ?? ''} mm');
    buffer.writeln('Longueurs:');
    buffer.writeln('  Conduit fumée: ${releve.longueurConduitFumee ?? ''} m');
    buffer.writeln('  Tubage conduit fumée: ${releve.longueurTubageConduitFumee ?? ''} m');
    buffer.writeln('  Conduit shunt: ${releve.longueurConduitShunt ?? ''} m');
    buffer.writeln('  Conduit VMC: ${releve.longueurConduitVmc ?? ''} m');
    buffer.writeln('Nombre de coudes:');
    buffer.writeln('  Conduit fumée: ${releve.nombreCoudesConduitFumee ?? ''}');
    buffer.writeln('  Conduit shunt: ${releve.nombreCoudesConduitShunt ?? ''}');
    buffer.writeln('  Conduit VMC: ${releve.nombreCoudesConduitVmc ?? ''}');
    buffer.writeln();

    // Description évacuation
    buffer.writeln('DESCRIPTION EVACUATION');
    buffer.writeln('----------------------');
    buffer.writeln('Nature: ${releve.natureEvacuation ?? ''}');
    buffer.writeln('Couleur: ${releve.couleur ?? ''}');
    buffer.writeln('Angle: ${releve.angle ?? ''}');
    buffer.writeln('Épaisseur: ${releve.epaisseurCm ?? ''} cm');
    buffer.writeln('Longueur: ${releve.longueurEvacuation ?? ''} m');
    buffer.writeln('Débit: ${releve.debitM3h ?? ''} m³/h');
    buffer.writeln('Diamètre ventouse: ${releve.diametreVentouse ?? ''} mm');
    buffer.writeln('Diamètre sortie toiture: ${releve.diametreSortieToiture ?? ''} mm');
    buffer.writeln('Hauteur sortie toiture: ${releve.hauteurSortieToiture ?? ''} m');
    buffer.writeln('Nombre coudes 90°: ${releve.nombreCoudes90 ?? ''}');
    buffer.writeln('Nombre coudes 45°: ${releve.nombreCoudes45 ?? ''}');
    buffer.writeln('Sortie cheminée: ${releve.sortieCheminee == true ? 'Oui' : 'Non'}');
    buffer.writeln('Sortie toiture: ${releve.sortieToiture == true ? 'Oui' : 'Non'}');
    buffer.writeln('Mur: ${releve.mur == true ? 'Oui' : 'Non'}');
    buffer.writeln('Plafond: ${releve.plafond == true ? 'Oui' : 'Non'}');
    buffer.writeln('Tubage: ${releve.tubage == true ? 'Oui' : 'Non'}');
    buffer.writeln('Longueur tubage: ${releve.longueurTubage ?? ''} m');
    buffer.writeln('Bouchon gaz: ${releve.bouchonGaz == true ? 'Oui' : 'Non'}');
    buffer.writeln('Tuyau purge: ${releve.tuyauPurge == true ? 'Oui' : 'Non'}');
    buffer.writeln('Carottage: ${releve.carottage == true ? 'Oui' : 'Non'}');
    buffer.writeln('Utilisation conduit sortie air: ${releve.utilisationConduitSortieAir == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Conformité
    buffer.writeln('CONFORMITE');
    buffer.writeln('----------');
    buffer.writeln('Compteur à plus de 20m entrée logement: ${releve.compteurPlus20m == true ? 'Oui' : 'Non'}');
    buffer.writeln('Compteur gaz à mi-palier entrée logement: ${releve.compteurGazMiPalier == true ? 'Oui' : 'Non'}');
    buffer.writeln('Organe de coupure gaz entrée logement: ${releve.organeCoupureGaz == true ? 'Oui' : 'Non'}');
    buffer.writeln('Volume supérieur à 15m³: ${releve.volumeSuperieur15m3 == true ? 'Oui' : 'Non'}');
    buffer.writeln('Amenée d\'air: ${releve.ameneeAir == true ? 'Oui' : 'Non'}');
    buffer.writeln('Alimentée par une ligne séparée: ${releve.alimenteeLigneSeparee == true ? 'Oui' : 'Non'}');
    buffer.writeln('Robinet sapin: ${releve.robinetSapin == true ? 'Oui' : 'Non'}');
    buffer.writeln('Extracteur motorisé dans pièce: ${releve.extracteurMotorise == true ? 'Oui' : 'Non'}');
    buffer.writeln('Bouche VMC sanitaire: ${releve.boucheVmcSanitaire == true ? 'Oui' : 'Non'}');
    buffer.writeln('Bouche VMC gaz: ${releve.boucheVmcGaz == true ? 'Oui' : 'Non'}');
    buffer.writeln('Foyer ouvert: ${releve.foyerOuvert == true ? 'Oui' : 'Non'}');
    buffer.writeln('Inférieur à 3 coudes: ${releve.inferieur3Coudes == true ? 'Oui' : 'Non'}');
    buffer.writeln('Prise électrique: ${releve.priseElectrique == true ? 'Oui' : 'Non'}');
    buffer.writeln('Test non rotation: ${releve.testNonRotation == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ouvrant de 0,40m²: ${releve.ouvrant040m2 == true ? 'Oui' : 'Non'}');
    buffer.writeln('Sortie d\'air: ${releve.sortieAir == true ? 'Oui' : 'Non'}');
    buffer.writeln('Présence de la terre: ${releve.presenceTerre == true ? 'Oui' : 'Non'}');
    buffer.writeln('Flexible gaz périmé: ${releve.flexibleGazPerime == true ? 'Oui' : 'Non'}');
    buffer.writeln('Hotte à raccorder: ${releve.hotteRaccorder == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ramonage: ${releve.ramonage == true ? 'Oui' : 'Non'}');
    buffer.writeln('Dépasse fétage supérieur à 0,40m: ${releve.depasseFetage040m == true ? 'Oui' : 'Non'}');
    buffer.writeln('Relais DSC: ${releve.relaisDsc == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Sécurité
    buffer.writeln('SECURITE');
    buffer.writeln('--------');
    buffer.writeln('Toit pentu: ${releve.toitPentu == true ? 'Oui' : 'Non'}');
    buffer.writeln('Comble: ${releve.comble == true ? 'Oui' : 'Non'}');
    buffer.writeln('Travaux hauteur: ${releve.travauxHauteur == true ? 'Oui' : 'Non'}');
    buffer.writeln('Accessibilité complexe: ${releve.accessibiliteComplexe == true ? 'Oui' : 'Non'}');
    buffer.writeln('Commentaire accessibilité: ${releve.commentaireAccessibilite ?? ''}');
    buffer.writeln();

    // Accessoires
    buffer.writeln('ACCESSOIRES');
    buffer.writeln('-----------');
    buffer.writeln('Désembouage: ${releve.desembouage ?? ''}');
    buffer.writeln('Filtres sanitaires: ${releve.filtresSanitaires == true ? 'Oui' : 'Non'}');
    buffer.writeln('Filtres: ${releve.filtres == true ? 'Oui' : 'Non'}');
    buffer.writeln('Type filtres: ${releve.typeFiltres ?? ''}');
    buffer.writeln('Pré filtre: ${releve.preFiltre == true ? 'Oui' : 'Non'}');
    buffer.writeln('Sonde: ${releve.sonde == true ? 'Oui' : 'Non'}');
    buffer.writeln('DSP: ${releve.dsp == true ? 'Oui' : 'Non'}');
    buffer.writeln('DAAF: ${releve.daaf == true ? 'Oui' : 'Non'}');
    buffer.writeln('ROAI: ${releve.roai == true ? 'Oui' : 'Non'}');
    buffer.writeln('Vase sup: ${releve.vaseSup == true ? 'Oui' : 'Non'}');
    buffer.writeln('Crépine: ${releve.crepine == true ? 'Oui' : 'Non'}');
    buffer.writeln('CO: ${releve.co == true ? 'Oui' : 'Non'}');
    buffer.writeln('Gaz: ${releve.gazAccessoire == true ? 'Oui' : 'Non'}');
    buffer.writeln('Flexible gaz: ${releve.flexibleGaz == true ? 'Oui' : 'Non'}');
    buffer.writeln('Réducteur pression: ${releve.reducteurPression == true ? 'Oui' : 'Non'}');
    buffer.writeln('Nombre purgeur: ${releve.nombrePurgeur ?? ''}');
    buffer.writeln('Ventouse arrière: ${releve.ventouseArriere == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ventouse par-dessus: ${releve.ventouseParDessus == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ventouse latérale: ${releve.ventouseLaterale == true ? 'Oui' : 'Non'}');
    buffer.writeln('Ventouse centrale: ${releve.ventouseCentrale == true ? 'Oui' : 'Non'}');
    buffer.writeln();

    // Commentaires
    buffer.writeln('COMMENTAIRES');
    buffer.writeln('------------');
    buffer.writeln('Commentaire: ${releve.commentaire ?? ''}');
    buffer.writeln('Informations magasinier: ${releve.informationsMagasinier ?? ''}');
    buffer.writeln('Travaux à la charge du client: ${releve.travauxChargeClient ?? ''}');
    buffer.writeln('Température circuit primaire: ${releve.temperatureCircuitPrimaire ?? ''}');
    buffer.writeln('Commentaire particularité chantier: ${releve.commentaireParticulariteChantier ?? ''}');
    buffer.writeln();

    // Annexes
    buffer.writeln('ANNEXES');
    buffer.writeln('-------');
    if (releve.photos != null && releve.photos!.isNotEmpty) {
      buffer.writeln('Photos:');
      for (var photo in releve.photos!) {
        buffer.writeln('  - $photo');
      }
    } else {
      buffer.writeln('Photos: Aucune');
    }
    buffer.writeln();

    // Pied de page
    buffer.writeln('FIN DU RELEVE TECHNIQUE');
    buffer.writeln('=======================');
    buffer.writeln('Généré le: ${DateTime.now().toString()}');

    return buffer.toString();
  }

  static Future<void> exporterTXT(ReleveTechnique releve, TypeReleve type) async {
    try {
      final contenu = genererContenuTXT(releve, type);

      // Obtenir le répertoire des documents
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'releve_technique_${type.name}_$timestamp.txt';
      final file = File('${directory.path}/$fileName');

      // Écrire le contenu dans le fichier
      await file.writeAsString(contenu);

      // Partager le fichier
      await Share.shareXFiles([XFile(file.path)], text: 'Relevé technique exporté');
    } catch (e) {
      throw Exception('Erreur lors de l\'export: $e');
    }
  }
}