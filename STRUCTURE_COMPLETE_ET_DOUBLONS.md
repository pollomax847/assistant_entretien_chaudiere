# Analyse Complète de la Structure - Rapport de Doublons et Dépendances

**Date**: 4 février 2026  
**Version**: 1.0

---

## 📊 STRUCTURE ACTUELLE DÉTAILLÉE

### 1. MODULES EXISTANTS

```
lib/modules/
├── chaudiere/
│   └── chaudiere_screen.dart
│       - Classe: ChaudiereScreen (StatefulWidget)
│       - State: _ChaudiereScreenState
│       - Contenu: Simulation tirage avec graphiques
│       - Dépendances: fl_chart, shared_preferences
│       - SharedPreferences key: 'dernier_tirage'
│       - Mixins utilisés: SharedPreferencesMixin, SnackBarMixin
│
├── ecs/
│   └── ecs_screen.dart (441 lignes)
│       - Classe: EcsScreen (StatefulWidget)
│       - State: _EcsScreenState
│       - Contenu: Calcul débits ECS, équipements, températures
│       - Dépendances: shared_preferences, pdf_generator_service, share_plus
│       - Mixins utilisés: ControllerDisposeMixin, SnackBarMixin, SharedPreferencesMixin
│       - Persistence: List<String> _equipements, temperaturesÉ
│
├── tirage/
│   └── tirage_screen.dart
│       - Classe: TirageScreen (StatefulWidget)
│       - State: _TirageScreenState
│       - Contenu: Mesures tirage, CO, CO2, O2 avec graphiques
│       - Dépendances: fl_chart, shared_preferences
│       - Mixins utilisés: SharedPreferencesMixin, SnackBarMixin
│
├── releves/
│   ├── releve_technique_model_complet.dart (823 lignes) ⚠️ MONSTRE
│   │   - Classe: ReleveTechnique
│   │   - 150+ propriétés toutes au même niveau
│   │   - Enum: TypeReleve { chaudiere, pac, clim }
│   │   - toJson() / fromJson() pour sérialisation
│   │
│   ├── releve_technique_screen_complet.dart (313 lignes)
│   │   - Classe: ReleveTechniqueScreenComplet
│   │   - Classe: ReleveTechnique (DOUBLON DE MODEL!)
│   │   - State: _ReleveTechniqueScreenCompletState
│   │   - Controllers: nomEntreprise, nomTechnicien
│   │   - Enum: TypeReleve (REDÉFINI! DOUBLON!)
│   │
│   ├── rt_chaudiere_form.dart
│   │   - Classe: RTChaudiereForm
│   │   - VIDE: Juste structure de base
│   │
│   ├── rt_pac_form.dart (206 lignes)
│   │   - Classe: RTPACForm
│   │   - Controllers pour PAC
│   │
│   ├── rt_clim_form.dart
│   │   - Classe: RTClimForm
│   │   - Pour climatisation
│   │
│   ├── widgets/
│   │   └── common_form_widgets.dart
│   │       - Widgets réutilisables pour formulaires
│   │
│   └── mixins/
│       └── reglementation_gaz_mixin.dart
│           - Import: diagnostic_question.dart
│           - Pour vérifications conformité gaz
│
├── chaudiere/ (Module séparé!)
├── equilibrage/
├── puissance_chauffage/
├── reglementation_gaz/
├── vase_expansion/
├── vmc/
├── tests/
└── config/
```

---

## 🔴 DOUBLONS CRITIQUES IDENTIFIÉS

### 1. **ReleveTechnique - DOUBLON CLASSE**

| Fichier | Classe | Lignes | Problème |
|---------|--------|--------|----------|
| `releve_technique_model_complet.dart` | `class ReleveTechnique` | 823 | Modèle complet avec 150+ props |
| `releve_technique_screen_complet.dart` | `class ReleveTechnique` | ~30 | **DOUBLON** - Modèle simplifié dans écran |

**Problème**: Deux classes avec le même nom, deux implémentations différentes
- Model: 150+ propriétés, immutable
- Screen: Seulement quelques props, mutable

**Impact**: Confusion, risque d'incohérence

### 2. **TypeReleve - DOUBLON ENUM**

| Fichier | Énumération | Valeurs |
|---------|------------|---------|
| `releve_technique_model_complet.dart` | `enum TypeReleve` | chaudiere, pac, clim |
| `releve_technique_screen_complet.dart` | `enum TypeReleve` | **REDÉFINI** chaudiere, pac, clim |

**Problème**: Même énumération définie deux fois
**Impact**: Maintenabilité difficile

### 3. **Services de Persistence - DOUBLONS POTENTIELS**

| Fichier | Service | Fonction | Notes |
|---------|---------|----------|-------|
| `services/storage_service.dart` | `StorageService` | Chantiers (JSON file) | Gère fichiers chantiers |
| `services/export_service.dart` | `ExportService` | Export TXT ReleveTechnique | Utilise `releve_technique_model_complet` |
| `services/pdf_generator_service.dart` | - | PDF generation | Utilisé par ECS |
| `utils/mixins/json_storage_mixin.dart` | `JsonStorageMixin` | JSON persistence | Générique pour tous les États |
| `utils/helpers/storage_helper.dart` | `StorageHelper` | File operations | Partage fichiers |

**Problème**: Plusieurs approches de persistence (SharedPreferences + File + Mixin)
**Impact**: Inconsistance, code fragmente

---

## 📍 MODULES SÉPARÉS SANS RELATION HIÉRARCHIQUE

### Problème d'Architecture

```
ACTUEL (FRAGMENTÉ):
┌─────────────────────────────────────┐
│ home_screen.dart                    │
├─────────────────────────────────────┤
│ Nav vers modules séparés:           │
│ - ChaudiereScreen (indépendant)     │  
│ - EcsScreen (indépendant)           │  ← Pas de relation avec
│ - TirageScreen (indépendant)        │     ReleveTechnique!
│ - ReleveTechniqueScreenComplet      │
│                                     │
│ Chaque module = silos isolés ❌     │
└─────────────────────────────────────┘
```

### Modules affectés:
1. **ChaudiereScreen** - État tirage, CO, O2, graphiques
2. **EcsScreen** - État équipements, débits, températures
3. **TirageScreen** - État mesures gaz, graphiques
4. **ReleveTechniqueScreenComplet** - Devrait contenir les 3 ci-dessus!

### Données Sauvegardées Séparément:
- ChaudiereScreen: SharedPreferences key `'dernier_tirage'`
- EcsScreen: SharedPreferences + List<String> _equipements
- TirageScreen: SharedPreferences + État interne
- ReleveTechnique: Models pas encore persisted correctement

**Impact**: Données fragmentées, difficile à récupérer ensemble

---

## 📋 SERVICES EXISTANTS

### A. Storage / Persistence

| Service | Fichier | Rôle | État |
|---------|---------|------|-------|
| `StorageService` | `services/storage_service.dart` | Chantiers (JSON file) | Actif |
| `ExportService` | `services/export_service.dart` | Export TXT (ReleveTechnique) | Actif |
| `JsonStorageMixin` | `utils/mixins/json_storage_mixin.dart` | Persistence JSON générique | Actif |
| `StorageHelper` | `utils/helpers/storage_helper.dart` | File operations | Actif |

### B. Autres Services

| Service | Fichier | Rôle | État |
|---------|---------|------|-------|
| `PDFGeneratorService` | `services/pdf_generator_service.dart` | PDF generation | Actif |
| `UpdateService` | `services/update_service.dart` | In-app updates | Actif |
| `GithubUpdateService` | `services/github_update_service.dart` | Update check | Actif |

---

## 🎯 DÉPENDANCES ACTUELLES

### Import patterns:

```dart
// ReleveTechniqueScreenComplet utilise:
import 'rt_chaudiere_form.dart';
import 'rt_pac_form.dart';
import 'rt_clim_form.dart';

// HomeScreen importe:
import '../modules/chaudiere/chaudiere_screen.dart';
import '../modules/tirage/tirage_screen.dart';
import '../modules/ecs/ecs_screen.dart';
import '../modules/releves/releve_technique_screen_complet.dart';

// ExportService dépend de:
import '../modules/releves/releve_technique_model_complet.dart';

// JsonExporter dépend de:
import '../modules/releves/releve_technique_model.dart'; // ⚠️ Quel fichier?
```

---

## 🚨 RISQUES DE DOUBLONS LORS DE LA REFACTORISATION

### Risque 1: Créer des modèles de section sans supprimer l'ancien

**Scenario**:
```
NOUVEAU:
lib/modules/releves/models/sections/
├── client_section.dart
├── chaudiere_section.dart
├── ecs_section.dart
├── tirage_section.dart
└── ...

ANCIEN (toujours existant):
lib/modules/releves/
├── releve_technique_model_complet.dart ← CONFLIT!
└── releve_technique_screen_complet.dart ← CONFLIT!
```

**Solution**: Archiver ou supprimer l'ancien model avant créer le nouveau

### Risque 2: Persistence fragmentée

**Scenario**:
```
Ancien: ChaudiereScreen sauvegarde dans SharedPrefs 'dernier_tirage'
Nouveau: ChaudiereSection doit aussi y accéder? Ou nouveau système?

→ Risque: Données orphelines ou inconsistence
```

**Solution**: Créer une **stratégie de migration unifiée**

### Risque 3: Services d'export multiples

**Scenario**:
```
Ancien: ExportService.genererContenuTXT() → ReleveTechnique (823-props)
Nouveau: RelevelExportService → ReleveTechnique (sections imbriquées)

→ Risque: Deux systèmes d'export coexistent
```

**Solution**: Unifier en un seul service avec migration

### Risque 4: HomeScreen routes mélangées

**Scenario**:
```
HomeScreen importe à la fois:
- ChaudiereScreen (ancien, modules séparés)
- ReleveTechniqueScreenComplet (nouveau conteneur)

→ Utilisateur voit 2 entrées Chaudière?
```

**Solution**: Clairement supprimer les anciennes routes

---

## ✅ PLAN DE REFACTORISATION SANS DOUBLONS

### Phase 1: AUDIT & ARCHIVAGE (CETTE ÉTAPE)
- ✅ Identifier tous les doublons
- ✅ Lister toutes les dépendances
- ✅ Documenter l'état actuel (CE FICHIER)

### Phase 2: PRÉPARATION
- [ ] Créer branche git `refactor/releve-technique`
- [ ] Archiver: `releve_technique_model_complet.dart` → `_archive/`
- [ ] Archiver: `releve_technique_screen_complet.dart` → `_archive/`
- [ ] Archiver: `rt_*_form.dart` → `_archive/`

### Phase 3: IMPLÉMENTATION NOUVELLE STRUCTURE
- [ ] Créer `lib/modules/releves/models/`
  - [ ] `releve_technique.dart` (classe parente)
  - [ ] `sections/` (9 modèles de section)
  - [ ] `enums/` (énumérées)

- [ ] Créer `lib/modules/releves/services/`
  - [ ] `releve_storage_service.dart` (persistence)
  - [ ] `releve_export_service.dart` (export TXT/PDF)
  - [ ] `releve_migration_service.dart` (ancien → nouveau)

- [ ] Créer `lib/modules/releves/screens/`
  - [ ] `releve_technique_screen.dart` (conteneur principal)
  - [ ] `tabs/` (8 écrans Tab)

### Phase 4: INTÉGRATION
- [ ] Adapter HomeScreen à nouvelle structure
- [ ] Tester navigation
- [ ] Tester persistence

### Phase 5: CLEANUP
- [ ] Vérifier TOUS les imports
- [ ] Supprimer fichiers obsolètes (après backup)
- [ ] Tests finaux

---

## 📑 FICHIERS À NE PAS TOUCHER

Ces fichiers doivent **rester indépendants** (pas de relation avec ReleveTechnique):

- `services/storage_service.dart` - Chantiers seulement
- `services/pdf_generator_service.dart` - Utilité générale
- `services/update_service.dart` - In-app updates
- `services/github_update_service.dart` - Updates
- `providers/chantiers_provider.dart` - Gestion chantiers
- `models/chantier.dart` - Modèle chantier
- `models/radiateur.dart` - Modèle radiateur

---

## 📊 RÉSUMÉ DÉPENDANCES

```
ReleveTechniqueScreenComplet (313 lignes)
├── Import: rt_chaudiere_form.dart (vide)
├── Import: rt_pac_form.dart (206 lignes)
├── Import: rt_clim_form.dart
├── Utilise: ReleveTechnique (DOUBLON CLASSE)
└── Utilise: TypeReleve (DOUBLON ENUM)

ReleveTechniqueModelComplet (823 lignes)
├── Enum: TypeReleve
├── Class: ReleveTechnique (150+ props)
└── Factory: fromJson / toJson

ExportService (301 lignes)
├── Import: releve_technique_model_complet.dart
├── Fonction: genererContenuTXT()
└── Fonction: exporterEtPartager()

HomeScreen
├── Import: chaudiere_screen.dart
├── Import: ecs_screen.dart
├── Import: tirage_screen.dart
├── Import: releve_technique_screen_complet.dart
└── Navigation vers 4 modules distincts (FRAGMENTATION!)
```

---

## 🎯 DÉCISIONS À PRENDRE

### 1. **Ancien vs Nouveau Model**
- [ ] Supprimer `releve_technique_model_complet.dart`? (823 lignes)
- [ ] Ou garder pour backward compatibility?

### 2. **Ancien vs Nouveau Screen**
- [ ] Supprimer `releve_technique_screen_complet.dart`?
- [ ] Remplacer par nouvelle architecture Tab-based?

### 3. **Modules séparés vs Sections intégrées**
- [ ] Garder ChaudiereScreen/EcsScreen/TirageScreen comme modules indépendants?
- [ ] Ou créer des Tabs dans ReleveTechnique?
- [ ] Ou HYBRIDE: Modules indépendants + sections ReleveTechnique?

### 4. **Migration données**
- [ ] Migrate données `'dernier_tirage'` vers nouveau système?
- [ ] Ou garder legacy support?

### 5. **Services d'export**
- [ ] Unifier ExportService + nouveau RelevelExportService?
- [ ] Ou maintenir séparation?

---

## 📋 CHECKLIST AVANT IMPLÉMENTATION

- [ ] Décider archivage ancien code
- [ ] Créer branche git
- [ ] Lister TOUS les fichiers à modifier
- [ ] Lister TOUS les imports à mettre à jour
- [ ] Créer script migration données (SharedPrefs ancien → nouveau)
- [ ] Préparer rollback plan
- [ ] Tester sur branche d'abord

---

## 🔗 RÉFÉRENCES

- Diagnostic: `DIAGNOSTIC_COMPLET_RELEVE_TECHNIQUE.md`
- Structure proprosée: Voir sections du diagnostic
- Modèles complets: Dans diagnostic (9 sections)

