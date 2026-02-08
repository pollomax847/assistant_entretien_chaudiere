// models/PhotoCategories.dart (externe)
class PhotoCategory {
  final String id;
  final String nom;
  final String description;
  final String pourquoi;
  final String utilisation;

  PhotoCategory({
    required this.id,
    required this.nom,
    required this.description,
    required this.pourquoi,
    required this.utilisation,
  });
}

class PhotoCategories {
  static final List<PhotoCategory> categories = [
    PhotoCategory(
      id: 'equipement_existant',
      nom: 'Équipement existant',
      description: 'Vue complète de l\'équipement (chaudière, PAC, clim)',
      pourquoi: 'Vérifier l\'état, l\'emplacement et l\'installation actuelle',
      utilisation: 'Comparer avec le nouvel équipement',
    ),
    PhotoCategory(
      id: 'raccordements',
      nom: 'Raccordements',
      description: 'Vue des tuyaux, câbles électriques, raccordements gaz',
      pourquoi: 'Vérifier la compatibilité avec la future installation',
      utilisation: 'Adapter les raccordements au nouvel équipement',
    ),
    PhotoCategory(
      id: 'emplacement_futur',
      nom: 'Emplacement du futur équipement',
      description: 'Zone prévue pour la nouvelle installation',
      pourquoi: 'Vérifier l\'espace disponible, prévoir d\'éventuels travaux',
      utilisation: 'Valider la faisabilité technique',
    ),
    PhotoCategory(
      id: 'tableau_electrique',
      nom: 'Tableau électrique',
      description: 'Vue du tableau électrique (TGBT)',
      pourquoi: 'Vérifier la conformité, les protections, l\'alimentation',
      utilisation:
          'S\'assurer que le tableau est adapté à la puissance du nouvel équipement',
    ),
    PhotoCategory(
      id: 'groupe_exterieur',
      nom: 'Groupe extérieur',
      description: 'Emplacement prévu du groupe extérieur',
      pourquoi:
          'Vérifier les dégagements, l\'accessibilité, la stabilité du support',
      utilisation: 'Installer correctement le groupe extérieur',
    ),
    PhotoCategory(
      id: 'evacuation',
      nom: 'Évacuation des condensats / fumées',
      description:
          'Sortie de l\'évacuation actuelle (cheminée, ventouse, condensats)',
      pourquoi:
          'Vérifier le respect des normes et la possibilité de réutiliser l\'installation',
      utilisation: 'S\'assurer d\'un bon rejet des condensats ou des fumées',
    ),
    PhotoCategory(
      id: 'isolation',
      nom: 'Isolation & menuiserie',
      description: 'Murs, fenêtres, combles isolés si possible',
      pourquoi: 'Évaluer la performance thermique du logement',
      utilisation: 'Adapter le dimensionnement du nouvel équipement',
    ),
    PhotoCategory(
      id: 'distance_unites',
      nom: 'Distance entre unités',
      description: 'Vue entre l\'unité intérieure et extérieure',
      pourquoi: 'Vérifier le raccordement frigorifique et électrique',
      utilisation:
          'Déterminer la longueur des liaisons frigorifiques et électriques',
    ),
  ];

  static PhotoCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
