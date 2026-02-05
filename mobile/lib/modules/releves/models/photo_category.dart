import 'package:flutter/material.dart';

/// Modèle pour une catégorie de photo
class PhotoCategory {
  final String id;
  final String label;
  final String description;
  final IconData? icon;

  PhotoCategory({
    required this.id,
    required this.label,
    required this.description,
    this.icon,
  });
}

/// Définition des catégories de photos par type de relevé
class PhotoCategoriesByType {
  static List<PhotoCategory> forChaudiere() => [
    PhotoCategory(
      id: 'plaque_raccordement',
      label: 'Plaque de Raccordement',
      description: 'Tuyauterie, vannes, connexions',
      icon: Icons.plumbing,
    ),
    PhotoCategory(
      id: 'etiquette_energetique',
      label: 'Étiquette Énergétique',
      description: 'Classe énergétique, puissance, modèle',
      icon: Icons.energy_savings_leaf,
    ),
    PhotoCategory(
      id: 'compteur_gaz',
      label: 'Compteur Gaz (PCE)',
      description: 'Numéro PCE, compteur, débit',
      icon: Icons.speed,
    ),
    PhotoCategory(
      id: 'vue_exterieure',
      label: 'Vue Extérieure',
      description: 'Façade de la maison',
      icon: Icons.house,
    ),
    PhotoCategory(
      id: 'evacuation_fumees',
      label: 'Système Évacuation Fumées',
      description: 'Conduit, ventouse, conformité DTU 24.1',
      icon: Icons.air,
    ),
    PhotoCategory(
      id: 'vase_expansion',
      label: 'Vase Expansion + Manomètre',
      description: 'Pression circuit, état vase',
      icon: Icons.thermostat,
    ),
    PhotoCategory(
      id: 'vue_eloignee',
      label: 'Vue Éloignée',
      description: 'Contexte général de l\'installation',
      icon: Icons.image_search,
    ),
  ];

  static List<PhotoCategory> forPAC() => [
    PhotoCategory(
      id: 'tgbt',
      label: 'TGBT (Principal)',
      description: 'Tableau électrique principal',
      icon: Icons.electrical_services,
    ),
    PhotoCategory(
      id: 'etiquette_energetique',
      label: 'Étiquette Énergétique PAC',
      description: 'COP, SCOP, puissance nominale',
      icon: Icons.energy_savings_leaf,
    ),
    PhotoCategory(
      id: 'tgbt_second',
      label: 'TGBT (2e Copie)',
      description: 'Extension du tableau ou disjoncteurs supplémentaires',
      icon: Icons.dashboard,
    ),
    PhotoCategory(
      id: 'ballon_tampon',
      label: 'Ballon Tampon/Découplage',
      description: 'Volume, raccordements, isolation',
      icon: Icons.water_drop,
    ),
    PhotoCategory(
      id: 'groupe_exterieur',
      label: 'Emplacement Groupe Extérieur',
      description: 'Cuve et espace de stockage PAC',
      icon: Icons.apartment,
    ),
    PhotoCategory(
      id: 'liaisons_frigo',
      label: 'Liaisons Frigorifiques',
      description: 'Isolation, étanchéité, traversée mur',
      icon: Icons.cable,
    ),
    PhotoCategory(
      id: 'groupe_interieur',
      label: 'Emplacement Groupe Intérieur',
      description: 'UI à remplacer par PAC',
      icon: Icons.hvac,
    ),
    PhotoCategory(
      id: 'disjoncteur_dedie',
      label: 'Disjoncteur Dédié PAC',
      description: 'Protection différentielle NFC 15-100',
      icon: Icons.toggle_on,
    ),
  ];

  static List<PhotoCategory> forClim() => [
    PhotoCategory(
      id: 'groupe_exterieur',
      label: 'Emplacement Groupe Extérieur',
      description: 'Installation unité externe',
      icon: Icons.cloud,
    ),
    PhotoCategory(
      id: 'etiquette_energetique',
      label: 'Étiquette Énergétique Split',
      description: 'EER, SEER, puissance frigorifique',
      icon: Icons.energy_savings_leaf,
    ),
    PhotoCategory(
      id: 'tgbt',
      label: 'TGBT (Tableau Électrique)',
      description: 'Tableau général basse tension & compteur',
      icon: Icons.electrical_services,
    ),
    PhotoCategory(
      id: 'percage_mural',
      label: 'Point de Perçage Mural',
      description: 'Étanchéité traversée, manchon, pente',
      icon: Icons.handyman,
    ),
    PhotoCategory(
      id: 'evacuation_condensats',
      label: 'Évacuation Condensats',
      description: 'Pente, siphon, raccordement',
      icon: Icons.water,
    ),
    PhotoCategory(
      id: 'groupe_interieur',
      label: 'Emplacement Groupe Intérieur',
      description: 'Unité intérieure dans la maison',
      icon: Icons.home_work,
    ),
    PhotoCategory(
      id: 'telecommande',
      label: 'Télécommande + Réglages',
      description: 'Mode, consignes, programmation',
      icon: Icons.settings_remote,
    ),
    PhotoCategory(
      id: 'alternative',
      label: 'Groupe Extérieur (Angle Alt.)',
      description: 'Vue alternative du groupe extérieur',
      icon: Icons.collections,
    ),
  ];
}
