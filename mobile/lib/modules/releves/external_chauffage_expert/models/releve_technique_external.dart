// models/releve_technique_external.dart (externe)
import 'dart:io';

enum RTType { pac, clim, chaudiere }

class ReleveTechniqueLegacy {
  final String clientNumber;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String mobile;

  // Données techniques
  final double livingArea;
  final double ceilingHeight;
  final double heatedVolume;
  final String constructionYear;
  final String constructionType;
  final String insulation;

  // Environnement
  final String climateZone;
  final double altitude;
  final double baseExtTemp;
  final double desiredIntTemp;
  final String windExposure;

  // Équipement
  final String brand;
  final String model;
  final double power;
  final String emitterType;
  final String regulation;

  // Installation électrique
  final String powerSupplyType;
  final String cableSection;
  final String protection;
  final String circuitBreaker;

  // Souhaits client
  final String wishes;

  // Configuration installation
  final String outdoorUnitLocation;
  final double unitDistance;
  final double heightDifference;
  final String connectionType;

  // Dimensionnement (PAC)
  final double totalLosses;
  final double gCoefficient;
  final double recommendedPower;

  // Accessoires (Chaudière)
  final String ductType;
  final String diameter;
  final double height;
  final String lining;
  final String ventouse;

  // Photos
  final List<File> photos;

  // Résultats du compteur
  final String startIndex;
  final String endIndex;
  final String consumption;
  final String period;
  final String interventionDate;
  final String interventionType;
  final String technician;
  final int duration;
  final String observations;
  final String actions;

  // Dimensionnement ballon tampon
  final double ballonVolume;
  final double ballonHauteur;
  final double ballonDiametre;
  final String ballonIsolation;
  final String ballonType;
  final String ballonRegulation;

  // Dimensionnement circulateur
  final double circulateurDebit;
  final double circulateurHMT;
  final double circulateurPuissance;
  final String circulateurType;
  final String circulateurRegulation;
  final String circulateurMarque;

  // Réglementations gaz
  final String reglementationType;
  final String reglementationVersion;
  final String reglementationConformite;
  final String reglementationObservations;
  final String reglementationPrescriptions;

  final DateTime dateCreation;
  final DateTime? dateModification;

  ReleveTechniqueLegacy({
    required this.clientNumber,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.mobile,
    required this.livingArea,
    required this.ceilingHeight,
    required this.heatedVolume,
    required this.constructionYear,
    required this.constructionType,
    required this.insulation,
    required this.climateZone,
    required this.altitude,
    required this.baseExtTemp,
    required this.desiredIntTemp,
    required this.windExposure,
    required this.brand,
    required this.model,
    required this.power,
    required this.emitterType,
    required this.regulation,
    required this.powerSupplyType,
    required this.cableSection,
    required this.protection,
    required this.circuitBreaker,
    required this.wishes,
    required this.outdoorUnitLocation,
    required this.unitDistance,
    required this.heightDifference,
    required this.connectionType,
    required this.totalLosses,
    required this.gCoefficient,
    required this.recommendedPower,
    required this.ductType,
    required this.diameter,
    required this.height,
    required this.lining,
    required this.ventouse,
    required this.photos,
    required this.startIndex,
    required this.endIndex,
    required this.consumption,
    required this.period,
    required this.interventionDate,
    required this.interventionType,
    required this.technician,
    required this.duration,
    required this.observations,
    required this.actions,
    required this.dateCreation,
    this.dateModification,
    required this.ballonVolume,
    required this.ballonHauteur,
    required this.ballonDiametre,
    required this.ballonIsolation,
    required this.ballonType,
    required this.ballonRegulation,
    required this.circulateurDebit,
    required this.circulateurHMT,
    required this.circulateurPuissance,
    required this.circulateurType,
    required this.circulateurRegulation,
    required this.circulateurMarque,
    required this.reglementationType,
    required this.reglementationVersion,
    required this.reglementationConformite,
    required this.reglementationObservations,
    required this.reglementationPrescriptions,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientNumber': clientNumber,
      'name': name,
      'address': address,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'livingArea': livingArea,
      'ceilingHeight': ceilingHeight,
      'heatedVolume': heatedVolume,
      'constructionYear': constructionYear,
      'constructionType': constructionType,
      'insulation': insulation,
      'climateZone': climateZone,
      'altitude': altitude,
      'baseExtTemp': baseExtTemp,
      'desiredIntTemp': desiredIntTemp,
      'windExposure': windExposure,
      'brand': brand,
      'model': model,
      'power': power,
      'emitterType': emitterType,
      'regulation': regulation,
      'powerSupplyType': powerSupplyType,
      'cableSection': cableSection,
      'protection': protection,
      'circuitBreaker': circuitBreaker,
      'wishes': wishes,
      'outdoorUnitLocation': outdoorUnitLocation,
      'unitDistance': unitDistance,
      'heightDifference': heightDifference,
      'connectionType': connectionType,
      'totalLosses': totalLosses,
      'gCoefficient': gCoefficient,
      'recommendedPower': recommendedPower,
      'ductType': ductType,
      'diameter': diameter,
      'height': height,
      'lining': lining,
      'ventouse': ventouse,
      'photos': photos.map((photo) => photo.path).toList(),
      'startIndex': startIndex,
      'endIndex': endIndex,
      'consumption': consumption,
      'period': period,
      'interventionDate': interventionDate,
      'interventionType': interventionType,
      'technician': technician,
      'duration': duration,
      'observations': observations,
      'actions': actions,
      'dateCreation': dateCreation.toIso8601String(),
      'dateModification': dateModification?.toIso8601String(),
      'ballonVolume': ballonVolume,
      'ballonHauteur': ballonHauteur,
      'ballonDiametre': ballonDiametre,
      'ballonIsolation': ballonIsolation,
      'ballonType': ballonType,
      'ballonRegulation': ballonRegulation,
      'circulateurDebit': circulateurDebit,
      'circulateurHMT': circulateurHMT,
      'circulateurPuissance': circulateurPuissance,
      'circulateurType': circulateurType,
      'circulateurRegulation': circulateurRegulation,
      'circulateurMarque': circulateurMarque,
      'reglementationType': reglementationType,
      'reglementationVersion': reglementationVersion,
      'reglementationConformite': reglementationConformite,
      'reglementationObservations': reglementationObservations,
      'reglementationPrescriptions': reglementationPrescriptions,
    };
  }

  factory ReleveTechniqueLegacy.fromMap(Map<String, dynamic> map) {
    return ReleveTechniqueLegacy(
      clientNumber: map['clientNumber'],
      name: map['name'],
      address: map['address'],
      email: map['email'],
      phone: map['phone'],
      mobile: map['mobile'],
      livingArea: (map['livingArea'] ?? 0).toDouble(),
      ceilingHeight: (map['ceilingHeight'] ?? 0).toDouble(),
      heatedVolume: (map['heatedVolume'] ?? 0).toDouble(),
      constructionYear: map['constructionYear'],
      constructionType: map['constructionType'],
      insulation: map['insulation'],
      climateZone: map['climateZone'],
      altitude: (map['altitude'] ?? 0).toDouble(),
      baseExtTemp: (map['baseExtTemp'] ?? 0).toDouble(),
      desiredIntTemp: (map['desiredIntTemp'] ?? 0).toDouble(),
      windExposure: map['windExposure'],
      brand: map['brand'],
      model: map['model'],
      power: (map['power'] ?? 0).toDouble(),
      emitterType: map['emitterType'],
      regulation: map['regulation'],
      powerSupplyType: map['powerSupplyType'],
      cableSection: map['cableSection'],
      protection: map['protection'],
      circuitBreaker: map['circuitBreaker'],
      wishes: map['wishes'],
      outdoorUnitLocation: map['outdoorUnitLocation'],
      unitDistance: (map['unitDistance'] ?? 0).toDouble(),
      heightDifference: (map['heightDifference'] ?? 0).toDouble(),
      connectionType: map['connectionType'],
      totalLosses: (map['totalLosses'] ?? 0).toDouble(),
      gCoefficient: (map['gCoefficient'] ?? 0).toDouble(),
      recommendedPower: (map['recommendedPower'] ?? 0).toDouble(),
      ductType: map['ductType'],
      diameter: map['diameter'],
      height: (map['height'] ?? 0).toDouble(),
      lining: map['lining'],
      ventouse: map['ventouse'],
      photos: (map['photos'] as List<dynamic>?)
              ?.map((p) => File(p as String))
              .toList() ??
          [],
      startIndex: map['startIndex'],
      endIndex: map['endIndex'],
      consumption: map['consumption'],
      period: map['period'],
      interventionDate: map['interventionDate'],
      interventionType: map['interventionType'],
      technician: map['technician'],
      duration: map['duration'] ?? 0,
      observations: map['observations'],
      actions: map['actions'],
      dateCreation: DateTime.parse(map['dateCreation']),
      dateModification: map['dateModification'] != null
          ? DateTime.parse(map['dateModification'])
          : null,
      ballonVolume: (map['ballonVolume'] ?? 0).toDouble(),
      ballonHauteur: (map['ballonHauteur'] ?? 0).toDouble(),
      ballonDiametre: (map['ballonDiametre'] ?? 0).toDouble(),
      ballonIsolation: map['ballonIsolation'],
      ballonType: map['ballonType'],
      ballonRegulation: map['ballonRegulation'],
      circulateurDebit: (map['circulateurDebit'] ?? 0).toDouble(),
      circulateurHMT: (map['circulateurHMT'] ?? 0).toDouble(),
      circulateurPuissance: (map['circulateurPuissance'] ?? 0).toDouble(),
      circulateurType: map['circulateurType'],
      circulateurRegulation: map['circulateurRegulation'],
      circulateurMarque: map['circulateurMarque'],
      reglementationType: map['reglementationType'],
      reglementationVersion: map['reglementationVersion'],
      reglementationConformite: map['reglementationConformite'],
      reglementationObservations: map['reglementationObservations'],
      reglementationPrescriptions: map['reglementationPrescriptions'],
    );
  }

  Map<String, dynamic> toClientData() {
    return {
      'clientNumber': clientNumber,
      'name': name,
      'address': address,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'startIndex': startIndex,
      'endIndex': endIndex,
      'consumption': consumption,
      'period': period,
      'interventionDate': interventionDate,
      'interventionType': interventionType,
      'technician': technician,
      'duration': duration,
      'observations': observations,
      'actions': actions,
      'wishes': wishes,
    };
  }

  Map<String, dynamic> toTechnicalData() {
    return {
      'livingArea': livingArea,
      'ceilingHeight': ceilingHeight,
      'heatedVolume': heatedVolume,
      'constructionYear': constructionYear,
      'constructionType': constructionType,
      'insulation': insulation,
      'climateZone': climateZone,
      'altitude': altitude,
      'baseExtTemp': baseExtTemp,
      'desiredIntTemp': desiredIntTemp,
      'windExposure': windExposure,
      'totalLosses': totalLosses,
      'gCoefficient': gCoefficient,
      'recommendedPower': recommendedPower,
      'ballonVolume': ballonVolume,
      'ballonHauteur': ballonHauteur,
      'ballonDiametre': ballonDiametre,
      'ballonIsolation': ballonIsolation,
      'ballonType': ballonType,
      'ballonRegulation': ballonRegulation,
      'circulateurDebit': circulateurDebit,
      'circulateurHMT': circulateurHMT,
      'circulateurPuissance': circulateurPuissance,
      'circulateurType': circulateurType,
      'circulateurRegulation': circulateurRegulation,
      'circulateurMarque': circulateurMarque,
      'reglementationType': reglementationType,
      'reglementationVersion': reglementationVersion,
      'reglementationConformite': reglementationConformite,
      'reglementationObservations': reglementationObservations,
      'reglementationPrescriptions': reglementationPrescriptions,
    };
  }
}
