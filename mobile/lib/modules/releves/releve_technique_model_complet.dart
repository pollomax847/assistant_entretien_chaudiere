/// Types de relevés techniques disponibles
enum TypeReleve {
  chaudiere,
  pac,
  clim,
}


/// Modèle de données complet pour un relevé technique (chaudière, PAC, clim, etc.)
/// Basé sur l'analyse complète des fichiers rt_chaudiere_complet.txt, rt_pac_complet.txt, rt_clim_complet.txt
class ReleveTechnique {
  // Section 1: Client
  final String? clientNumber;
  final String? clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String? clientPhoneMobile;
  final String? chantierAddress;

  // Section 2: Informations générales
  final String? releveTechniqueName;
  final String? releveNom;
  final bool? rtLieADevis;
  final String? technicienNom;
  final String? technicienMatricule;
  final String? adresseInstallation;
  final String? typeEquipement;

  // Section 3: Environnement
  final bool? appartement;
  final String? surface;
  final String? occupants;
  final String? anneeConstruction;
  final bool? reperageAmiante;
  final bool? accordCopropriete;
  final bool? pavillon;
  final String? pieces;

  // Section 4: Informations équipement en place
  final String? equipementMarque;
  final String? equipementAnnee;
  final bool? chauffageSeul;
  final bool? mixteInstantanee;
  final bool? avecBallon;
  final String? litresBallon;
  final String? hauteurBallon;
  final String? profondeurBallon;
  final bool? radiateur;
  final String? tuyauterie;
  final bool? tuyauxDerriereChaudiere;
  final bool? raccordementEvacuationEauxUsees;
  final bool? evacuationEauxUseesAModifier;
  final String? diametreRaccordementEauxUsees;
  final String? premierTuyauArrivee;
  final String? troisiemeTuyauArrivee;
  final String? cinquiemeTuyauArrivee;
  final bool? nouvelleChaudiereMemeEndroit;
  final String? electricite;
  final String? modeleEquipement;
  final bool? gpl;
  final bool? gn;
  final bool? fioul;
  final String? puissanceWatts;
  final String? largeurCm;
  final bool? plancherChauffant;
  final bool? tuyauxCoteChaudiere;
  final bool? besoinPompeRelevage;
  final String? typeRaccordementEauxUsees;
  final String? longueurRaccordementEauxUsees;
  final String? deuxiemeTuyauArrivee;
  final String? quatriemeTuyauArrivee;
  final String? distanceNouvelleChaudiere;
  final String? nouvelEmplacementAppareil;
  final String? gaz;

  // Section 5: Souhait du client
  final bool? offreFinancementSouhaitee;
  final String? marqueSouhait;
  final String? modeleSouhait;

  // Section 6: Type d'appareil
  final bool? typeChaudiere;
  final bool? typeVmc;
  final bool? typeEsc;
  final bool? typeAdoucisseur;
  final bool? typeRadiateur;
  final bool? typePacAirAir;

  // Section 7: Energie
  final bool? energieGpl;
  final bool? energieFod;
  final bool? energieGn;

  // Section 8: Fonction
  final bool? fonctionMicroAccu;
  final bool? fonctionAccu;
  final bool? fonctionEcsInstantanee;
  final bool? fonctionChauffageSeul;
  final bool? fonctionBallonSepare;

  // Section 9: Evacuation
  final bool? conduitFumee;
  final bool? conduitShunt;
  final bool? conduitVmc;
  final bool? vmc;
  final bool? ventouseVerticale;
  final bool? ventouseHorizontale;
  final String? diametreConduitFumee;
  final String? nombreCoudesConduitFumee;
  final String? longueurTubageConduitFumee;
  final String? longueurConduitShunt;
  final String? diametreConduitVmc;
  final String? nombreCoudesConduitVmc;
  final bool? conduitFumeeRigide;
  final bool? conduitShuntRigide;
  final bool? conduitVmcRigide;
  final bool? shunt;
  final String? diametreBoucheVmcGaz;
  final String? longueurConduitFumee;
  final String? diametreTubageConduitFumee;
  final String? diametreConduitShunt;
  final String? nombreCoudesConduitShunt;
  final String? longueurConduitVmc;
  final String? diametreBouchonGazVmc;

  // Section 10: Conformité (questions Oui/Non)
  final bool? compteurPlus20m;
  final bool? organeCoupureGaz;
  final bool? volumeSuperieur15m3;
  final bool? ameneeAir;
  final bool? alimenteeLigneSeparee;
  final bool? robinetSapin;
  final bool? extracteurMotorise;
  final bool? boucheVmcSanitaire;
  final bool? foyerOuvert;
  final bool? inferieur3Coudes;
  final bool? priseElectrique;
  final bool? compteurGazMiPalier;
  final bool? testNonRotation;
  final bool? ouvrant040m2;
  final bool? sortieAir;
  final bool? presenceTerre;
  final bool? flexibleGazPerime;
  final bool? hotteRaccorder;
  final bool? ramonage;
  final bool? depasseFetage040m;
  final bool? relaisDsc;
  final bool? boucheVmcGaz;

  // Section 11: Description évacuation
  final String? nombreCoudes90;
  final String? longueurEvacuation;
  final String? natureEvacuation;
  final bool? sortieCheminee;
  final bool? mur;
  final bool? utilisationConduitSortieAir;
  final String? diametreSortieToiture;
  final String? couleur;
  final bool? tubage;
  final String? longueurTubage;
  final bool? bouchonGaz;
  final String? nombreCoudes45;
  final String? diametreVentouse;
  final String? epaisseurCm;
  final bool? sortieToiture;
  final bool? plafond;
  final String? hauteurSortieToiture;
  final String? angle;
  final bool? tuyauPurge;
  final String? debitM3h;
  final bool? carottage;

  // Section 12: Sécurité
  final bool? toitPentu;
  final bool? comble;
  final String? commentaireAccessibilite;
  final bool? travauxHauteur;
  final bool? accessibiliteComplexe;

  // Section 13: Accessoires
  final String? desembouage;
  final bool? filtresSanitaires;
  final bool? sonde;
  final bool? dsp;
  final String? nombrePurgeur;
  final bool? preFiltre;
  final bool? reducteurPression;
  final bool? daaf;
  final bool? ventouseArriere;
  final bool? ventouseParDessus;
  final bool? filtres;
  final String? typeFiltres;
  final bool? flexibleGaz;
  final bool? roai;
  final bool? vaseSup;
  final bool? crepine;
  final bool? co;
  final bool? gazAccessoire;
  final bool? ventouseLaterale;
  final bool? ventouseCentrale;

  // Section 14: Commentaires
  final String? commentaire;
  final String? informationsMagasinier;
  final String? travauxChargeClient;
  final String? temperatureCircuitPrimaire;
  final String? commentaireParticulariteChantier;

  // Section 15: Annexes (photos)
  final List<String>? photos; // Liste des chemins vers les photos

  ReleveTechnique({
    // Client
    this.clientNumber,
    this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.clientPhoneMobile,
    this.chantierAddress,

    // Informations générales
    this.releveTechniqueName,
    this.releveNom,
    this.rtLieADevis,
    this.technicienNom,
    this.technicienMatricule,
    this.adresseInstallation,
    this.typeEquipement,

    // Environnement
    this.appartement,
    this.surface,
    this.occupants,
    this.anneeConstruction,
    this.reperageAmiante,
    this.accordCopropriete,
    this.pavillon,
    this.pieces,

    // Équipement en place
    this.equipementMarque,
    this.equipementAnnee,
    this.chauffageSeul,
    this.mixteInstantanee,
    this.avecBallon,
    this.litresBallon,
    this.hauteurBallon,
    this.profondeurBallon,
    this.radiateur,
    this.tuyauterie,
    this.tuyauxDerriereChaudiere,
    this.raccordementEvacuationEauxUsees,
    this.evacuationEauxUseesAModifier,
    this.diametreRaccordementEauxUsees,
    this.premierTuyauArrivee,
    this.troisiemeTuyauArrivee,
    this.cinquiemeTuyauArrivee,
    this.nouvelleChaudiereMemeEndroit,
    this.electricite,
    this.modeleEquipement,
    this.gpl,
    this.gn,
    this.fioul,
    this.puissanceWatts,
    this.largeurCm,
    this.plancherChauffant,
    this.tuyauxCoteChaudiere,
    this.besoinPompeRelevage,
    this.typeRaccordementEauxUsees,
    this.longueurRaccordementEauxUsees,
    this.deuxiemeTuyauArrivee,
    this.quatriemeTuyauArrivee,
    this.distanceNouvelleChaudiere,
    this.nouvelEmplacementAppareil,
    this.gaz,

    // Souhait client
    this.offreFinancementSouhaitee,
    this.marqueSouhait,
    this.modeleSouhait,

    // Type appareil
    this.typeChaudiere,
    this.typeVmc,
    this.typeEsc,
    this.typeAdoucisseur,
    this.typeRadiateur,
    this.typePacAirAir,

    // Energie
    this.energieGpl,
    this.energieFod,
    this.energieGn,

    // Fonction
    this.fonctionMicroAccu,
    this.fonctionAccu,
    this.fonctionEcsInstantanee,
    this.fonctionChauffageSeul,
    this.fonctionBallonSepare,

    // Evacuation
    this.conduitFumee,
    this.conduitShunt,
    this.conduitVmc,
    this.vmc,
    this.ventouseVerticale,
    this.ventouseHorizontale,
    this.diametreConduitFumee,
    this.nombreCoudesConduitFumee,
    this.longueurTubageConduitFumee,
    this.longueurConduitShunt,
    this.diametreConduitVmc,
    this.nombreCoudesConduitVmc,
    this.conduitFumeeRigide,
    this.conduitShuntRigide,
    this.conduitVmcRigide,
    this.shunt,
    this.diametreBoucheVmcGaz,
    this.longueurConduitFumee,
    this.diametreTubageConduitFumee,
    this.diametreConduitShunt,
    this.nombreCoudesConduitShunt,
    this.longueurConduitVmc,
    this.diametreBouchonGazVmc,

    // Conformité
    this.compteurPlus20m,
    this.organeCoupureGaz,
    this.volumeSuperieur15m3,
    this.ameneeAir,
    this.alimenteeLigneSeparee,
    this.robinetSapin,
    this.extracteurMotorise,
    this.boucheVmcSanitaire,
    this.foyerOuvert,
    this.inferieur3Coudes,
    this.priseElectrique,
    this.compteurGazMiPalier,
    this.testNonRotation,
    this.ouvrant040m2,
    this.sortieAir,
    this.presenceTerre,
    this.flexibleGazPerime,
    this.hotteRaccorder,
    this.ramonage,
    this.depasseFetage040m,
    this.relaisDsc,
    this.boucheVmcGaz,

    // Description évacuation
    this.nombreCoudes90,
    this.longueurEvacuation,
    this.natureEvacuation,
    this.sortieCheminee,
    this.mur,
    this.utilisationConduitSortieAir,
    this.diametreSortieToiture,
    this.couleur,
    this.tubage,
    this.longueurTubage,
    this.bouchonGaz,
    this.nombreCoudes45,
    this.diametreVentouse,
    this.epaisseurCm,
    this.sortieToiture,
    this.plafond,
    this.hauteurSortieToiture,
    this.angle,
    this.tuyauPurge,
    this.debitM3h,
    this.carottage,

    // Sécurité
    this.toitPentu,
    this.comble,
    this.commentaireAccessibilite,
    this.travauxHauteur,
    this.accessibiliteComplexe,

    // Accessoires
    this.desembouage,
    this.filtresSanitaires,
    this.sonde,
    this.dsp,
    this.nombrePurgeur,
    this.preFiltre,
    this.reducteurPression,
    this.daaf,
    this.ventouseArriere,
    this.ventouseParDessus,
    this.filtres,
    this.typeFiltres,
    this.flexibleGaz,
    this.roai,
    this.vaseSup,
    this.crepine,
    this.co,
    this.gazAccessoire,
    this.ventouseLaterale,
    this.ventouseCentrale,

    // Commentaires
    this.commentaire,
    this.informationsMagasinier,
    this.travauxChargeClient,
    this.temperatureCircuitPrimaire,
    this.commentaireParticulariteChantier,

    // Annexes
    this.photos,
  });

  // Factory pour créer depuis un Map (ex: JSON)
  factory ReleveTechnique.fromJson(Map<String, dynamic> json) {
    return ReleveTechnique(
      // Client
      clientNumber: json['clientNumber'] as String?,
      clientName: json['clientName'] as String?,
      clientEmail: json['clientEmail'] as String?,
      clientPhone: json['clientPhone'] as String?,
      clientPhoneMobile: json['clientPhoneMobile'] as String?,
      chantierAddress: json['chantierAddress'] as String?,

      // Informations générales
      releveTechniqueName: json['releveTechniqueName'] as String?,
      releveNom: json['releveNom'] as String?,
      rtLieADevis: json['rtLieADevis'] as bool?,
      technicienNom: json['technicienNom'] as String?,
      technicienMatricule: json['technicienMatricule'] as String?,
      adresseInstallation: json['adresseInstallation'] as String?,
      typeEquipement: json['typeEquipement'] as String?,

      // Environnement
      appartement: json['appartement'] as bool?,
      surface: json['surface'] as String?,
      occupants: json['occupants'] as String?,
      anneeConstruction: json['anneeConstruction'] as String?,
      reperageAmiante: json['reperageAmiante'] as bool?,
      accordCopropriete: json['accordCopropriete'] as bool?,
      pavillon: json['pavillon'] as bool?,
      pieces: json['pieces'] as String?,

      // Équipement en place
      equipementMarque: json['equipementMarque'] as String?,
      equipementAnnee: json['equipementAnnee'] as String?,
      chauffageSeul: json['chauffageSeul'] as bool?,
      mixteInstantanee: json['mixteInstantanee'] as bool?,
      avecBallon: json['avecBallon'] as bool?,
      litresBallon: json['litresBallon'] as String?,
      hauteurBallon: json['hauteurBallon'] as String?,
      profondeurBallon: json['profondeurBallon'] as String?,
      radiateur: json['radiateur'] as bool?,
      tuyauterie: json['tuyauterie'] as String?,
      tuyauxDerriereChaudiere: json['tuyauxDerriereChaudiere'] as bool?,
      raccordementEvacuationEauxUsees: json['raccordementEvacuationEauxUsees'] as bool?,
      evacuationEauxUseesAModifier: json['evacuationEauxUseesAModifier'] as bool?,
      diametreRaccordementEauxUsees: json['diametreRaccordementEauxUsees'] as String?,
      premierTuyauArrivee: json['premierTuyauArrivee'] as String?,
      troisiemeTuyauArrivee: json['troisiemeTuyauArrivee'] as String?,
      cinquiemeTuyauArrivee: json['cinquiemeTuyauArrivee'] as String?,
      nouvelleChaudiereMemeEndroit: json['nouvelleChaudiereMemeEndroit'] as bool?,
      electricite: json['electricite'] as String?,
      modeleEquipement: json['modeleEquipement'] as String?,
      gpl: json['gpl'] as bool?,
      gn: json['gn'] as bool?,
      fioul: json['fioul'] as bool?,
      puissanceWatts: json['puissanceWatts'] as String?,
      largeurCm: json['largeurCm'] as String?,
      plancherChauffant: json['plancherChauffant'] as bool?,
      tuyauxCoteChaudiere: json['tuyauxCoteChaudiere'] as bool?,
      besoinPompeRelevage: json['besoinPompeRelevage'] as bool?,
      typeRaccordementEauxUsees: json['typeRaccordementEauxUsees'] as String?,
      longueurRaccordementEauxUsees: json['longueurRaccordementEauxUsees'] as String?,
      deuxiemeTuyauArrivee: json['deuxiemeTuyauArrivee'] as String?,
      quatriemeTuyauArrivee: json['quatriemeTuyauArrivee'] as String?,
      distanceNouvelleChaudiere: json['distanceNouvelleChaudiere'] as String?,
      nouvelEmplacementAppareil: json['nouvelEmplacementAppareil'] as String?,
      gaz: json['gaz'] as String?,

      // Souhait client
      offreFinancementSouhaitee: json['offreFinancementSouhaitee'] as bool?,
      marqueSouhait: json['marqueSouhait'] as String?,
      modeleSouhait: json['modeleSouhait'] as String?,

      // Type appareil
      typeChaudiere: json['typeChaudiere'] as bool?,
      typeVmc: json['typeVmc'] as bool?,
      typeEsc: json['typeEsc'] as bool?,
      typeAdoucisseur: json['typeAdoucisseur'] as bool?,
      typeRadiateur: json['typeRadiateur'] as bool?,
      typePacAirAir: json['typePacAirAir'] as bool?,

      // Energie
      energieGpl: json['energieGpl'] as bool?,
      energieFod: json['energieFod'] as bool?,
      energieGn: json['energieGn'] as bool?,

      // Fonction
      fonctionMicroAccu: json['fonctionMicroAccu'] as bool?,
      fonctionAccu: json['fonctionAccu'] as bool?,
      fonctionEcsInstantanee: json['fonctionEcsInstantanee'] as bool?,
      fonctionChauffageSeul: json['fonctionChauffageSeul'] as bool?,
      fonctionBallonSepare: json['fonctionBallonSepare'] as bool?,

      // Evacuation
      conduitFumee: json['conduitFumee'] as bool?,
      conduitShunt: json['conduitShunt'] as bool?,
      conduitVmc: json['conduitVmc'] as bool?,
      vmc: json['vmc'] as bool?,
      ventouseVerticale: json['ventouseVerticale'] as bool?,
      ventouseHorizontale: json['ventouseHorizontale'] as bool?,
      diametreConduitFumee: json['diametreConduitFumee'] as String?,
      nombreCoudesConduitFumee: json['nombreCoudesConduitFumee'] as String?,
      longueurTubageConduitFumee: json['longueurTubageConduitFumee'] as String?,
      longueurConduitShunt: json['longueurConduitShunt'] as String?,
      diametreConduitVmc: json['diametreConduitVmc'] as String?,
      nombreCoudesConduitVmc: json['nombreCoudesConduitVmc'] as String?,
      conduitFumeeRigide: json['conduitFumeeRigide'] as bool?,
      conduitShuntRigide: json['conduitShuntRigide'] as bool?,
      conduitVmcRigide: json['conduitVmcRigide'] as bool?,
      shunt: json['shunt'] as bool?,
      diametreBoucheVmcGaz: json['diametreBoucheVmcGaz'] as String?,
      longueurConduitFumee: json['longueurConduitFumee'] as String?,
      diametreTubageConduitFumee: json['diametreTubageConduitFumee'] as String?,
      diametreConduitShunt: json['diametreConduitShunt'] as String?,
      nombreCoudesConduitShunt: json['nombreCoudesConduitShunt'] as String?,
      longueurConduitVmc: json['longueurConduitVmc'] as String?,
      diametreBouchonGazVmc: json['diametreBouchonGazVmc'] as String?,

      // Conformité
      compteurPlus20m: json['compteurPlus20m'] as bool?,
      organeCoupureGaz: json['organeCoupureGaz'] as bool?,
      volumeSuperieur15m3: json['volumeSuperieur15m3'] as bool?,
      ameneeAir: json['ameneeAir'] as bool?,
      alimenteeLigneSeparee: json['alimenteeLigneSeparee'] as bool?,
      robinetSapin: json['robinetSapin'] as bool?,
      extracteurMotorise: json['extracteurMotorise'] as bool?,
      boucheVmcSanitaire: json['boucheVmcSanitaire'] as bool?,
      foyerOuvert: json['foyerOuvert'] as bool?,
      inferieur3Coudes: json['inferieur3Coudes'] as bool?,
      priseElectrique: json['priseElectrique'] as bool?,
      compteurGazMiPalier: json['compteurGazMiPalier'] as bool?,
      testNonRotation: json['testNonRotation'] as bool?,
      ouvrant040m2: json['ouvrant040m2'] as bool?,
      sortieAir: json['sortieAir'] as bool?,
      presenceTerre: json['presenceTerre'] as bool?,
      flexibleGazPerime: json['flexibleGazPerime'] as bool?,
      hotteRaccorder: json['hotteRaccorder'] as bool?,
      ramonage: json['ramonage'] as bool?,
      depasseFetage040m: json['depasseFetage040m'] as bool?,
      relaisDsc: json['relaisDsc'] as bool?,
      boucheVmcGaz: json['boucheVmcGaz'] as bool?,

      // Description évacuation
      nombreCoudes90: json['nombreCoudes90'] as String?,
      longueurEvacuation: json['longueurEvacuation'] as String?,
      natureEvacuation: json['natureEvacuation'] as String?,
      sortieCheminee: json['sortieCheminee'] as bool?,
      mur: json['mur'] as bool?,
      utilisationConduitSortieAir: json['utilisationConduitSortieAir'] as bool?,
      diametreSortieToiture: json['diametreSortieToiture'] as String?,
      couleur: json['couleur'] as String?,
      tubage: json['tubage'] as bool?,
      longueurTubage: json['longueurTubage'] as String?,
      bouchonGaz: json['bouchonGaz'] as bool?,
      nombreCoudes45: json['nombreCoudes45'] as String?,
      diametreVentouse: json['diametreVentouse'] as String?,
      epaisseurCm: json['epaisseurCm'] as String?,
      sortieToiture: json['sortieToiture'] as bool?,
      plafond: json['plafond'] as bool?,
      hauteurSortieToiture: json['hauteurSortieToiture'] as String?,
      angle: json['angle'] as String?,
      tuyauPurge: json['tuyauPurge'] as bool?,
      debitM3h: json['debitM3h'] as String?,
      carottage: json['carottage'] as bool?,

      // Sécurité
      toitPentu: json['toitPentu'] as bool?,
      comble: json['comble'] as bool?,
      commentaireAccessibilite: json['commentaireAccessibilite'] as String?,
      travauxHauteur: json['travauxHauteur'] as bool?,
      accessibiliteComplexe: json['accessibiliteComplexe'] as bool?,

      // Accessoires
      desembouage: json['desembouage'] as String?,
      filtresSanitaires: json['filtresSanitaires'] as bool?,
      sonde: json['sonde'] as bool?,
      dsp: json['dsp'] as bool?,
      nombrePurgeur: json['nombrePurgeur'] as String?,
      preFiltre: json['preFiltre'] as bool?,
      reducteurPression: json['reducteurPression'] as bool?,
      daaf: json['daaf'] as bool?,
      ventouseArriere: json['ventouseArriere'] as bool?,
      ventouseParDessus: json['ventouseParDessus'] as bool?,
      filtres: json['filtres'] as bool?,
      typeFiltres: json['typeFiltres'] as String?,
      flexibleGaz: json['flexibleGaz'] as bool?,
      roai: json['roai'] as bool?,
      vaseSup: json['vaseSup'] as bool?,
      crepine: json['crepine'] as bool?,
      co: json['co'] as bool?,
      gazAccessoire: json['gazAccessoire'] as bool?,
      ventouseLaterale: json['ventouseLaterale'] as bool?,
      ventouseCentrale: json['ventouseCentrale'] as bool?,

      // Commentaires
      commentaire: json['commentaire'] as String?,
      informationsMagasinier: json['informationsMagasinier'] as String?,
      travauxChargeClient: json['travauxChargeClient'] as String?,
      temperatureCircuitPrimaire: json['temperatureCircuitPrimaire'] as String?,
      commentaireParticulariteChantier: json['commentaireParticulariteChantier'] as String?,

      // Annexes
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  // Conversion en Map (ex: pour export ou sauvegarde)
  Map<String, dynamic> toJson() {
    return {
      // Client
      'clientNumber': clientNumber,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'clientPhoneMobile': clientPhoneMobile,
      'chantierAddress': chantierAddress,

      // Informations générales
      'releveTechniqueName': releveTechniqueName,
      'releveNom': releveNom,
      'rtLieADevis': rtLieADevis,
      'technicienNom': technicienNom,
      'technicienMatricule': technicienMatricule,
      'adresseInstallation': adresseInstallation,
      'typeEquipement': typeEquipement,

      // Environnement
      'appartement': appartement,
      'surface': surface,
      'occupants': occupants,
      'anneeConstruction': anneeConstruction,
      'reperageAmiante': reperageAmiante,
      'accordCopropriete': accordCopropriete,
      'pavillon': pavillon,
      'pieces': pieces,

      // Équipement en place
      'equipementMarque': equipementMarque,
      'equipementAnnee': equipementAnnee,
      'chauffageSeul': chauffageSeul,
      'mixteInstantanee': mixteInstantanee,
      'avecBallon': avecBallon,
      'litresBallon': litresBallon,
      'hauteurBallon': hauteurBallon,
      'profondeurBallon': profondeurBallon,
      'radiateur': radiateur,
      'tuyauterie': tuyauterie,
      'tuyauxDerriereChaudiere': tuyauxDerriereChaudiere,
      'raccordementEvacuationEauxUsees': raccordementEvacuationEauxUsees,
      'evacuationEauxUseesAModifier': evacuationEauxUseesAModifier,
      'diametreRaccordementEauxUsees': diametreRaccordementEauxUsees,
      'premierTuyauArrivee': premierTuyauArrivee,
      'troisiemeTuyauArrivee': troisiemeTuyauArrivee,
      'cinquiemeTuyauArrivee': cinquiemeTuyauArrivee,
      'nouvelleChaudiereMemeEndroit': nouvelleChaudiereMemeEndroit,
      'electricite': electricite,
      'modeleEquipement': modeleEquipement,
      'gpl': gpl,
      'gn': gn,
      'fioul': fioul,
      'puissanceWatts': puissanceWatts,
      'largeurCm': largeurCm,
      'plancherChauffant': plancherChauffant,
      'tuyauxCoteChaudiere': tuyauxCoteChaudiere,
      'besoinPompeRelevage': besoinPompeRelevage,
      'typeRaccordementEauxUsees': typeRaccordementEauxUsees,
      'longueurRaccordementEauxUsees': longueurRaccordementEauxUsees,
      'deuxiemeTuyauArrivee': deuxiemeTuyauArrivee,
      'quatriemeTuyauArrivee': quatriemeTuyauArrivee,
      'distanceNouvelleChaudiere': distanceNouvelleChaudiere,
      'nouvelEmplacementAppareil': nouvelEmplacementAppareil,
      'gaz': gaz,

      // Souhait client
      'offreFinancementSouhaitee': offreFinancementSouhaitee,
      'marqueSouhait': marqueSouhait,
      'modeleSouhait': modeleSouhait,

      // Type appareil
      'typeChaudiere': typeChaudiere,
      'typeVmc': typeVmc,
      'typeEsc': typeEsc,
      'typeAdoucisseur': typeAdoucisseur,
      'typeRadiateur': typeRadiateur,
      'typePacAirAir': typePacAirAir,

      // Energie
      'energieGpl': energieGpl,
      'energieFod': energieFod,
      'energieGn': energieGn,

      // Fonction
      'fonctionMicroAccu': fonctionMicroAccu,
      'fonctionAccu': fonctionAccu,
      'fonctionEcsInstantanee': fonctionEcsInstantanee,
      'fonctionChauffageSeul': fonctionChauffageSeul,
      'fonctionBallonSepare': fonctionBallonSepare,

      // Evacuation
      'conduitFumee': conduitFumee,
      'conduitShunt': conduitShunt,
      'conduitVmc': conduitVmc,
      'vmc': vmc,
      'ventouseVerticale': ventouseVerticale,
      'ventouseHorizontale': ventouseHorizontale,
      'diametreConduitFumee': diametreConduitFumee,
      'nombreCoudesConduitFumee': nombreCoudesConduitFumee,
      'longueurTubageConduitFumee': longueurTubageConduitFumee,
      'longueurConduitShunt': longueurConduitShunt,
      'diametreConduitVmc': diametreConduitVmc,
      'nombreCoudesConduitVmc': nombreCoudesConduitVmc,
      'conduitFumeeRigide': conduitFumeeRigide,
      'conduitShuntRigide': conduitShuntRigide,
      'conduitVmcRigide': conduitVmcRigide,
      'shunt': shunt,
      'diametreBoucheVmcGaz': diametreBoucheVmcGaz,
      'longueurConduitFumee': longueurConduitFumee,
      'diametreTubageConduitFumee': diametreTubageConduitFumee,
      'diametreConduitShunt': diametreConduitShunt,
      'nombreCoudesConduitShunt': nombreCoudesConduitShunt,
      'longueurConduitVmc': longueurConduitVmc,
      'diametreBouchonGazVmc': diametreBouchonGazVmc,

      // Conformité
      'compteurPlus20m': compteurPlus20m,
      'organeCoupureGaz': organeCoupureGaz,
      'volumeSuperieur15m3': volumeSuperieur15m3,
      'ameneeAir': ameneeAir,
      'alimenteeLigneSeparee': alimenteeLigneSeparee,
      'robinetSapin': robinetSapin,
      'extracteurMotorise': extracteurMotorise,
      'boucheVmcSanitaire': boucheVmcSanitaire,
      'foyerOuvert': foyerOuvert,
      'inferieur3Coudes': inferieur3Coudes,
      'priseElectrique': priseElectrique,
      'compteurGazMiPalier': compteurGazMiPalier,
      'testNonRotation': testNonRotation,
      'ouvrant040m2': ouvrant040m2,
      'sortieAir': sortieAir,
      'presenceTerre': presenceTerre,
      'flexibleGazPerime': flexibleGazPerime,
      'hotteRaccorder': hotteRaccorder,
      'ramonage': ramonage,
      'depasseFetage040m': depasseFetage040m,
      'relaisDsc': relaisDsc,
      'boucheVmcGaz': boucheVmcGaz,

      // Description évacuation
      'nombreCoudes90': nombreCoudes90,
      'longueurEvacuation': longueurEvacuation,
      'natureEvacuation': natureEvacuation,
      'sortieCheminee': sortieCheminee,
      'mur': mur,
      'utilisationConduitSortieAir': utilisationConduitSortieAir,
      'diametreSortieToiture': diametreSortieToiture,
      'couleur': couleur,
      'tubage': tubage,
      'longueurTubage': longueurTubage,
      'bouchonGaz': bouchonGaz,
      'nombreCoudes45': nombreCoudes45,
      'diametreVentouse': diametreVentouse,
      'epaisseurCm': epaisseurCm,
      'sortieToiture': sortieToiture,
      'plafond': plafond,
      'hauteurSortieToiture': hauteurSortieToiture,
      'angle': angle,
      'tuyauPurge': tuyauPurge,
      'debitM3h': debitM3h,
      'carottage': carottage,

      // Sécurité
      'toitPentu': toitPentu,
      'comble': comble,
      'commentaireAccessibilite': commentaireAccessibilite,
      'travauxHauteur': travauxHauteur,
      'accessibiliteComplexe': accessibiliteComplexe,

      // Accessoires
      'desembouage': desembouage,
      'filtresSanitaires': filtresSanitaires,
      'sonde': sonde,
      'dsp': dsp,
      'nombrePurgeur': nombrePurgeur,
      'preFiltre': preFiltre,
      'reducteurPression': reducteurPression,
      'daaf': daaf,
      'ventouseArriere': ventouseArriere,
      'ventouseParDessus': ventouseParDessus,
      'filtres': filtres,
      'typeFiltres': typeFiltres,
      'flexibleGaz': flexibleGaz,
      'roai': roai,
      'vaseSup': vaseSup,
      'crepine': crepine,
      'co': co,
      'gazAccessoire': gazAccessoire,
      'ventouseLaterale': ventouseLaterale,
      'ventouseCentrale': ventouseCentrale,

      // Commentaires
      'commentaire': commentaire,
      'informationsMagasinier': informationsMagasinier,
      'travauxChargeClient': travauxChargeClient,
      'temperatureCircuitPrimaire': temperatureCircuitPrimaire,
      'commentaireParticulariteChantier': commentaireParticulariteChantier,

      // Annexes
      'photos': photos,
    };
  }
}