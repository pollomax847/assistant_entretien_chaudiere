import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chantier.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

final chantiersProvider = StateNotifierProvider<ChantiersNotifier, List<Chantier>>((ref) {
  return ChantiersNotifier(ref);
});

class ChantiersNotifier extends StateNotifier<List<Chantier>> {
  final Ref ref;
  ChantiersNotifier(this.ref) : super([]) {
    _loadChantiers(); // Charge au démarrage
  }

  Future<void> _loadChantiers() async {
    final storage = ref.read(storageServiceProvider);
    final loaded = await storage.loadChantiers();
    state = loaded;
  }

  Future<void> _save() async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveChantiers(state);
  }

  void ajouterChantier(Chantier chantier) {
    state = [...state, chantier];
    _save();
  }

  void updateChantier(Chantier updated) {
    state = [
      for (final c in state)
        c.id == updated.id ? updated : c,
    ];
    _save();
  }

  void supprimerChantier(String id) {
    state = state.where((c) => c.id != id).toList();
    _save();
  }

  // Optionnel : refresh manuel si besoin
  Future<void> refresh() => _loadChantiers();
}