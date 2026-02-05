import 'package:flutter/material.dart';
import '../models/releve_technique.dart';
import '../models/sections/client_section.dart';
import '../models/sections/chaudiere_section.dart';
import '../models/sections/ecs_section.dart';
import '../models/sections/tirage_section.dart';
import '../models/sections/evacuation_section.dart';
import '../models/sections/conformite_section.dart';
import '../models/sections/accessoires_section.dart';
import '../models/sections/securite_section.dart';
import '../models/sections/puissance_section.dart';
import '../models/sections/vmc_section.dart';
import '../screens/tabs/client_tab.dart';
import '../screens/tabs/chaudiere_tab.dart';
import '../screens/tabs/ecs_tab.dart';
import '../screens/tabs/tirage_tab.dart';
import '../screens/tabs/evacuation_tab.dart';
import '../screens/tabs/conformite_tab.dart';
import '../screens/tabs/accessoires_tab.dart';
import '../screens/tabs/securite_tab.dart';
import '../services/relevel_storage_service.dart';
import '../services/relevel_export_service.dart';
import '../services/data_bridge_service.dart';

/// Écran principal - Relevé Technique
/// Conteneur pour les 8 onglets avec gestion globale du relevé
class ReleveTechniqueScreen extends StatefulWidget {
  final String? releveId;

  const ReleveTechniqueScreen({
    Key? key,
    this.releveId,
  }) : super(key: key);

  @override
  _ReleveTechniqueScreenState createState() => _ReleveTechniqueScreenState();
}

class _ReleveTechniqueScreenState extends State<ReleveTechniqueScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ReleveTechnique _releve;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _initializeReleve();
  }

  Future<void> _initializeReleve() async {
    try {
      // Charger un relevé existant ou en créer un nouveau
      ReleveTechnique? loaded;
      
      if (widget.releveId != null) {
        loaded = await RelevelStorageService.loadReleve();
      }
      
      if (loaded != null) {
        _releve = loaded;
      } else {
        // Vérifier les anciennes données à importer
        final hasOldData = await DataBridgeService.detectOldData();
        if (hasOldData.values.contains(true)) {
          _releve = await DataBridgeService.importAllData();
        } else {
          _releve = ReleveTechnique.create();
        }
      }
      
      setState(() => _isLoading = false);
    } catch (e) {
      print('Erreur initialisation: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Callback pour mettre à jour une section
  void _updateSection<T>(T section) {
    if (section is ClientSection) {
      _releve = _releve.copyWith(client: section);
    } else if (section is ChaudiereSection) {
      _releve = _releve.copyWith(chaudiere: section);
    } else if (section is EcsSection) {
      _releve = _releve.copyWith(ecs: section);
    } else if (section is TirageSection) {
      _releve = _releve.copyWith(tirage: section);
    } else if (section is EvacuationSection) {
      _releve = _releve.copyWith(evacuation: section);
    } else if (section is ConformiteSection) {
      _releve = _releve.copyWith(conformite: section);
    } else if (section is AccessoiresSection) {
      _releve = _releve.copyWith(accessoires: section);
    } else if (section is SecuriteSection) {
      _releve = _releve.copyWith(securite: section);
    } else if (section is PuissanceSection) {
      _releve = _releve.copyWith(puissance: section);
    } else if (section is VmcSection) {
      _releve = _releve.copyWith(vmc: section);
    }
    
    _saveReleve();
  }

  /// Sauvegarde le relevé actuel
  Future<void> _saveReleve() async {
    final success = await RelevelStorageService.saveReleve(_releve);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la sauvegarde'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Exporte le relevé en TXT
  Future<void> _exportTxt() async {
    final filename = 'releve_${DateTime.now().millisecondsSinceEpoch}';
    final file = await RelevelExportService.saveToFile(_releve, filename);
    
    if (file != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Relevé exporté: ${file.path}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Affiche le résumé du relevé
  void _showSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Résumé du Relevé'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${_releve.id}'),
              const SizedBox(height: 8),
              Text('Client: ${_releve.client?.nom ?? "Non renseigné"}'),
              const SizedBox(height: 8),
              Text('Adresse: ${_releve.client?.adresseChantier ?? "Non renseignée"}'),
              const SizedBox(height: 8),
              Text('Créé: ${_releve.dateCreation.day}/${_releve.dateCreation.month}/${_releve.dateCreation.year}'),
              const SizedBox(height: 8),
              Text('Complétion: ${_releve.pourcentageCompletion}%'),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _releve.pourcentageCompletion / 100,
                minHeight: 8,
              ),
              const SizedBox(height: 12),
              Text(
                'Sections complétées: ${_releve.pourcentageCompletion ~/ 10} / 10',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Relevé Technique'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erreur lors du chargement'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() => _isLoading = true);
                  _initializeReleve();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Client'),
            Tab(icon: Icon(Icons.local_fire_department), text: 'Chaudière'),
            Tab(icon: Icon(Icons.water_drop), text: 'ECS'),
            Tab(icon: Icon(Icons.air), text: 'Tirage'),
            Tab(icon: Icon(Icons.cloud), text: 'Évacuation'),
            Tab(icon: Icon(Icons.check_circle), text: 'Conformité'),
            Tab(icon: Icon(Icons.build), text: 'Accessoires'),
            Tab(icon: Icon(Icons.security), text: 'Sécurité'),
          ],
          isScrollable: true,
        ),
        actions: [
          Tooltip(
            message: 'Résumé',
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: _showSummary,
            ),
          ),
          Tooltip(
            message: 'Exporter',
            child: IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportTxt,
            ),
          ),
          Tooltip(
            message: 'Plus',
            child: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text('Nouveau relevé'),
                ),
                const PopupMenuItem(
                  child: Text('Importer données anciennes'),
                ),
                const PopupMenuItem(
                  child: Text('À propos'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Onglet Client
          ClientTab(
            initialData: _releve.client,
            onUpdate: _updateSection,
          ),
          
          // Onglet Chaudière
          ChaudiereTab(
            initialData: _releve.chaudiere,
            onUpdate: _updateSection,
          ),
          
          // Onglet ECS
          EcsTab(
            initialData: _releve.ecs,
            onUpdate: _updateSection,
          ),
          
          // Onglet Tirage
          TirageTab(
            initialData: _releve.tirage,
            onUpdate: _updateSection,
          ),
          
          // Onglet Évacuation
          EvacuationTab(
            initialData: _releve.evacuation,
            onUpdate: _updateSection,
          ),
          
          // Onglet Conformité
          ConformiteTab(
            initialData: _releve.conformite,
            onUpdate: _updateSection,
          ),
          
          // Onglet Accessoires
          AccessoiresTab(
            initialData: _releve.accessoires,
            onUpdate: _updateSection,
          ),
          
          // Onglet Sécurité
          SecuriteTab(
            initialData: _releve.securite,
            onUpdate: _updateSection,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Indicateur de complétion
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Complétion du relevé'),
                const SizedBox(height: 4),
                SizedBox(
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _releve.pourcentageCompletion / 100,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${_releve.pourcentageCompletion}%'),
              ],
            ),
            
            // Bouton sauvegarde
            ElevatedButton.icon(
              onPressed: _saveReleve,
              icon: const Icon(Icons.save),
              label: const Text('Sauvegarde'),
            ),
          ],
        ),
      ),
    );
  }
}
