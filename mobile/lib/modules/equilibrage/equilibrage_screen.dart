import 'package:flutter/material.dart';
import '../../utils/mixins/mixins.dart';

class EquilibrageScreen extends StatefulWidget {
  const EquilibrageScreen({super.key});

  @override
  State<EquilibrageScreen> createState() => _EquilibrageScreenState();
}

class _EquilibrageScreenState extends State<EquilibrageScreen>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _introController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // Recherche temporairement désactivée
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget wrapSection(Widget child, int index) {
      final fade = buildStaggeredFade(_introController, index);
      final slide = buildStaggeredSlide(fade);
      return buildFadeSlide(fade: fade, slide: slide, child: child);
    }

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
          ),
        ],
      ),
      body: Column(
        children: [
          wrapSection(
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Rechercher un chantier',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            0,
          ),
          Expanded(
            child: wrapSection(
              _isGridView ? _buildGridView() : _buildListView(),
              1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour ajouter un nouveau chantier
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fonctionnalité à implémenter')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: 0, // Pour l'instant, liste vide
      itemBuilder: (context, index) {
        return const ListTile(
          title: Text('Aucun chantier disponible'),
          subtitle: Text('Les chantiers apparaîtront ici'),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 0, // Pour l'instant, grille vide
      itemBuilder: (context, index) {
        return const Card(
          child: Center(
            child: Text('Aucun chantier'),
          ),
        );
      },
    );
  }
}
