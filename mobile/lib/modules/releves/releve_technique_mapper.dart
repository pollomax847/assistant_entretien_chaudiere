import 'models/releve_technique.dart';
import 'models/sections/client_section.dart';
import 'models/sections/chaudiere_section.dart';
import 'models/sections/ecs_section.dart';
import 'models/sections/tirage_section.dart';
import 'models/sections/evacuation_section.dart';
import 'models/sections/conformite_section.dart';
import 'models/sections/accessoires_section.dart';
import 'models/sections/securite_section.dart';
import 'models/sections/puissance_section.dart';
import 'models/sections/vmc_section.dart';

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is String) return int.tryParse(v);
  return null;
}

/// Convertit un JSON "plat" (comme dans le dépôt ChauffageExpert) vers
/// le modèle structuré `ReleveTechnique` utilisé ici.
ReleveTechnique mapFlatToStructured(Map<String, dynamic> flat) {
  final clientJson = {
    'numero': flat['clientNumber'],
    'nom': flat['clientName'],
    'email': flat['clientEmail'],
    'telephone': flat['clientPhone'],
    'telephonePortable': flat['clientPhoneMobile'],
    'adresseChantier': flat['chantierAddress'],
    'nomTechnicien': flat['technicienNom'] ?? flat['technicien'],
    'matriculeTechnicien': flat['technicienMatricule'],
    'dateVisite': flat['dateCreation'],
    'estAppartement': flat['appartement'],
    'surface': flat['surface'],
    'nombreOccupants': flat['occupants'],
    'anneeConstruction': _toInt(flat['anneeConstruction']),
    'reperageAmiante': flat['reperageAmiante'],
    'accordCopropriete': flat['accordCopropriete'],
    'estPavillon': flat['pavillon'],
    'nombrePieces': flat['pieces'],
  };

  final chaudiereJson = {
    'marque': flat['equipementMarque'] ?? flat['marqueSouhait'],
    'modele': flat['modeleEquipement'] ?? flat['modeleSouhait'],
    'anneeInstallation': _toInt(flat['equipementAnnee']),
    'energie': flat['gpl'] == true
        ? 'GPL'
        : (flat['gn'] == true ? 'GN' : (flat['fioul'] == true ? 'Fioul' : null)),
    'puissance': flat['puissanceWatts'],
    'chauffageSeul': flat['chauffageSeul'] ?? flat['chauffageSeul'],
    'avecEcs': flat['avecBallon'],
    'typeBallonEcs': flat['typeBallonEcs'] ?? (flat['avecBallon'] == true ? 'Ballon' : null),
    'volumeBallon': flat['litresBallon'],
    'marqueBallon': flat['marqueBallon'],
    'hauteurBallon': flat['hauteurBallon'],
    'profondeurBallon': flat['profondeurBallon'],
    'radiateur': flat['radiateur'],
    'plancherChauffant': flat['plancherChauffant'],
    'typeTuyauterie': flat['tuyauterie'],
    'tuyauxDerriereChaudiere': flat['tuyauxDerriereChaudiere'],
    'typeRaccordementEvacuation': flat['typeRaccordementEauxUsees'],
    'diametre': flat['diametre'],
    'besoinPompeRelevage': flat['besoinPompeRelevage'],
    'typeAlimentationElectrique': flat['electricite'],
    'commentaire': flat['commentaireParticulariteChantier'] ?? flat['commentaire'],
  };

  final conformiteJson = {
    'compteurPlus20m': flat['compteurPlus20m'],
    'organeCoupure': flat['organeCoupureGaz'] ?? flat['organeCoupure'],
    'alimenteeLigneSeparee': flat['alimenteeLigneSeparee'],
    'priseTerragePresente': flat['presenceTerre'] ?? flat['priseElectrique'],
    'robinetArretGeneralPresent': flat['robinetSapin'] ?? flat['robinetSapin'],
    'flexibleGazNonPerime': !(flat['flexibleGazPerime'] == true),
    'testNonRotationOk': flat['testNonRotation'],
    'ameneeAirPresente': flat['ameneeAir'],
    'extracteurMotorisePresent': flat['extracteurMotorise'],
    'boucheVmcSanitairePresente': flat['boucheVmcSanitaire'],
    'foyerOuvert': flat['foyerOuvert'],
    'clapet': flat['clapet'],
    'conformeReglementationGaz': flat['reglementationConformite'],
    'raison': flat['reglementationObservations'],
    'commentaire': flat['commentaire'],
  };

  final evacuationJson = {
    'longueurEvacuation': flat['longueurEvacuation'],
    'natureEvacuation': flat['natureEvacuation'],
    'diametre': flat['diametreVentouse'] ?? flat['diametreVentouse'],
    'nombreCoudes90': flat['nombreCoudes90'],
    'nombreCoudes45': flat['nombreCoudes45'],
    'sortieToiture': flat['sortieToiture'],
    'hauteurSortieToiture': flat['hauteurSortieToiture'],
    'tubage': flat['tubage'],
  };

  final accessoiresJson = {
    'desembouage': flat['desembouage'],
    'filtresSanitaires': flat['filtresSanitaires'],
    'sonde': flat['sonde'],
    'dsp': flat['dsp'],
    'nombrePurgeur': flat['nombrePurgeur'],
    'preFiltre': flat['preFiltre'],
    'reducteurPression': flat['reducteurPression'],
    'daaf': flat['daaf'],
    'ventouseArriere': flat['ventouseArriere'],
    'ventouseParDessus': flat['ventouseParDessus'],
    'filtres': flat['filtres'],
    'typeFiltres': flat['typeFiltres'],
    'flexibleGaz': flat['flexibleGaz'],
    'roai': flat['roai'],
    'vaseSup': flat['vaseSup'],
    'crepine': flat['crepine'],
    'co': flat['co'],
    'gazAccessoire': flat['gazAccessoire'],
    'ventouseLaterale': flat['ventouseLaterale'],
    'ventouseCentrale': flat['ventouseCentrale'],
  };

  final securiteJson = {
    'toitPentu': flat['toitPentu'],
    'comble': flat['comble'],
    'commentaireAccessibilite': flat['commentaireAccessibilite'],
    'travauxHauteur': flat['travauxHauteur'],
    'accessibiliteComplexe': flat['accessibiliteComplexe'],
  };

  final puissanceJson = {
    'puissanceChaudiere': flat['puissanceWatts'],
    'radiateurs': flat['radiateur'],
    'plancherChauffant': flat['plancherChauffant'],
    'temperatureDepart': flat['temperatureDepart'],
    'temperatureRetour': flat['temperatureRetour'],
  };

  // Construire les sections à partir des JSONs
  final clientSection = ClientSection.fromJson(clientJson);
  final chaudiereSection = ChaudiereSection.fromJson(chaudiereJson);
  final conformiteSection = ConformiteSection.fromJson(conformiteJson);
  final evacuationSection = EvacuationSection.fromJson(evacuationJson);
  final accessoiresSection = AccessoiresSection.fromJson(accessoiresJson);
  final securiteSection = SecuriteSection.fromJson(securiteJson);
  final puissanceSection = PuissanceSection.fromJson(puissanceJson);

  // Autres sections si présentes
  final ecsSection = flat['ecs'] != null
      ? EcsSection.fromJson(flat['ecs'] as Map<String, dynamic>)
      : null;
  final tirageSection = flat['tirage'] != null
      ? TirageSection.fromJson(flat['tirage'] as Map<String, dynamic>)
      : null;
  final vmcSection = flat['vmc'] != null
      ? VmcSection.fromJson(flat['vmc'] as Map<String, dynamic>)
      : null;

  return ReleveTechnique(
    id: flat['id'] as String?,
    dateCreation: flat['dateCreation'] != null
        ? DateTime.tryParse(flat['dateCreation'].toString()) ?? DateTime.now()
        : DateTime.now(),
    dateModification: flat['dateModification'] != null
        ? DateTime.tryParse(flat['dateModification'].toString())
        : null,
    dateVisite: flat['dateVisite'] != null
        ? DateTime.tryParse(flat['dateVisite'].toString())
        : null,
    typeEquipement: flat['typeEquipement'] != null
        ? (flat['typeEquipement'].toString().toLowerCase().contains('pac')
            ? TypeReleve.pac
            : (flat['typeEquipement'].toString().toLowerCase().contains('clim')
                ? TypeReleve.clim
                : TypeReleve.chaudiere))
        : null,
    client: clientSection,
    chaudiere: chaudiereSection,
    ecs: ecsSection,
    tirage: tirageSection,
    evacuation: evacuationSection,
    conformite: conformiteSection,
    accessoires: accessoiresSection,
    securite: securiteSection,
    puissance: puissanceSection,
    vmc: vmcSection,
    photos: (flat['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    pieces: (flat['pieces'] as List<dynamic>?)?.map((e) => e as String).toList(),
    commentaireGlobal: flat['commentaire'] as String?,
    donneesLegacy: flat,
  );
}

/// Convertit un `ReleveTechnique` structuré vers une Map plate compatible
/// avec l'ancien format (utile pour export / compatibilité).
Map<String, dynamic> mapStructuredToFlat(ReleveTechnique rt) {
  final flat = <String, dynamic>{};
  flat['id'] = rt.id;
  flat['dateCreation'] = rt.dateCreation.toIso8601String();
  flat['dateModification'] = rt.dateModification?.toIso8601String();
  flat['dateVisite'] = rt.dateVisite?.toIso8601String();
  flat['typeEquipement'] = rt.typeEquipement?.toString().split('.').last;
  flat['client'] = rt.client?.toJson();
  flat['chaudiere'] = rt.chaudiere?.toJson();
  flat['ecs'] = rt.ecs?.toJson();
  flat['tirage'] = rt.tirage?.toJson();
  flat['evacuation'] = rt.evacuation?.toJson();
  flat['conformite'] = rt.conformite?.toJson();
  flat['accessoires'] = rt.accessoires?.toJson();
  flat['securite'] = rt.securite?.toJson();
  flat['puissance'] = rt.puissance?.toJson();
  flat['vmc'] = rt.vmc?.toJson();
  flat['photos'] = rt.photos;
  flat['pieces'] = rt.pieces;
  flat['commentaire'] = rt.commentaireGlobal;
  // Garder aussi legacy si existant
  if (rt.donneesLegacy != null) {
    flat['donneesLegacy'] = rt.donneesLegacy;
  }
  return flat;
}
