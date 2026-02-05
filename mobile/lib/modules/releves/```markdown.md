```markdown
# Prompt pour la génération du formulaire Flutter (Dart) - Relevé Technique Pompe à Chaleur (PAC)

Crée un widget Flutter `RTPACForm` qui est un `StatefulWidget`. Ce formulaire doit permettre la saisie des informations pour un relevé technique de Pompe à Chaleur, organisé en sections dépliables (`ExpansionTile`) pour une meilleure ergonomie. Chaque champ de saisie doit être associé à un `TextEditingController` et les options Oui/Non à des `SwitchListTile` ou `CheckboxListTile`. Utilise des `DropdownButtonFormField` pour les choix multiples.

Le formulaire doit inclure les sections suivantes, avec une attention particulière aux emplacements des photos :

## 1. Client
- Numéro client (gazelle)
- Nom du client
- Adresse de facturation
- Email
- Téléphone fixe
- Téléphone mobile

## 2. Informations Générales
- Nom du Relevé Technique
- RT lié à un devis (Oui/Non)
- Nom du technicien
- Matricule
- Adresse d'installation
- Type d'équipement (Pompe à Chaleur)

## 3. Description de l'Habitation
- Logement (Maison/Appartement) - utiliser un `DropdownButtonFormField`
- Département
- Année de construction
- Repérage amiante établi (Oui/Non)
- Nombre de salle de bain
- Position du plancher bas (Terre-plein/Vide sanitaire/Sous-sol) - utiliser un `DropdownButtonFormField`
- Amélioration de tous les plafonds (Oui/Non)
- Surface menuiserie
- Type de ventilation (VMC simple flux/double flux/naturelle) - utiliser un `DropdownButtonFormField`
- Énergie Fuel (Oui/Non)
- Énergie Électrique (Oui/Non)
- Nombre d'habitants
- Altitude
- Configuration de la maison (Rectangulaire/Carrée/Complexe) - utiliser un `DropdownButtonFormField`
- Type de construction (Niveaux) - utiliser un `DropdownButtonFormField`
- Usage d'eau chaude sanitaire (Douche/Bain) - utiliser un `DropdownButtonFormField`
- Amélioration de tous les murs extérieurs (Oui/Non)
- Amélioration de tous les planchers (Oui/Non)
- Type de menuiserie (Bois/PVC/Alu) - utiliser un `DropdownButtonFormField`
- Hauteur de la pièce à chauffer
- Énergie Gaz Naturel (Oui/Non)
- Énergie Granulé de Bois (Oui/Non)
- Énergie Propane (Oui/Non)

## 4. Détails des Volumes à Chauffer et Émetteurs
- Surface à chauffer (m²)
- Hauteur à chauffer (m)
- Type d'émetteur zone 1 (Radiateur fonte/acier/plancher chauffant) - utiliser un `DropdownButtonFormField`
- Type d'émetteur zone 2 (Radiateur fonte/acier/plancher chauffant) - utiliser un `DropdownButtonFormField`
- Nombre total de radiateurs

## 5. Description de l'Appareil de Chauffage et son Système de Régulation
- Température maximale de confort
- Température minimale de confort
- Température circuit primaire
- Production ECS indépendante (Oui/Non)
- Consommation Quantité Fuel (L)
- Neutralisation Cuve (Oui/Non)
- Départ retour chauffage (mm)
- Instantanée (Oui/Non)
- Accumulée (Oui/Non)
- Quantité gaz propane (tonne)
- Mode de chauffage (Chaudière Fuel/Gaz/PAC) - utiliser un `DropdownButtonFormField`
- Marque équipement existant
- Modèle équipement existant
- Avant travaux : Type de chaudière
- Avant travaux : Âge de la chaudière
- ECS couplée à la production de Chauffage (Oui/Non)

## 6. Caractéristiques Électriques
- Tableau électrique conforme (Oui/Non)
- Présence du différentiel 30mA (Oui/Non)
- Nombre d'emplacements supplémentaires
- Mesure de la tension (V)
- Puissance de l'abonnement (kVA)
- Électricité (ex: EDF) - utiliser un `DropdownButtonFormField`
- Besoin d'un tableau supplémentaire (Oui/Non)
- Distance entre tableau & future installation (m/l)
- Emplacements disponibles sur le compteur
- Type de cheminement (Goulotte Intérieure/Extérieure) - utiliser un `DropdownButtonFormField`
- Commentaire tableau TGBT non conforme

## 7. Groupe Extérieur
- Groupe extérieur sur dalle béton (Oui/Non)
- Largeur de la dalle (cm)
- Type de groupe (Split/Monobloc) - utiliser un `DropdownButtonFormField`
- Nombre de carottage
- Longueur de la dalle (cm)
- Épaisseur de la dalle (cm)

## 8. Unité Intérieure
- Hauteur disponible sous plafond (m)
- Largeur portes d'accès
- Longueur du socle (cm)
- Longueur de la liaison frigorifique
- L'UI installée emplacement chaudière (Oui/Non)
- Longueur de la dalle (cm)
- Épaisseur de la dalle (cm)

## 9. Hydraulique
- Vanne 3 voies (Oui/Non)
- Présence ballon découplage/tampon (Oui/Non)
- Longueur Réseau hydraulique à isoler (m)
- Besoin vase d'expansion (Oui/Non)
- Présence de glycol dans l'installation (Oui/Non)
- Volume ballon de découplage (L)
- Présence disconnecteur (Oui/Non)
- Volume glycol (L)
- Vanne 4 voies (Oui/Non)
- Vanne motorisée (Oui/Non)
- Réseau hydraulique isolé (Oui/Non)
- Diamètre Réseau hydraulique à isoler (mm)
- Capacité vase d'expansion (L)
- Vidange existante (Oui/Non)

## 10. Souhait du Client
- Offre de financement souhaitée (Oui/Non)
- Marque (souhait)
- Modèle (souhait)

## 11. Commentaires
- Commentaire
- Informations Magasinier
- Travaux à la charge du Client

## 12. Informations de Dimensionnement
- Température circuit primaire
- Température extérieure de base corr (°C)
- Puissance calorifique minimum visée (kW)
- Puissance calorifique maximum visée (kW)
- Puissance Cal. Min visée à -7/+55°C (kW)
- Puissance Cal. Max visée à -7/+55°C (kW)
- Déperdition totale (kW)
- Taux de couverture (%)

## 13. Annexes (Photos)
- **TGBT** : Champ pour une photo du Tableau Général Basse Tension.
- **TGBT_2** : Champ pour une deuxième photo du TGBT (si nécessaire).
- **Emplacement groupe extérieur** : Champ pour une photo de l'emplacement du groupe extérieur.
- **Emplacement groupe intérieur** : Champ pour une photo de l'emplacement du groupe intérieur.

Le formulaire doit avoir un bouton "ENREGISTRER LE RELEVÉ PAC" qui déclenche une validation simple des champs obligatoires et affiche un `SnackBar` de confirmation.
```
