// Énumérations pour le Relevé Technique
// Reprises de releve_technique_model_complet.dart et modules existants

// Types d'équipement principal
enum TypeReleve {
  chaudiere,
  pac,
  clim,
  radiateur,
}

// Énergies
enum TypeEnergie {
  gpl,
  gn, // Gaz naturel
  fioul,
  electricite,
  granules,
  bois,
}

// Types ECS
enum TypeEcs {
  instantanee,
  ballonSepare,
  microAccumulation,
  mixte,
  integreChaudiere,
}

// Types évacuation
enum TypeEvacuation {
  conduitFumee,
  ventouse,
  vmc,
  cheminee,
  poujouletType,
  shunt,
  non, // Pas d'évacuation
}

// Types maisons
enum TypeHabitation {
  appartement,
  pavillon,
  maison,
  immeuble,
}

// Types combustible gaz
enum TypeCombustibleGaz {
  gpl,
  gn,
  biogaz,
}

// Type vase expansion
enum TypeVaseExpansion {
  fermee,
  ouverte,
  fermeeAir,
}

// Types filtres
enum TypeFiltre {
  sanitaire,
  magnetique,
  sediment,
  polyphosphate,
}

// Types distribution
enum TypeDistribution {
  radiateurs,
  plancherChauffant,
  chauffageAir,
  radiateurEtParquet,
}

// Type VMC
enum TypeVmc {
  simple,
  simpleHygroregulable,
  double,
  doubleHygroregulable,
  hygroregulable,
  echangeur,
}

// Conformité globale
enum ConformiteGlobale {
  conforme,
  nonConforme,
  aVestir,
  irregulairement,
}

// Niveau de diagnostic
enum NiveauDiagnostic {
  basique,
  complet,
  approfondi,
  expert,
}

// Extensions pour convertir en string
extension TypeReleveExt on TypeReleve {
  String get displayName {
    switch (this) {
      case TypeReleve.chaudiere:
        return 'Chaudière';
      case TypeReleve.pac:
        return 'Pompe à chaleur';
      case TypeReleve.clim:
        return 'Climatisation';
      case TypeReleve.radiateur:
        return 'Radiateur';
    }
  }
}

extension TypeEnergieExt on TypeEnergie {
  String get displayName {
    switch (this) {
      case TypeEnergie.gpl:
        return 'GPL';
      case TypeEnergie.gn:
        return 'Gaz naturel';
      case TypeEnergie.fioul:
        return 'Fioul';
      case TypeEnergie.electricite:
        return 'Électricité';
      case TypeEnergie.granules:
        return 'Granulés';
      case TypeEnergie.bois:
        return 'Bois';
    }
  }
}

extension TypeEcsExt on TypeEcs {
  String get displayName {
    switch (this) {
      case TypeEcs.instantanee:
        return 'Instantanée';
      case TypeEcs.ballonSepare:
        return 'Ballon séparé';
      case TypeEcs.microAccumulation:
        return 'Micro-accumulation';
      case TypeEcs.mixte:
        return 'Mixte';
      case TypeEcs.integreChaudiere:
        return 'Intégrée chaudière';
    }
  }
}

extension TypeEvacuationExt on TypeEvacuation {
  String get displayName {
    switch (this) {
      case TypeEvacuation.conduitFumee:
        return 'Conduit de fumée';
      case TypeEvacuation.ventouse:
        return 'Ventouse';
      case TypeEvacuation.vmc:
        return 'VMC';
      case TypeEvacuation.cheminee:
        return 'Cheminée';
      case TypeEvacuation.poujouletType:
        return 'Poujoulet';
      case TypeEvacuation.shunt:
        return 'Shunt';
      case TypeEvacuation.non:
        return 'Aucune';
    }
  }
}

extension TypeHabitationExt on TypeHabitation {
  String get displayName {
    switch (this) {
      case TypeHabitation.appartement:
        return 'Appartement';
      case TypeHabitation.pavillon:
        return 'Pavillon';
      case TypeHabitation.maison:
        return 'Maison';
      case TypeHabitation.immeuble:
        return 'Immeuble';
    }
  }
}

extension TypeVmcExt on TypeVmc {
  String get displayName {
    switch (this) {
      case TypeVmc.simple:
        return 'Simple flux';
      case TypeVmc.simpleHygroregulable:
        return 'Simple flux hygroréglable';
      case TypeVmc.double:
        return 'Double flux';
      case TypeVmc.doubleHygroregulable:
        return 'Double flux hygroréglable';
      case TypeVmc.hygroregulable:
        return 'Hygroréglable';
      case TypeVmc.echangeur:
        return 'Échangeur';
    }
  }
}

extension ConformiteGlobaleExt on ConformiteGlobale {
  String get displayName {
    switch (this) {
      case ConformiteGlobale.conforme:
        return 'Conforme';
      case ConformiteGlobale.nonConforme:
        return 'Non conforme';
      case ConformiteGlobale.aVestir:
        return 'À vérifier';
      case ConformiteGlobale.irregulairement:
        return 'Irrégulièrement';
    }
  }

  bool get isCompliant {
    return this == ConformiteGlobale.conforme;
  }
}
