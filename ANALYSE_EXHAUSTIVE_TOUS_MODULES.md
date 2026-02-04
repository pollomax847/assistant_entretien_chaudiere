# Analyse Exhaustive de TOUS les Modules - Inventaire Complet

**Date**: 4 février 2026  
**Scope**: Tous les modules lib/modules/**  
**Total modules**: 11

---

## 📊 INVENTAIRE COMPLET DES MODULES

### 1. ✅ **CHAUDIERE**

**Fichiers:**
- `chaudiere_screen.dart` (306 lignes)

**Classes:**
- `ChaudiereScreen` (StatefulWidget)
- `_ChaudiereScreenState` 

**Fonctionnalités:**
- Simulation tirage (hPa) : valeur par défaut -0.180
- Mesure CO (ppm) : valeur par défaut 150.0
- Mesure O2 (%) : valeur par défaut 5.2
- Graphiques avec fl_chart
- Limites normatives: Min -0.100, Idéal -0.200 à -0.300

**Dépendances:**
- `SharedPreferencesMixin`, `SnackBarMixin`
- `fl_chart`
- SharedPreferences key: `'dernier_tirage'`

**Persistence:** 
- Sauvegarde tirage dans SharedPreferences
- Chargement au démarrage

**État interne:**
- `_tirage`: double
- `_co`: double
- `_o2`: double

**Données:** ⚠️ **Duplicables** dans ChaudiereSection du relevé

---

### 2. ✅ **ECS (Eau Chaude Sanitaire)**

**Fichiers:**
- `ecs_screen.dart` (441 lignes)

**Classes:**
- `EcsScreen` (StatefulWidget)
- `_EcsScreenState`

**Fonctionnalités:**
- Gestion équipements (avec débits)
- Calcul débit simultané (L/min, m³/h)
- Gestion températures (froide, chaude)
- Calcul puissance instantanée

**Dépendances:**
- `ControllerDisposeMixin`, `SnackBarMixin`, `SharedPreferencesMixin`
- `pdf_generator_service`
- `share_plus`

**Persistence:**
- SharedPreferences pour équipements
- List<String> _equipements

**État interne:**
- `_debitControllers`: List<TextEditingController>
- `_coeffControllers`: List<TextEditingController>
- `_tempFroideController`, `_tempChaudeController`
- `_equipements`: List<String>
- Résultats: `_debitSimultaneLmin`, `_debitSimultaneM3h`, `_puissanceInstantanee`

**Données:** ⚠️ **Duplicables** dans EcsSection du relevé

---

### 3. ✅ **TIRAGE**

**Fichiers:**
- `tirage_screen.dart`

**Classes:**
- `TirageScreen` (StatefulWidget)
- `_TirageScreenState`

**Fonctionnalités:**
- Mesures tirage (hPa)
- Mesures CO (ppm)
- Mesures CO2 (%)
- Mesures O2 (%)
- Graphiques avec fl_chart
- Conformité automatique

**Dépendances:**
- `SharedPreferencesMixin`, `SnackBarMixin`
- `fl_chart`

**Persistence:**
- SharedPreferences

**État interne:**
- Mesures numériques pour tirage, CO, CO2, O2
- États conformité (booléens)

**Données:** ⚠️ **Duplicables** dans TirageSection du relevé

---

### 4. 🔴 **RELEVES (Relevé Technique)**

**Fichiers:**
- `releve_technique_model_complet.dart` (823 lignes) ⚠️ **MONSTRE**
- `releve_technique_screen_complet.dart` (313 lignes)
- `rt_chaudiere_form.dart` (VIDE)
- `rt_pac_form.dart` (206 lignes)
- `rt_clim_form.dart`
- `widgets/common_form_widgets.dart`
- `mixins/reglementation_gaz_mixin.dart`
- `README_RELEVE_COMPLET.md`
- `README_MISE_A_JOUR.md`

**Classes:**
- `ReleveTechnique` (modèle - DOUBLON!)
- `ReleveTechnique` (dans screen - DOUBLON!)
- `ReleveTechniqueScreenComplet`
- `RTChaudiereForm` (vide)
- `RTPACForm` (formulaire)
- `RTClimForm` (formulaire)
- `TypeReleve` (enum - REDÉFINI!)

**Problèmes:**
- ⚠️ Modèle monstre: 150+ propriétés
- ⚠️ Redéfinition classe ReleveTechnique
- ⚠️ Redéfinition enum TypeReleve
- ⚠️ Formulaires incohérents
- ⚠️ Pas de structure logique

**État:** 🔴 **À REFACTORISER COMPLÈTEMENT**

---

### 5. ✅ **EQUILIBRAGE**

**Fichiers:**
- `equilibrage_screen.dart`
- `chantier_equilibrage_screen.dart`

**Classes:**
- `EquilibrageScreen` (StatefulWidget)
- `_EquilibrageScreenState`
- `ChantierEquilibrageScreen` (ConsumerStatefulWidget - Riverpod!)
- `_ChantierEquilibrageScreenState`

**Fonctionnalités:**
- Équilibrage radiateurs
- Données par chantier (utilise Riverpod)

**Dépendances:**
- `flutter_riverpod` (pour ConsumerStatefulWidget)
- Chantiers provider

**État:** ✅ **Indépendant, OK**

---

### 6. ✅ **PUISSANCE_CHAUFFAGE**

**Fichiers:**
- `gestion_pieces_screen.dart`
- `puissance_expert_screen.dart`
- `puissance_chauffage_expert_screen.dart`

**Classes:**
- `GestionPiecesScreen`
- `PuissanceExpertScreen`
- `PuissanceChauffageExpertScreen`

**Fonctionnalités:**
- Gestion des pièces
- Calculs puissance chauffage
- Mode expert pour calculs avancés

**Dépendances:**
- `SharedPreferencesMixin`, `JsonStorageMixin`, `CalculationMixin`

**État:** ✅ **Indépendant, OK**

---

### 7. ✅ **REGLEMENTATION_GAZ**

**Fichiers:**
- `reglementation_gaz_screen.dart`
- `dynamic_reglementation_form.dart`
- `models/` (diagnostic_question.dart, etc.)

**Classes:**
- `ReglementationGazScreen`
- `_ReglementationGazScreenState`
- `DynamicReglementationForm`
- `RadioGroup<T>`

**Fonctionnalités:**
- Formulaire dynamique pour questions réglementation
- Vérification conformité gaz
- Diagnostic questions/réponses

**Dépendances:**
- `reglementation_questions.json` dans data/

**État:** ✅ **Indépendant, OK**

---

### 8. ✅ **VASE_EXPANSION**

**Fichiers:**
- `vase_expansion_screen.dart`

**Classes:**
- `VaseExpansionScreen`
- `_VaseExpansionScreenState`

**Fonctionnalités:**
- Calculs vase expansion
- Formules techniques

**État:** ✅ **Indépendant, OK**

---

### 9. 🟡 **VMC (Ventilation Mécanique Contrôlée)**

**Fichiers:**
- `vmc_screen.dart`
- `vmc_integration_screen.dart`
- `vmc_calculator.dart`
- `vmc_documentation.dart`
- `vmc_documentation_screen.dart`
- `vmc_pdf_generator.dart`
- `screens/`
  - `vmc_home_screen.dart`
  - `vmc_calculator_screen.dart`
  - `vmc_simple_flux_screen.dart`
  - `vmc_double_flux_screen.dart`
- `providers/`
  - `vmc_theme_provider.dart`
- `data/` (données réglementaires)
- `widgets/` (composants)

**Classes:**
- `VmcScreen` (StatefulWidget)
- `VmcIntegrationScreen` (StatefulWidget)
- `VmcHomeScreen` (StatefulWidget)
- `VmcCalculatorScreen` (StatefulWidget)
- `VmcSimpleFluxScreen` (StatelessWidget)
- `VmcDoubleFluxScreen` (StatelessWidget)
- `VMCDocumentationScreen` (StatelessWidget)
- `VmcThemeProvider` (ChangeNotifier)

**Fonctionnalités:**
- ✅ Module complet et bien structuré
- Calculs débits VMC selon normes
- Support 5 types de VMC
- Support T1-T5+
- Export PDF
- Documentation intégrée

**Dépendances:**
- ThemeStateMixin
- `pdf` library
- Données réglementaires JSON

**État:** ✅ **Bien structuré, peut servir de référence**

---

### 10. ✅ **TESTS**

**Fichiers:**
- `top_compteur_gaz_screen.dart`
- `enhanced_top_gaz_screen.dart`

**Classes:**
- `TopCompteurGazScreen`
- `_TopCompteurGazScreenState`
- `EnhancedTopGazScreen`
- `_EnhancedTopGazScreenState`

**Fonctionnalités:**
- Tests de compteur gaz
- Version simple et améliorée

**État:** ✅ **Indépendant, OK**

---

### 11. 🟢 **CONFIG**

**Dossier**: Vide (pas de fichiers)

**État:** 🟢 **Vide, peut être utilisé**

---

## 📍 ARCHITECTURE DE NAVIGATION (HomeScreen)

```dart
HomeScreen (584 lignes) importe DIRECTEMENT:
├── PuissanceChauffageExpertScreen
├── ReglementationGazScreen
├── VmcScreen
├── EnhancedTopGazScreen
├── ChaudiereScreen
├── TirageScreen
├── EcsScreen
├── VaseExpansionScreen
├── EquilibrageScreen
└── ReleveTechniqueScreenComplet

Total: 10 modules accessibles
```

---

## 🔴 PROBLÈMES IDENTIFIÉS

### A. REDONDANCE DE DONNÉES

| Données | ChaudiereScreen | ReleveTechnique.ChaudiereSection | Problème |
|---------|-----------------|----------------------------------|----------|
| Tirage | ✅ Sauvegardé | À créer | Duplication |
| CO | ✅ Sauvegardé | À créer | Duplication |
| O2 | ✅ Sauvegardé | À créer | Duplication |

| Données | EcsScreen | ReleveTechnique.EcsSection | Problème |
|---------|-----------|---------------------------|----------|
| Équipements | ✅ Sauvegardés | À créer | Duplication |
| Débits | ✅ Calculés | À créer | Duplication |
| Températures | ✅ Sauvegardées | À créer | Duplication |

| Données | TirageScreen | ReleveTechnique.TirageSection | Problème |
|---------|--------------|------------------------------|----------|
| Mesures gaz | ✅ Sauvegardées | À créer | Duplication |

### B. MODULES INDÉPENDANTS

ChaudiereScreen, EcsScreen, TirageScreen sont **complètement indépendants** du ReleveTechnique:

```
ACTUEL:
HomeScreen
├── ChaudiereScreen (état isolé)
├── EcsScreen (état isolé)
├── TirageScreen (état isolé)
└── ReleveTechniqueScreenComplet (état séparé)
    ├── rt_chaudiere_form.dart (VIDE!)
    ├── rt_pac_form.dart
    └── rt_clim_form.dart

PROBLÈME: 4 silos indépendants, pas de convergence!
```

### C. MODÈLE RÉLEVÉ TECHNIQUE

**Situation:**
- `releve_technique_model_complet.dart`: 823 lignes, 150+ propriétés
- Enum `TypeReleve` redéfini
- Classe `ReleveTechnique` redéfinie dans l'écran

**Impact:**
- Impossible de naviguer
- Maintenance cauchemardesque
- Import/Export confus

---

## ✅ MODULES BIEN STRUCTURÉS (À PRENDRE COMME RÉFÉRENCE)

### Module VMC:

```
vmc/
├── vmc_calculator.dart (calculs)
├── vmc_integration_screen.dart (écran principal)
├── vmc_documentation.dart (contenu)
├── vmc_pdf_generator.dart (export)
├── screens/ (sous-écrans spécialisés)
├── providers/ (état avec ChangeNotifier)
├── data/ (données réglementaires)
└── widgets/ (composants réutilisables)
```

**Pourquoi c'est bon:**
✅ Séparation concerns (calculs / UI / export)
✅ Sous-modules pour chaque type VMC
✅ Provider pour gestion état
✅ Données externalisées
✅ Composants réutilisables

---

## 🎯 STRATÉGIE DE REFACTORISATION

### Approche proposée:

1. **Garder les modules indépendants**: Chaudiere, ECS, Tirage, etc
2. **Créer ReleveTechnique conteneur**: Pour l'intégration complète
3. **Permettre deux workflows:**
   - Workflow 1: Modules séparés (pour analyses rapides)
   - Workflow 2: ReleveTechnique intégré (pour rapports complets)

### Structure cible:

```
lib/modules/

1️⃣ MODULES INDÉPENDANTS (INCHANGÉS):
├── chaudiere/ (ChaudiereScreen)
├── ecs/ (EcsScreen)
├── tirage/ (TirageScreen)
├── equilibrage/ (EquilibrageScreen)
├── puissance_chauffage/
├── reglementation_gaz/
├── vase_expansion/
├── vmc/ (référence d'excellence)
└── tests/

2️⃣ RELEVÉ TECHNIQUE REFACTORISÉ:
└── releves/
    ├── models/ (NEW)
    │   ├── releve_technique.dart (classe parente)
    │   ├── sections/ (NEW)
    │   │   ├── client_section.dart
    │   │   ├── chaudiere_section.dart
    │   │   ├── ecs_section.dart
    │   │   ├── tirage_section.dart
    │   │   ├── evacuation_section.dart
    │   │   ├── conformite_section.dart
    │   │   ├── accessoires_section.dart
    │   │   └── securite_section.dart
    │   └── enums/ (NEW)
    │       └── type_definitions.dart
    ├── screens/ (NEW)
    │   ├── releve_technique_screen.dart (conteneur)
    │   └── tabs/ (NEW)
    │       ├── client_tab.dart
    │       ├── chaudiere_tab.dart
    │       ├── ecs_tab.dart
    │       ├── tirage_tab.dart
    │       └── ...
    ├── services/ (NEW)
    │   ├── releve_storage_service.dart
    │   ├── releve_export_service.dart
    │   └── releve_migration_service.dart
    ├── widgets/ (EXISTANT - garder)
    └── _archive/ (NEW)
        ├── releve_technique_model_complet.dart.bak
        ├── releve_technique_screen_complet.dart.bak
        └── rt_*_form.dart.bak

3️⃣ INTÉGRATION AVEC MODULES:
    releves/services/data_bridge_service.dart (NEW)
    └── Sync données Chaudiere → ReleveTechnique
    └── Sync données ECS → ReleveTechnique
    └── Sync données Tirage → ReleveTechnique
```

---

## 🔄 FLUX D'INTÉGRATION PROPOSÉ

### Scenario 1: Utilisateur utilise module indépendant

```
HomeScreen → ChaudiereScreen
                    ↓
            Saisit mesures tirage
                    ↓
            Sauvegarde dans SharedPrefs ('dernier_tirage')
                    ↓
            Retour HomeScreen
```

✅ **Inchangé**

### Scenario 2: Utilisateur crée relevé technique

```
HomeScreen → ReleveTechniqueScreenComplet
                    ↓
            Tab Client [saisie]
                    ↓
            Tab Chaudiere [saisie OU import ChaudiereScreen]
                    ↓
            Tab ECS [saisie OU import EcsScreen]
                    ↓
            Tab Tirage [saisie OU import TirageScreen]
                    ↓
            Tab Evacuation [saisie]
                    ↓
            Tab Conformité [saisie]
                    ↓
            Tab Accessoires [saisie]
                    ↓
            Tab Sécurité [saisie]
                    ↓
            EXPORTER TXT/PDF
                    ↓
            Sauvegarde complète dans JSON/SQLite
```

**DataBridge** permet:
- `importFromChaudiere()` - Récupère dernier_tirage → Tab Chaudiere
- `importFromEcs()` - Récupère équipements/débits → Tab ECS
- `importFromTirage()` - Récupère mesures gaz → Tab Tirage

---

## 📊 RÉSUMÉ DÉCISIONS

| Module | État | Action | Dépendance ReleveTechnique |
|--------|------|--------|---------------------------|
| Chaudiere | ✅ Bon | Garder | Optionnelle (DataBridge) |
| ECS | ✅ Bon | Garder | Optionnelle (DataBridge) |
| Tirage | ✅ Bon | Garder | Optionnelle (DataBridge) |
| Equilibrage | ✅ Bon | Garder | Non |
| Puissance | ✅ Bon | Garder | Non |
| Reglementation | ✅ Bon | Garder | Possible (section conformité) |
| VaseExpansion | ✅ Bon | Garder | Possible |
| VMC | ✅ Excellent | Garder référence | Possible |
| Tests | ✅ Bon | Garder | Non |
| **Releves** | 🔴 **Mauvais** | **REFACTORISER** | Central |

---

## 🎯 CHECKLIST AVANT IMPLÉMENTATION

### Préparation:
- [ ] Créer branche `refactor/releve-technique`
- [ ] Archiver ancien code dans `_archive/`
- [ ] Documenter toutes les dépendances

### Implémentation:
- [ ] Créer modèles sections
- [ ] Créer écrans Tab
- [ ] Créer services persistence
- [ ] Créer DataBridge pour imports

### Testing:
- [ ] Test création relevé
- [ ] Test sauvegarde/chargement
- [ ] Test import données modules
- [ ] Test export TXT/PDF

### Intégration:
- [ ] Adapter HomeScreen
- [ ] Tester navigation complète
- [ ] Vérifier pas de doublons imports

### Cleanup:
- [ ] Supprimer ancien code
- [ ] Mettre à jour documentation
- [ ] Vérifier git status

