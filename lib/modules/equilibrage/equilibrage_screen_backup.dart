import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chantiers_provider.dart';
import '../../models/chantier.dart';
import 'chantier_equilibrage_screen.dart';

class EquilibrageScreen extends ConsumerStatefulWidget {
  const EquilibrageScreen({super.key});

  @override
  ConsumerState<EquilibrageScreen> createState() => _EquilibrageScreenState();
}

class _EquilibrageScreenState extends ConsumerState<EquilibrageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOrder = 'recent'; // 'recent' ou 'oldest'
  bool _isGridView = false; // Toggle entre liste et grille

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Chantier> _getFilteredAndSortedChantiers(List<Chantier> chantiers) {
    // Filtrage par recherche
    var filtered = chantiers.where((chantier) {
      if (_searchQuery.isEmpty) return true;

      return chantier.nom.toLowerCase().contains(_searchQuery) ||
             (chantier.adresse?.toLowerCase().contains(_searchQuery) ?? false) ||
             (chantier.descriptionChaudiere?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();

    // Tri par date
    filtered.sort((a, b) {
      if (_sortOrder == 'recent') {
        return b.dateCreation.compareTo(a.dateCreation); // Plus récent en premier
      } else {
        return a.dateCreation.compareTo(b.dateCreation); // Plus ancien en premier
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final allChantiers = <Chantier>[];
    final filteredChantiers = _getFilteredAndSortedChantiers(allChantiers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Équilibrage Réseaux'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'Vue liste' : 'Vue grille',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddChantierDialog(context, ref),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortOrder = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Plus récent en premier'),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Text('Plus ancien en premier'),
              ),
            ],
            icon: const Icon(Icons.sort),
            tooltip: 'Trier par date',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un chantier...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
      body: filteredChantiers.isEmpty && allChantiers.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun chantier trouvé',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Essayez de modifier votre recherche',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : filteredChantiers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.build, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucun chantier d\'équilibrage',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Créez votre premier chantier pour commencer',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : _isGridView
                  ? _buildGridView(filteredChantiers)
                  : _buildListView(filteredChantiers),
    );
  }

  void _showAddChantierDialog(BuildContext context, WidgetRef ref) {
    final nomController = TextEditingController();
    final adresseController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau chantier d\'équilibrage'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du chantier *',
                  hintText: 'Ex: Maison Dupont - Paris',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  hintText: 'Ex: 123 rue de la Paix, 75001 Paris',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description chaudière',
                  hintText: 'Ex: Chaudière gaz Viessmann 2020',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomController.text.trim().isNotEmpty) {
                final nouveauChantier = Chantier(
                  id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple ID pour l'instant
                  nom: nomController.text.trim(),
                  adresse: adresseController.text.trim().isEmpty ? null : adresseController.text.trim(),
                  descriptionChaudiere: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                );
                ref.read(chantiersProvider.notifier).ajouterChantier(nouveauChantier);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Chantier "${nouveauChantier.nom}" créé')),
                );
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditChantierDialog(BuildContext context, WidgetRef ref, Chantier chantier) {
    final nomController = TextEditingController(text: chantier.nom);
    final adresseController = TextEditingController(text: chantier.adresse ?? '');
    final descriptionController = TextEditingController(text: chantier.descriptionChaudiere ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le chantier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom du chantier *'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: adresseController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description chaudière'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomController.text.trim().isNotEmpty) {
                final chantierModifie = Chantier(
                  id: chantier.id,
                  nom: nomController.text.trim(),
                  adresse: adresseController.text.trim().isEmpty ? null : adresseController.text.trim(),
                  descriptionChaudiere: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                  dateCreation: chantier.dateCreation,
                  radiateurs: chantier.radiateurs,
                );
                ref.read(chantiersProvider.notifier).updateChantier(chantierModifie);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chantier modifié')),
                );
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Chantier chantier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le chantier ?'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${chantier.nom}" ?\n\nCette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(chantiersProvider.notifier).supprimerChantier(chantier.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chantier "${chantier.nom}" supprimé')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _navigateToChantierEquilibrage(BuildContext context, Chantier chantier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChantierEquilibrageScreen(chantier: chantier),
      ),
    );
  }

  Widget _buildListView(List<Chantier> chantiers) {
    return ListView.builder(
      itemCount: chantiers.length,
      itemBuilder: (context, index) {
        final chantier = chantiers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.build,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              chantier.nom,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chantier.adresse != null) ...[
                  Text(chantier.adresse!),
                  const SizedBox(height: 4),
                ],
                if (chantier.descriptionChaudiere != null) ...[
                  Text(
                    chantier.descriptionChaudiere!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${chantier.dateCreation.day}/${chantier.dateCreation.month}/${chantier.dateCreation.year}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.thermostat, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${chantier.radiateurs.length} radiateur${chantier.radiateurs.length > 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditChantierDialog(context, ref, chantier);
                    break;
                  case 'delete':
                    _confirmDelete(context, ref, chantier);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Modifier'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _navigateToChantierEquilibrage(context, chantier),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<Chantier> chantiers) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: chantiers.length,
      itemBuilder: (context, index) {
        final chantier = chantiers[index];
        return Card(
          child: InkWell(
            onTap: () => _navigateToChantierEquilibrage(context, chantier),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.build,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _showEditChantierDialog(context, ref, chantier);
                              break;
                            case 'delete':
                              _confirmDelete(context, ref, chantier);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Modifier'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Supprimer'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    chantier.nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (chantier.adresse != null) ...[
                    Text(
                      chantier.adresse!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (chantier.descriptionChaudiere != null) ...[
                    Text(
                      chantier.descriptionChaudiere!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${chantier.dateCreation.day}/${chantier.dateCreation.month}/${chantier.dateCreation.year}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.thermostat, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${chantier.radiateurs.length} rad.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}