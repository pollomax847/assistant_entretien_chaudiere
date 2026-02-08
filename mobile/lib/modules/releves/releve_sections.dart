import 'type_releve.dart';

Map<String, List<String>> getSectionsForType(TypeReleve type) {
  final common = {
    'Informations générales': [
      'Numéro de relevé',
      'Date',
      'Entreprise',
      'Technicien',
      'Adresse',
    ],
    'Client': [
      'Nom',
      'Prénom',
      'Adresse client',
      'Téléphone',
      'Email',
    ],
  };

  switch (type) {
    case TypeReleve.chaudiere:
      return {
        ...common,
        'Chaudière existante': [
          'Marque',
          'Modèle',
          'Puissance (W)',
          'Année',
          'N° de série',
        ],
        'Mesures & Conduits': [
          'Température fumées',
          'CO2 (%)',
          'O2 (%)',
          'CO (ppm)',
          'NOx (mg/kWh)',
          'Rendement (%)',
        ],
        'Souhaits et Préconisations': [
          'Type souhaité',
          'Marque souhaitée',
          'Modèle souhaité',
          'Financement souhaité',
        ],
      };
    case TypeReleve.pac:
      return {
        ...common,
        'Pompe à chaleur': [
          'Puissance frigorifique',
          'Marque',
          'Modèle',
          'Année',
        ],
        'Dimensionnement': [
          'Pertes totales',
          'Puissance recommandée',
        ],
      };
    case TypeReleve.clim:
      return {
        ...common,
        'Climatisation': [
          'Puissance frigorifique',
          'État des filtres',
          'Recommandations',
        ],
      };
  }
}
