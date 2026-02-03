# 📚 Guide des Utilitaires et Bonnes Pratiques

Ce document recense tous les utilitaires créés pour améliorer la qualité et la maintenabilité du code de l'application Chauffage Expert.

## 📖 Table des matières

1. [Import centralisé](#import-centralisé)
2. [Thème](#thème)
3. [Constantes](#constantes)
4. [Extensions](#extensions)
5. [Validateurs](#validateurs)
6. [Widgets réutilisables](#widgets-réutilisables)
7. [Mixins](#mixins)
8. [Helpers](#helpers)
9. [Exemples d'utilisation](#exemples-dutilisation)

---

## 🎯 Import centralisé

Tous les utilitaires peuvent être importés en une seule ligne :

```dart
import 'package:chauffageexpert/utils/app_utils.dart';
```

---

## 🎨 Thème

**Fichier** : `lib/theme/app_theme.dart`

### AppColors

Couleurs standardisées pour toute l'application :

```dart
// Couleurs principales
AppColors.primary        // Bleu principal
AppColors.secondary      // Orange secondaire
AppColors.background     // Fond clair/sombre
AppColors.surface        // Surface des cartes
AppColors.error          // Rouge d'erreur

// Couleurs par module
AppColors.chaudiereColor
AppColors.pacColor
AppColors.climColor
AppColors.vmcColor
AppColors.tirageColor
AppColors.reglementationColor
AppColors.testsColor
AppColors.equilibrageColor
AppColors.ecsColor
AppColors.puissanceColor

// Couleurs d'état
AppColors.success
AppColors.warning
AppColors.info
AppColors.disabled
```

### AppTextStyles

Styles de texte cohérents :

```dart
AppTextStyles.displayLarge
AppTextStyles.headlineMedium
AppTextStyles.titleLarge
AppTextStyles.bodyMedium
AppTextStyles.labelSmall
```

### AppDimensions

Dimensions standardisées :

```dart
AppDimensions.paddingSmall    // 8.0
AppDimensions.paddingMedium   // 16.0
AppDimensions.paddingLarge    // 24.0
AppDimensions.radiusSmall     // 8.0
AppDimensions.radiusMedium    // 12.0
AppDimensions.radiusLarge     // 16.0
AppDimensions.iconSizeSmall   // 20.0
AppDimensions.iconSizeMedium  // 24.0
AppDimensions.iconSizeLarge   // 32.0
```

### Utilisation

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
)
```

---

## 🔧 Constantes

**Fichier** : `lib/utils/constants/app_constants.dart`

```dart
// Info app
AppConstants.appName
AppConstants.appVersion

// Clés SharedPreferences
AppConstants.prefKeyLastAnalysis
AppConstants.prefKeyClientName

// Limites de validation
AppConstants.tirageMinValue
AppConstants.tirageMaxValue
AppConstants.coMaxValue
AppConstants.o2MinValue

// Durées
AppConstants.snackBarDuration
AppConstants.animationDuration

// Formats de date
AppConstants.dateFormatFull
AppConstants.dateFormatShort

// Chemins
AppConstants.pdfPath
AppConstants.jsonPath

// Types de gaz avec PCS
AppConstants.gasTypes
AppConstants.defaultGasType

// Messages d'erreur
AppConstants.errorGeneric
AppConstants.errorNetwork
AppConstants.errorFileNotFound

// Regex
AppConstants.emailRegex
AppConstants.phoneRegex
```

---

## 🚀 Extensions

**Fichier** : `lib/utils/extensions/extensions.dart`

### StringExtensions

```dart
'hello'.capitalize()              // 'Hello'
'test@email.com'.isValidEmail     // true
'+33612345678'.isValidPhone       // true
'42.5'.toDoubleOrNull()          // 42.5
'Long text...'.truncate(10)      // 'Long te...'
'Café'.removeAccents()           // 'Cafe'
```

### NumExtensions

```dart
42.5.toStringWithDecimals(1)     // '42.5'
0.85.toPercentString()           // '85%'
25.isBetween(20, 30)             // true
```

### DateTimeExtensions

```dart
DateTime.now().toShortString()        // '15/12/2024'
DateTime.now().isToday                // true
date1.daysDifference(date2)          // 5
```

### ContextExtensions

```dart
context.theme                    // Theme.of(context)
context.textTheme               // Theme.of(context).textTheme
context.colorScheme             // Theme.of(context).colorScheme
context.primaryColor            // Theme.of(context).primaryColor
context.push(screen)            // Navigator.push
context.pop()                   // Navigator.pop
context.closeKeyboard()         // Ferme le clavier
context.showSnackBar('Message') // Affiche un SnackBar
```

### ListExtensions

```dart
list.getOrNull(10)              // null si index invalide
list.chunk(3)                   // [[1,2,3], [4,5,6]]
list.unique()                   // Supprime les doublons
```

### ColorExtensions

```dart
Colors.blue.lighten(0.2)        // Éclaircit de 20%
Colors.red.darken(0.3)          // Assombrit de 30%
Colors.green.toHex()            // '#4CAF50'
```

---

## ✅ Validateurs

**Fichier** : `lib/utils/validators/app_validators.dart`

```dart
TextFormField(
  validator: AppValidators.required('Le nom est requis'),
)

TextFormField(
  validator: AppValidators.email(),
)

TextFormField(
  validator: AppValidators.phone(),
)

TextFormField(
  validator: AppValidators.number(),
)

TextFormField(
  validator: AppValidators.numberInRange(0, 100, 'Valeur entre 0 et 100'),
)

// Combiner plusieurs validateurs
TextFormField(
  validator: AppValidators.combine([
    AppValidators.required('Email requis'),
    AppValidators.email(),
  ]),
)

// Validateurs pré-combinés
TextFormField(
  validator: AppValidators.requiredEmail(),
)
```

---

## 🎭 Widgets réutilisables

### AppSnackBar

**Fichier** : `lib/utils/widgets/app_snackbar.dart`

```dart
AppSnackBar.showSuccess(context, 'Opération réussie');
AppSnackBar.showError(context, 'Une erreur est survenue');
AppSnackBar.showWarning(context, 'Attention !');
AppSnackBar.showInfo(context, 'Information');
AppSnackBar.showCopied(context, 'Texte copié');
```

### AnimatedWidgets

**Fichier** : `lib/utils/widgets/animated_widgets.dart`

```dart
// Fade in
AnimatedWidgets.fadeIn(
  child: Text('Hello'),
  duration: Duration(milliseconds: 500),
)

// Slide in
AnimatedWidgets.slideInFromBottom(child: MyWidget())
AnimatedWidgets.slideInFromLeft(child: MyWidget())
AnimatedWidgets.slideInFromRight(child: MyWidget())

// Scale in
AnimatedWidgets.scaleIn(child: MyWidget())

// Fade + Slide
AnimatedWidgets.fadeInSlideUp(child: MyWidget())

// Liste avec animation décalée
AnimatedWidgets.staggeredList(
  children: [Widget1(), Widget2(), Widget3()],
  staggerDelay: Duration(milliseconds: 100),
)

// Effet shimmer (loading)
AnimatedWidgets.shimmer(
  child: Container(width: 200, height: 20),
)

// Rotation infinie
AnimatedWidgets.rotateInfinite(
  child: Icon(Icons.refresh),
)

// Pulsation
AnimatedWidgets.pulse(
  child: Icon(Icons.favorite),
)

// Widgets helper
LoadingWidget()
EmptyWidget(
  message: 'Aucune donnée',
  icon: Icons.inbox,
)
```

### SimulationWidgets

**Fichier** : `lib/utils/widgets/simulation_widgets.dart`

```dart
// Afficher une valeur principale
SimulationWidgets.buildMainValue(
  label: 'Puissance',
  value: 24.5,
  unit: 'kW',
  icon: Icons.flash_on,
)

// Carte d'information
SimulationWidgets.buildInfoCard(
  title: 'Info',
  subtitle: 'Description',
  icon: Icons.info,
  color: Colors.blue,
)

// Jauge de statut
SimulationWidgets.buildStatusGauge(
  label: 'Rendement',
  value: 85,
  minValue: 0,
  maxValue: 100,
)

// Slider avec label
SimulationWidgets.buildLabeledSlider(
  label: 'Température',
  value: 20,
  min: 15,
  max: 25,
  divisions: 10,
  unit: '°C',
  onChanged: (val) {},
)

// Champ numérique
SimulationWidgets.buildNumberField(
  label: 'Surface',
  controller: controller,
  suffix: 'm²',
)

// Section expansible
SimulationWidgets.buildExpandableSection(
  title: 'Détails',
  children: [Widget1(), Widget2()],
)

// Indicateur de plage
SimulationWidgets.buildRangeIndicator(
  value: 75,
  minLabel: 'Min',
  maxLabel: 'Max',
  optimalStart: 60,
  optimalEnd: 80,
)

// Tableau de résultats
SimulationWidgets.buildResultsTable(
  rows: [
    {'label': 'Total', 'value': '1250 kWh'},
    {'label': 'Coût', 'value': '150 €'},
  ],
)
```

---

## 🔄 Mixins

### SharedPreferencesMixin

**Fichier** : `lib/utils/mixins/shared_preferences_mixin.dart`

```dart
class MyScreen extends StatefulWidget {
  // ...
}

class _MyScreenState extends State<MyScreen> with SharedPreferencesMixin {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final name = await loadString('user_name');
    final age = await loadInt('user_age');
    final temperature = await loadDouble('temperature');
    final isDarkMode = await loadBool('dark_mode');
  }
  
  Future<void> _saveData() async {
    await saveString('user_name', 'John');
    await saveInt('user_age', 30);
    await saveDouble('temperature', 20.5);
    await saveBool('dark_mode', true);
  }
  
  Future<void> _clearData() async {
    await removeKey('user_name');
    // ou
    await clearAll();
  }
}
```

### CalculationMixin

**Fichier** : `lib/utils/mixins/calculation_mixin.dart`

Pour les écrans de calcul (ECS, vase expansion, puissance, etc.)

```dart
class MyCalcScreen extends StatefulWidget {
  // ...
}

class _MyCalcScreenState extends State<MyCalcScreen> 
    with SharedPreferencesMixin, CalculationMixin {
  
  final _valueController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Champ numérique avec style standardisé
        buildNumberField(
          controller: _valueController,
          label: 'Valeur',
          hint: 'Ex: 42',
          icon: Icons.calculate,
          suffix: 'kW',
        ),
        
        // Champ numérique avec validation
        buildValidatedNumberField(
          controller: _valueController,
          label: 'Température',
          min: 0,
          max: 100,
          required: true,
          icon: Icons.thermostat,
        ),
        
        // Dropdown
        buildDropdown<String>(
          value: selectedValue,
          items: ['Option 1', 'Option 2'],
          labelBuilder: (v) => v,
          onChanged: (v) => setState(() => selectedValue = v!),
          label: 'Choisir',
          icon: Icons.arrow_drop_down,
        ),
        
        // Slider avec label
        buildLabeledSlider(
          label: 'Puissance',
          value: power,
          min: 0,
          max: 100,
          onChanged: (v) => setState(() => power = v),
          divisions: 10,
          unit: ' kW',
        ),
        
        // Bouton de calcul
        buildCalculateButton(
          onPressed: _calculate,
          label: 'Calculer',
        ),
        
        // Carte de résultat simple
        if (isCalculated)
          buildResultCard(
            title: 'Résultat',
            value: '42.5 kW',
            subtitle: 'Avec marge de sécurité',
            color: Colors.blue.shade50,
            icon: Icons.flash_on,
          ),
        
        // Carte de résultat avec statut
        if (isCalculated)
          buildStatusResultCard(
            title: 'Statut',
            value: 'Conforme',
            status: 'success', // 'success', 'warning', 'error'
            subtitle: 'Dans les normes',
          ),
      ],
    );
  }
  
  void _calculate() {
    if (!validateControllers([_valueController])) return;
    
    final value = parseNumber(_valueController);
    // Faire le calcul...
    calculationResult = value * 2;
  }
}
```

### JsonStorageMixin

**Fichier** : `lib/utils/mixins/json_storage_mixin.dart`

Pour gérer des données complexes en JSON.

```dart
class MyScreen extends StatefulWidget {
  // ...
}

class _MyScreenState extends State<MyScreen> 
    with SharedPreferencesMixin, JsonStorageMixin {
  
  List<Map<String, dynamic>> _items = [];
  
  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  Future<void> _loadItems() async {
    _items = await loadListFromJson('items');
    setState(() {});
  }
  
  Future<void> _addItem(Map<String, dynamic> item) async {
    await appendToJsonList('items', item);
    await _loadItems();
  }
  
  Future<void> _removeItem(int index) async {
    await removeFromJsonListAt('items', index);
    await _loadItems();
  }
  
  Future<void> _updateItem(int index, Map<String, dynamic> item) async {
    await updateJsonListAt('items', index, item);
    await _loadItems();
  }
}
```

### ReglementationGazMixin

**Fichier** : `lib/modules/releves/mixins/reglementation_gaz_mixin.dart`

Pour les formulaires de relevé technique (chaudière, PAC, clim).

```dart
class MyFormState extends State<MyForm> with ReglementationGazMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildReglementationGazSection(
          showAllFields: true,
          onSave: () => saveReglementationToPrefs(),
        ),
      ],
    );
  }
}
```

---

## 🛠️ Helpers

### ErrorHandler

**Fichier** : `lib/utils/helpers/error_handler.dart`

```dart
// Gérer une erreur simple
try {
  // code...
} catch (e) {
  ErrorHandler.handle(context, e);
}

// Avec message personnalisé
ErrorHandler.handle(
  context,
  error,
  customMessage: 'Impossible de charger les données',
);

// Wrapper async
final result = await ErrorHandler.tryAsync(
  context,
  () => fetchData(),
  errorMessage: 'Erreur de chargement',
  defaultValue: [],
);

// Wrapper sync
final result = ErrorHandler.trySync(
  context,
  () => parseData(),
  defaultValue: null,
);

// Dialog d'erreur
ErrorHandler.showErrorDialog(
  context,
  title: 'Erreur',
  message: 'Impossible de se connecter',
  onRetry: () => retry(),
);

// Widget async avec gestion d'erreur
AsyncWidget<List<Data>>(
  future: fetchData(),
  builder: (context, data) => ListView(...),
  onRetry: () => setState(() {}),
)
```

### DateHelper

**Fichier** : `lib/utils/helpers/date_helper.dart`

```dart
// Formater des dates
DateHelper.formatShort(date)           // '15/12/2024'
DateHelper.formatLong(date)            // '15 décembre 2024'
DateHelper.formatTime(date)            // '14:30'
DateHelper.formatDateTime(date)        // '15/12/2024 14:30'
DateHelper.formatMonthYear(date)       // 'décembre 2024'
DateHelper.formatISO(date)             // '2024-12-15'

// Parser des dates
DateHelper.parseShort('15/12/2024')
DateHelper.parseISO('2024-12-15')

// Vérifications
DateHelper.isToday(date)
DateHelper.isYesterday(date)
DateHelper.isTomorrow(date)

// Format relatif
DateHelper.formatRelative(date)        // 'Aujourd'hui', 'Hier', ou date

// Calculs
DateHelper.daysBetween(date1, date2)   // 5
DateHelper.calculateAge(birthDate)     // 30
DateHelper.firstDayOfMonth(date)
DateHelper.lastDayOfMonth(date)
DateHelper.isLeapYear(2024)            // true
DateHelper.daysInMonth(2024, 2)        // 29
DateHelper.addBusinessDays(date, 5)    // +5 jours ouvrés
```

### StorageHelper

**Fichier** : `lib/utils/helpers/storage_helper.dart`

```dart
// Obtenir les répertoires
final docsDir = await StorageHelper.getDocumentsDirectory();
final tempDir = await StorageHelper.getTemporaryDirectory();
final path = await StorageHelper.getDocumentPath('file.txt');

// Opérations sur fichiers
await StorageHelper.fileExists(path)
await StorageHelper.deleteFile(path)
final content = await StorageHelper.readFile(path);
await StorageHelper.writeFile(path, 'contenu');
await StorageHelper.copyFile(sourcePath, destPath);

// Partage
await StorageHelper.shareFile(path, subject: 'Mon fichier');
await StorageHelper.shareText('Texte à partager');

// Infos fichier
final size = await StorageHelper.getFileSize(path);
final sizeStr = StorageHelper.formatFileSize(1024000); // '1.0 MB'

// Opérations sur répertoires
final files = await StorageHelper.listFiles(dirPath);
await StorageHelper.createDirectory(path);
await StorageHelper.deleteDirectory(path);
await StorageHelper.cleanTempFiles();
```

---

## 💡 Exemples d'utilisation

### Exemple complet d'un écran

```dart
import 'package:flutter/material.dart';
import 'package:chauffageexpert/utils/app_utils.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with SharedPreferencesMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final name = await loadString('name');
    if (name != null) {
      _nameController.text = name;
    }
  }
  
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      await saveString('name', _nameController.text);
      await saveString('email', _emailController.text);
      
      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Données sauvegardées');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon écran'),
        backgroundColor: AppColors.primary,
      ),
      body: AnimatedWidgets.fadeInSlideUp(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: AppValidators.required('Le nom est requis'),
                ),
                SizedBox(height: AppDimensions.paddingMedium),
                
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: AppValidators.requiredEmail(),
                ),
                SizedBox(height: AppDimensions.paddingLarge),
                
                ElevatedButton.icon(
                  onPressed: _saveData,
                  icon: const Icon(Icons.save),
                  label: const Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
```

### Exemple avec gestion d'erreur

```dart
class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  Future<List<String>> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simuler une erreur
    // throw Exception('Erreur de connexion');
    return ['Item 1', 'Item 2', 'Item 3'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Données')),
      body: AsyncWidget<List<String>>(
        future: _fetchData(),
        builder: (context, data) {
          if (data.isEmpty) {
            return const EmptyWidget(
              message: 'Aucune donnée disponible',
            );
          }
          
          return AnimatedWidgets.staggeredList(
            children: data.map((item) => 
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: Text(item),
              )
            ).toList(),
          );
        },
      ),
    );
  }
}
```

---

## 📋 Checklist migration

Pour migrer un ancien fichier vers les nouveaux utilitaires :

- [ ] Remplacer `ScaffoldMessenger.of(context).showSnackBar` par `AppSnackBar.showXXX`
- [ ] Remplacer les couleurs hardcodées par `AppColors.xxx`
- [ ] Remplacer les `TextStyle` inline par `AppTextStyles.xxx` ou `context.textTheme.xxx`
- [ ] Remplacer les padding/margin magic numbers par `AppDimensions.xxx`
- [ ] Utiliser `SharedPreferencesMixin` au lieu de `SharedPreferences.getInstance()`
- [ ] Ajouter des validateurs aux `TextFormField`
- [ ] Utiliser les extensions (`string.capitalize()`, `context.push()`, etc.)
- [ ] Ajouter des animations aux widgets importants
- [ ] Utiliser `ErrorHandler` pour gérer les erreurs
- [ ] Utiliser `DateHelper` pour formater les dates
- [ ] Utiliser `StorageHelper` pour les opérations fichiers

---

## 🎓 Bonnes pratiques

1. **Import unique** : Utilisez `import 'package:chauffageexpert/utils/app_utils.dart';`
2. **Constantes** : Ne jamais hardcoder de valeurs, utiliser `AppConstants`
3. **Thème** : Toujours utiliser les couleurs/styles du thème
4. **Validation** : Tous les formulaires doivent avoir des validateurs
5. **Erreurs** : Utiliser `ErrorHandler` pour une gestion cohérente
6. **Animations** : Ajouter des animations légères pour améliorer l'UX
7. **Extensions** : Profiter des extensions pour un code plus lisible
8. **Mixins** : Utiliser les mixins pour partager du code entre widgets

---

## 🔄 Mises à jour

Ce document sera mis à jour au fur et à mesure de l'ajout de nouveaux utilitaires.

**Dernière mise à jour** : Décembre 2024
