import 'package:shared_preferences/shared_preferences.dart';
import '../utils/mixins/shared_preferences_mixin.dart';

class StorageService with SharedPreferencesMixin {
  Future<Map<String, String>> loadReglementationData() async {
    return {
      'typeHotte': await loadString('typeHotte') ?? '',
      'ventilationConforme': await loadString('ventilationConforme') ?? 'NC',
      'ventilationObservation': await loadString('ventilationObservation') ?? '',
      'vmcPresent': await loadString('vmcPresent') ?? 'NC',
      'vmcConforme': await loadString('vmcConforme') ?? 'NC',
      'vmcObservation': await loadString('vmcObservation') ?? '',
      'detecteurCO': await loadString('detecteurCO') ?? 'NC',
      'detecteurGaz': await loadString('detecteurGaz') ?? 'NC',
      'detecteursConformes': await loadString('detecteursConformes') ?? 'NC',
      'distanceFenetre': await loadString('distanceFenetre') ?? '',
      'distancePorte': await loadString('distancePorte') ?? '',
      'distanceEvacuation': await loadString('distanceEvacuation') ?? '',
      'distanceAspiration': await loadString('distanceAspiration') ?? '',
    };
  }
}