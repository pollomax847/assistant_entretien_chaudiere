# Plan Implémentation - ZÉRO Suppression, Juste Réorganisation

**Date**: 4 février 2026  
**Principe**: GARDER 100% du code existant, juste le réorganiser

---

## 🎯 STRATÉGIE

```
ANCIEN (RESTE INTOUCHÉ):
lib/modules/
├── chaudiere/chaudiere_screen.dart ← GARDER
├── ecs/ecs_screen.dart ← GARDER
├── tirage/tirage_screen.dart ← GARDER
└── releves/
    ├── releve_technique_model_complet.dart ← GARDER
    └── releve_technique_screen_complet.dart ← GARDER

NOUVEAU (À CRÉER - COPIE RÉORGANISÉE):
lib/modules/releves/
├── models/
│   ├── releve_technique.dart (nouveau modèle)
│   ├── sections/ (structures imbriquées)
│   └── enums/ (définitions types)
├── screens/
│   ├── releve_technique_screen.dart (nouveau écran)
│   └── tabs/ (écrans Tab = logique copiée des modules existants)
├── services/
│   ├── releve_storage_service.dart (sauvegarde JSON)
│   ├── releve_export_service.dart (export TXT/PDF)
│   └── data_bridge_service.dart (import des données anciennes)
└── _archive/ (ancien code conservé pour référence)
    ├── releve_technique_model_complet.dart.bak
    └── releve_technique_screen_complet.dart.bak
```

---

## 📋 PLAN DÉTAILLÉ PAR PHASE

### PHASE 1: Créer modèles sections (vides de logique)

**À créer:** 9 fichiers dans `lib/modules/releves/models/sections/`

```
✅ client_section.dart
   - Classe ClientSection (simple data holder)
   - Aucune logique, juste propriétés immutables
   - Référence: ReleveTechniqueModelComplet.client*
   
✅ chaudiere_section.dart
   - Classe ChaudiereSection (simple data holder)
   - Aucune logique des calculs
   - Référence: ReleveTechniqueModelComplet.chaudiere*
   
✅ ecs_section.dart
   - Classe EcsSection (simple data holder)
   - Aucune logique des calculs EcsScreen
   - Référence: ReleveTechniqueModelComplet + EcsScreen props
   
✅ tirage_section.dart
   - Classe TirageSection (simple data holder)
   - Aucune logique de simulation
   - Référence: ReleveTechniqueModelComplet.tirage* + TirageScreen props
   
✅ evacuation_section.dart
   - Classe EvacuationSection (simple data holder)
   - Référence: ReleveTechniqueModelComplet.evacuation*
   
✅ conformite_section.dart
   - Classe ConformiteSection (simple data holder)
   - Référence: ReleveTechniqueModelComplet.conformite*
   
✅ accessoires_section.dart
   - Classe AccessoiresSection (simple data holder)
   - Référence: ReleveTechniqueModelComplet.accessoires*
   
✅ securite_section.dart
   - Classe SecuriteSection (simple data holder)
   - Référence: ReleveTechniqueModelComplet.securite*
```

**Timing:** 2-3 heures

---

### PHASE 2: Créer modèle ReleveTechnique imbriqué

**À créer:** `lib/modules/releves/models/releve_technique.dart`

```dart
class ReleveTechnique {
  final String id;
  final DateTime dateCreation;
  final ClientSection client;
  final ChaudiereSection chaudiere;
  final EcsSection ecs;
  final TirageSection tirage;
  final EvacuationSection evacuation;
  final ConformiteSection conformite;
  final AccessoiresSection accessoires;
  final SecuriteSection securite;
  
  // Constructeur
  // toJson() / fromJson()
}
```

**Source des propriétés:** Fusionner ReleveTechniqueModelComplet (823 props) + sections

**Timing:** 1 heure

---

### PHASE 3: Créer énums

**À créer:** `lib/modules/releves/models/enums/type_definitions.dart`

```dart
enum TypeReleve { chaudiere, pac, clim }
enum TypeEcs { instantanee, ballon_separe, micro_accum, mixte }
enum TypeEvacuation { conduit_fumee, ventouse_v, ventouse_h, vmc, shunt }
// ... autres énums
```

**Copier de:** ReleveTechniqueModelComplet + ReleveTechniqueScreenComplet

**Timing:** 30 min

---

### PHASE 4: Créer écrans Tab (COPIE logique existante)

**À créer:** 8 fichiers dans `lib/modules/releves/screens/tabs/`

#### Tab 1: ClientTab

```dart
class ClientTab extends StatefulWidget {
  final ReleveTechnique releve;
  final Function(ReleveTechnique) onUpdate;
  
  const ClientTab({required this.releve, required this.onUpdate});
}

class _ClientTabState extends State<ClientTab> with ControllerDisposeMixin {
  late final TextEditingController numController;
  late final TextEditingController nomController;
  // ... autres controllers
  
  @override
  void initState() {
    super.initState();
    // Initialiser depuis widget.releve.client
    numController = registerController(TextEditingController(
      text: widget.releve.client.numero
    ));
    nomController = registerController(TextEditingController(
      text: widget.releve.client.nom
    ));
    // ...
  }
  
  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
  
  void _onChanged() {
    widget.onUpdate(widget.releve.copyWith(
      client: widget.releve.client.copyWith(
        numero: numController.text,
        nom: nomController.text,
        // ...
      ),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        TextField(controller: numController, onChanged: (_) => _onChanged()),
        TextField(controller: nomController, onChanged: (_) => _onChanged()),
        // ... autres champs
      ],
    );
  }
}
```

**Source logique:** Copier exactement depuis rt_chaudiere_form.dart (vide) + dynamique des autres formulaires

#### Tab 2: ChaudiereTab

**IMPORTANT:** Copier logique de ChaudiereScreen SANS modification

```dart
class _ChaudiereTabState extends State<ChaudiereTab> 
    with ControllerDisposeMixin {
  
  // Copier EXACTEMENT:
  // - _tirage = -0.180
  // - _co = 150.0
  // - _o2 = 5.2
  // - _limiteBasse, _idealMin, _idealMax
  // - _updateSimu() fonction
  // - Graphiques avec fl_chart
  // - Tous les calculs
  
  void _updateSimu() {
    // COPIE INTÉGRALE de ChaudiereScreen._updateSimu()
  }
  
  // Mais: Au lieu de sauvegarder dans SharedPrefs('dernier_tirage')
  //       Appeler widget.onUpdate() pour notifier parent
}
```

**Source logique:** `lib/modules/chaudiere/chaudiere_screen.dart` (copie intégrale, sans modification)

#### Tab 3: EcsTab

**IMPORTANT:** Copier logique de EcsScreen SANS modification

```dart
class _EcsTabState extends State<EcsTab> 
    with ControllerDisposeMixin {
  
  // Copier EXACTEMENT:
  // - List<TextEditingController> _debitControllers
  // - List<TextEditingController> _coeffControllers
  // - _tempFroideController, _tempChaudeController
  // - _equipements: List<String>
  // - _debitSimultaneLmin, _debitSimultaneM3h, _puissanceInstantanee
  // - _ajouterEquipement(), _supprimerEquipement()
  // - _calculerDebits() fonction
  // - Tous les calculs ECS
  
  void _calculerDebits() {
    // COPIE INTÉGRALE de EcsScreen._calculerDebits()
  }
  
  // Mais: Au lieu de sauvegarder dans SharedPrefs
  //       Appeler widget.onUpdate() pour notifier parent
}
```

**Source logique:** `lib/modules/ecs/ecs_screen.dart` (copie intégrale, sans modification)

#### Tab 4: TirageTab

**IMPORTANT:** Copier logique de TirageScreen SANS modification

```dart
class _TirageTabState extends State<TirageTab> 
    with ControllerDisposeMixin {
  
  // Copier EXACTEMENT:
  // - Toutes les propriétés de _TirageScreenState
  // - Tous les calculs de tirage
  // - Graphiques avec fl_chart
  // - Conformité tirage/CO/CO2/O2
  
  // Mais: Au lieu de sauvegarder dans SharedPrefs
  //       Appeler widget.onUpdate() pour notifier parent
}
```

**Source logique:** `lib/modules/tirage/tirage_screen.dart` (copie intégrale, sans modification)

#### Tabs 5-8: EvacuationTab, ConformiteTab, AccessoiresTab, SecuriteTab

```dart
// Formulaires standards sans logique complexe
// Inspiration: rt_pac_form.dart, rt_clim_form.dart
```

**Timing:** 4-5 heures

---

### PHASE 5: Créer services

#### A. RelevelStorageService

```dart
class RelevelStorageService with JsonStorageMixin {
  static const String _key = 'releve_technique_actuel';
  
  Future<void> saveReleve(ReleveTechnique releve) async {
    await saveJson(_key, releve.toJson());
  }
  
  Future<ReleveTechnique?> loadReleve() async {
    final json = await loadJson(_key);
    if (json != null) {
      return ReleveTechnique.fromJson(json);
    }
    return null;
  }
}
```

**Timing:** 30 min

#### B. RelevelExportService

```dart
class RelevelExportService with PDFGeneratorMixin {
  String genererTXT(ReleveTechnique releve) {
    // Copier logique de ExportService.genererContenuTXT()
    // Sans modification
  }
  
  Future<void> exporterPDF(ReleveTechnique releve) {
    // Copier logique de vmc_pdf_generator.dart
    // Adapter pour ReleveTechnique (pas VMC)
  }
}
```

**Timing:** 2 heures

#### C. DataBridgeService

```dart
class DataBridgeService {
  // Importer données anciennes vers nouvelles sections
  
  static Future<TirageSection?> importFromChaudiereScreen() async {
    final tirage = await SharedPreferences.getInstance()
      .then((p) => p.getDouble('dernier_tirage'));
    
    if (tirage == null) return null;
    
    return TirageSection(tirage: tirage);
  }
  
  static Future<EcsSection?> importFromEcsScreen() async {
    // Importer _equipements, débits, températures
  }
  
  static Future<TirageSection?> importFromTirageScreen() async {
    // Importer mesures gaz
  }
}
```

**Timing:** 1 heure

**TOTAL PHASE 5:** 3.5 heures

---

### PHASE 6: Créer écran conteneur

**À créer:** `lib/modules/releves/screens/releve_technique_screen.dart`

```dart
class ReleveTechniqueScreen extends StatefulWidget {
  const ReleveTechniqueScreen({Key? key}) : super(key: key);

  @override
  State<ReleveTechniqueScreen> createState() => _ReleveTechniqueScreenState();
}

class _ReleveTechniqueScreenState extends State<ReleveTechniqueScreen> 
    with SnackBarMixin, JsonStorageMixin, PDFGeneratorMixin {
  
  late TabController _tabController;
  late ReleveTechnique _releve;
  bool _isLoading = true;
  
  final RelevelStorageService _storageService = RelevelStorageService();
  final RelevelExportService _exportService = RelevelExportService();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _loadReleve();
  }
  
  Future<void> _loadReleve() async {
    try {
      final releve = await _storageService.loadReleve();
      if (releve != null) {
        setState(() => _releve = releve);
      } else {
        // Créer relevé vierge
        setState(() => _releve = ReleveTechnique.create());
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  Future<void> _saveReleve() async {
    try {
      await _storageService.saveReleve(_releve);
      showSuccess('Relevé sauvegardé');
    } catch (e) {
      showError('Erreur: $e');
    }
  }
  
  void _onTabUpdate(ReleveTechnique updated) {
    setState(() => _releve = updated);
    _saveReleve();
  }
  
  void _exportTXT() {
    try {
      final content = _exportService.genererTXT(_releve);
      // Partager
      Share.share(content);
    } catch (e) {
      showError('Erreur export: $e');
    }
  }
  
  Future<void> _exportPDF() async {
    try {
      await _exportService.exporterPDF(_releve);
      showSuccess('PDF généré');
    } catch (e) {
      showError('Erreur PDF: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Relevé Technique')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Client'),
            Tab(text: 'Chaudière'),
            Tab(text: 'ECS'),
            Tab(text: 'Tirage'),
            Tab(text: 'Évacuation'),
            Tab(text: 'Conformité'),
            Tab(text: 'Accessoires'),
            Tab(text: 'Sécurité'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportTXT,
            tooltip: 'Export TXT',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportPDF,
            tooltip: 'Export PDF',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ClientTab(releve: _releve, onUpdate: _onTabUpdate),
          ChaudiereTab(releve: _releve, onUpdate: _onTabUpdate),
          EcsTab(releve: _releve, onUpdate: _onTabUpdate),
          TirageTab(releve: _releve, onUpdate: _onTabUpdate),
          EvacuationTab(releve: _releve, onUpdate: _onTabUpdate),
          ConformiteTab(releve: _releve, onUpdate: _onTabUpdate),
          AccessoiresTab(releve: _releve, onUpdate: _onTabUpdate),
          SecuriteTab(releve: _releve, onUpdate: _onTabUpdate),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
```

**Timing:** 1.5 heures

---

### PHASE 7: Modifier main.dart et home_screen.dart

**Changements minimaux:**

main.dart:
```dart
// Ajouter import
import 'modules/releves/releve_technique_screen.dart';

// Ajouter route
'/releve-technique': (context) => const ReleveTechniqueScreen(),
```

home_screen.dart:
```dart
// Remplacer import
// import '../modules/releves/releve_technique_screen_complet.dart';
import '../modules/releves/releve_technique_screen.dart';

// Remplacer navigation
ReleveTechniqueScreenComplet(type: TypeReleve.chaudiere)
↓
const ReleveTechniqueScreen()
```

**Timing:** 30 min

---

### PHASE 8: Archiver ancien code (ZÉRO suppression)

```bash
# Créer dossier archive
mkdir lib/modules/releves/_archive

# Archiver ancien code
mv lib/modules/releves/releve_technique_model_complet.dart \
   lib/modules/releves/_archive/releve_technique_model_complet.dart.bak

mv lib/modules/releves/releve_technique_screen_complet.dart \
   lib/modules/releves/_archive/releve_technique_screen_complet.dart.bak

# Garder rt_chaudiere_form.dart, rt_pac_form.dart, etc. INTACTS
```

**Timing:** 15 min

---

### PHASE 9: Tests et validation

- [ ] Compiler sans erreurs
- [ ] Tester navigation ReleveTechniqueScreen
- [ ] Tester chaque Tab (Client, Chaudière, ECS, Tirage, etc)
- [ ] Tester sauvegarde/chargement
- [ ] Tester export TXT/PDF
- [ ] Vérifier ChaudiereScreen indépendant fonctionne encore
- [ ] Vérifier EcsScreen indépendant fonctionne encore
- [ ] Vérifier TirageScreen indépendant fonctionne encore

**Timing:** 2 heures

---

## ⏱️ TIMING TOTAL

| Phase | Tâche | Heures |
|-------|-------|--------|
| 1 | Modèles sections | 2.5 |
| 2 | Modèle ReleveTechnique | 1 |
| 3 | Énums | 0.5 |
| 4 | Écrans Tab | 5 |
| 5 | Services | 3.5 |
| 6 | Écran conteneur | 1.5 |
| 7 | main.dart + home_screen.dart | 0.5 |
| 8 | Archivage | 0.25 |
| 9 | Tests | 2 |
| **TOTAL** | | **~16.75 heures** |

---

## 📋 RÈGLES À RESPECTER ABSOLUMENT

✅ **À FAIRE:**
- ✅ Copier code existant INTÉGRALEMENT (pas de modification logique)
- ✅ Garder ancien code dans _archive/
- ✅ Garder ChaudiereScreen, EcsScreen, TirageScreen accessibles indépendamment
- ✅ Créer DataBridge pour importer anciennes données
- ✅ Utiliser mixins correctement (voir ANALYSE_MIXINS_COMPLET.md)

❌ **À NE PAS FAIRE:**
- ❌ Supprimer releve_technique_model_complet.dart
- ❌ Supprimer releve_technique_screen_complet.dart
- ❌ Supprimer rt_chaudiere_form.dart, rt_pac_form.dart, rt_clim_form.dart
- ❌ Modifier logique ChaudiereScreen, EcsScreen, TirageScreen
- ❌ Modifier logique des calculs (tirage, débits, etc)
- ❌ Supprimer routes anciennes dans main.dart

---

## 🔄 ORDRE D'IMPLÉMENTATION

1. Phase 1: Modèles sections (indépendant, pas d'imports critiques)
2. Phase 2: Modèle ReleveTechnique (dépend phase 1)
3. Phase 3: Énums (dépend phase 1-2)
4. Phase 4: Écrans Tab (dépend phase 1-3, peut être parallèle)
5. Phase 5: Services (dépend phase 1-3, peut être parallèle)
6. Phase 6: Écran conteneur (dépend tout)
7. Phase 7: Modifications main.dart + home_screen.dart (dépend phase 6)
8. Phase 8: Archivage (après tests)
9. Phase 9: Tests finaux

**Phases 4 et 5 peuvent être parallèles!**

