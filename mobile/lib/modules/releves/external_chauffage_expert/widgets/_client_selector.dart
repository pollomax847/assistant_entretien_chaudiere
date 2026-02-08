// widgets/_client_selector.dart
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/_client.dart';

class ClientSelector extends StatefulWidget {
  final Function(Client) onClientSelected;

  const ClientSelector({
    super.key,
    required this.onClientSelected,
  });

  @override
  State<ClientSelector> createState() => _ClientSelectorState();
}

class _ClientSelectorState extends State<ClientSelector> {
  List<Client> _clients = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Client> _filteredClients = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final clients = await DatabaseHelper.instance.getAllClients();
      if (!mounted) return;
      setState(() {
        _clients = clients;
        _filteredClients = clients;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des clients: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erreur lors du chargement des clients'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredClients = _clients;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await DatabaseHelper.instance.searchClients(query);
      setState(() {
        _filteredClients = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la recherche')),
        );
      }
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de recherche
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un client...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                          _filteredClients = _clients;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _performSearch(value);
            },
          ),
        ),

        // Liste des clients
        Expanded(
          child: _isLoading || _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _filteredClients.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_search,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Aucun client enregistré'
                                : 'Aucun client trouvé',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showAddClientDialog();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Ajouter un client'),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = _filteredClients[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(client.nom[0].toUpperCase()),
                            ),
                            title: Text(client.nom),
                            subtitle: Text(
                              '${client.codePostal} ${client.ville}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditClientDialog(client);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmation(client);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              widget.onClientSelected(client);
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Future<void> _showAddClientDialog() async {
    final formKey = GlobalKey<FormState>();
    final nomController = TextEditingController();
    final adresseController = TextEditingController();
    final codePostalController = TextEditingController();
    final villeController = TextEditingController();
    final telephoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un client'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: adresseController,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: codePostalController,
                  decoration: const InputDecoration(labelText: 'Code postal'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un code postal';
                    }
                    if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                      return 'Le code postal doit contenir 5 chiffres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: villeController,
                  decoration: const InputDecoration(labelText: 'Ville'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une ville';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: telephoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    if (!RegExp(r'^(\+33|0)[1-9](\d{2}){4}$').hasMatch(value)) {
                      return 'Veuillez entrer un numéro de téléphone valide';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final client = Client(
                  id: DateTime.now().millisecondsSinceEpoch,
                  nom: nomController.text,
                  adresse: adresseController.text,
                  codePostal: codePostalController.text,
                  ville: villeController.text,
                  telephone: telephoneController.text,
                  dateCreation: DateTime.now(),
                );

                try {
                  await DatabaseHelper.instance.insertClient(client);
                  if (mounted) {
                    Navigator.pop(context);
                    _loadClients();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditClientDialog(Client client) async {
    final formKey = GlobalKey<FormState>();
    final nomController = TextEditingController(text: client.nom);
    final adresseController = TextEditingController(text: client.adresse);
    final codePostalController = TextEditingController(text: client.codePostal);
    final villeController = TextEditingController(text: client.ville);
    final telephoneController = TextEditingController(text: client.telephone);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le client'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: adresseController,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: codePostalController,
                  decoration: const InputDecoration(labelText: 'Code postal'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un code postal';
                    }
                    if (!RegExp(r'^\d{5}$').hasMatch(value)) {
                      return 'Le code postal doit contenir 5 chiffres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: villeController,
                  decoration: const InputDecoration(labelText: 'Ville'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une ville';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: telephoneController,
                  decoration: const InputDecoration(labelText: 'Téléphone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    if (!RegExp(r'^(\+33|0)[1-9](\d{2}){4}$').hasMatch(value)) {
                      return 'Veuillez entrer un numéro de téléphone valide';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final updatedClient = client.copyWith(
                  nom: nomController.text,
                  adresse: adresseController.text,
                  codePostal: codePostalController.text,
                  ville: villeController.text,
                  telephone: telephoneController.text,
                );

                try {
                  await DatabaseHelper.instance.updateClient(updatedClient);
                  if (mounted) {
                    Navigator.pop(context);
                    _loadClients();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Client client) async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${client.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && client.id != null) {
      try {
        await DatabaseHelper.instance.deleteClient(client.id!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client supprimé avec succès')),
        );
        _loadClients();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de la suppression'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
