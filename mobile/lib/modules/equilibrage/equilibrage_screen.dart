import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chantiers_provider.dart';
import '../../models/chantier.dart';

class EquilibrageScreen extends ConsumerWidget {
  const EquilibrageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chantiers = ref.watch(chantiersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Équilibrage')),
      body: chantiers.isEmpty
          ? const Center(child: Text('Aucun chantier. Appuyez sur + pour en ajouter.'))
          : ListView.builder(
              itemCount: chantiers.length,
              itemBuilder: (context, index) {
                final chantier = chantiers[index];
                return ExpansionTile(
                  key: ValueKey(chantier.id),
                  title: Text(chantier.nom),
                  subtitle: Text(chantier.adresse ?? ''),
                  children: [
                    if (chantier.radiateurs.isEmpty)
                      const ListTile(title: Text('Aucun radiateur')),
                    ...chantier.radiateurs.map((rad) {
                      return ListTile(
                        title: Text(rad.nom),
                        subtitle: Text(
                          'État: ${rad.statutDisplay} • Tours: ${rad.toursVanne.toStringAsFixed(1)}${rad.deltaT != null ? ' • ΔT: ${rad.deltaT!.toStringAsFixed(1)}°C' : ''}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(rad.nom),
                              content: Text('Statut: ${rad.statutDisplay}\nNotes: ${rad.notes}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Fermer'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final nouveau = Chantier.nouveau('Chantier ${chantiers.length + 1}');
          ref.read(chantiersProvider.notifier).ajouterChantier(nouveau);
        },
        tooltip: 'Ajouter chantier',
        child: const Icon(Icons.add),
      ),
    );
  }
}
