# Relevé Technique Complet - Documentation

## Vue d'ensemble

Le système de relevé technique complet a été conçu pour correspondre exactement à la structure des fichiers TXT de relevés techniques (rt_chaudiere_complet.txt, rt_pac_complet.txt, rt_clim_complet.txt) fournis par l'utilisateur.

## Structure des 15 sections

Le relevé technique est organisé en 15 sections principales :

1. **Client** - Informations client et adresse
2. **Informations générales** - Métadonnées du relevé
3. **Environnement** - Description du lieu d'installation
4. **Équipement en place** - Équipement actuel détaillé
5. **Souhait du client** - Préférences du client
6. **Type d'appareil** - Types d'appareils souhaités
7. **Énergie** - Types d'énergie souhaités
8. **Fonction** - Fonctions souhaitées
9. **Évacuation** - Système d'évacuation détaillé
10. **Conformité** - Vérifications de conformité
11. **Description évacuation** - Description détaillée de l'évacuation
12. **Sécurité** - Aspects sécurité et accessibilité
13. **Accessoires** - Accessoires nécessaires
14. **Commentaires** - Commentaires et notes
15. **Annexes** - Photos et documents joints

## Composants

### 1. ReleveTechniqueModelComplet
Classe de données complète avec tous les champs des 15 sections.

**Fonctionnalités :**
- Constructeur complet avec tous les champs
- Sérialisation JSON (toJson/fromJson)
- Validation des données
- Support pour ~150 champs organisés par sections

### 2. ReleveTechniqueScreenComplet
Interface utilisateur avec onglets pour chaque section.

**Fonctionnalités :**
- Interface à onglets (TabBar) pour navigation facile
- Contrôles adaptés à chaque type de champ :
  - TextField pour texte/multiligne
  - Checkbox pour booléens
  - Dropdown pour sélections
  - TextField numérique pour mesures
- Sauvegarde automatique dans SharedPreferences
- Export TXT intégré

### 3. ExportService
Service d'export vers format TXT.

**Fonctionnalités :**
- Génération de contenu TXT structuré
- Export et partage automatique
- Format identique aux fichiers de référence
- Organisation par sections avec en-têtes

### 4. ReleveTechniqueExampleComplet
Exemple d'utilisation avec données pré-remplies.

## Utilisation

### Création d'un nouveau relevé

```dart
// Pour une chaudière
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ReleveTechniqueScreenComplet(
      type: TypeReleve.chaudiere,
    ),
  ),
);
```

### Types de relevés supportés

- `TypeReleve.chaudiere` - Relevé technique chaudière
- `TypeReleve.pac` - Relevé technique PAC
- `TypeReleve.climatisation` - Relevé technique climatisation

### Export des données

L'export se fait automatiquement via le bouton "Exporter en TXT" dans l'AppBar. Le fichier généré respecte exactement la structure des fichiers TXT de référence.

## Structure des données

Chaque section contient des champs spécifiques :

### Client
- Numéro client, nom, email, téléphones, adresse

### Environnement
- Type de logement, surface, occupants, année construction, etc.

### Équipement en place
- Marque, modèle, année, énergie, puissance, dimensions, etc.

### Évacuation
- Types de conduits, diamètres, longueurs, nombre de coudes, etc.

### Conformité
- Liste de vérifications booléennes pour conformité gaz

### Accessoires
- Liste d'accessoires nécessaires avec types et quantités

## Persistance des données

- Sauvegarde automatique dans SharedPreferences
- Comptage des relevés par type
- Récupération possible pour modification

## Export TXT

Le format d'export respecte la structure suivante :

```
RELEVE TECHNIQUE
================

INFORMATIONS GENERALES
----------------------
[Données générales]

CLIENT
------
[Informations client]

[... autres sections ...]

FIN DU RELEVE TECHNIQUE
=======================
```

## Intégration dans l'app

Pour intégrer ce système dans votre application Flutter :

1. Importez les fichiers nécessaires
2. Ajoutez les routes de navigation
3. Configurez les permissions pour l'export de fichiers
4. Ajoutez les dépendances nécessaires (shared_preferences, share_plus, path_provider)

## Dépendances requises

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0
  share_plus: ^7.0.0
  path_provider: ^2.1.0
  intl: ^0.19.0
```

## Tests

Le système a été testé avec :
- Création de relevés complets
- Sauvegarde et chargement des données
- Export TXT fonctionnel
- Navigation entre onglets
- Validation des champs obligatoires

## Évolutions possibles

- Synchronisation cloud
- Import depuis fichiers TXT existants
- Validation automatique des champs
- Templates par type d'équipement
- Intégration photo avec caméra
- Génération PDF