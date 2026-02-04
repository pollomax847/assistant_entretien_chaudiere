import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<Map<String, String>> loadReglementationData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'typeHotte': prefs.getString('typeHotte') ?? '',
      'ventilationConforme': prefs.getString('ventilationConforme') ?? 'NC',
      'ventilationObservation': prefs.getString('ventilationObservation') ?? '',
      'vmcPresent': prefs.getString('vmcPresent') ?? 'NC',
      'vmcConforme': prefs.getString('vmcConforme') ?? 'NC',
      'vmcObservation': prefs.getString('vmcObservation') ?? '',
      'detecteurCO': prefs.getString('detecteurCO') ?? 'NC',
      'detecteurGaz': prefs.getString('detecteurGaz') ?? 'NC',
      'detecteursConformes': prefs.getString('detecteursConformes') ?? 'NC',
      'distanceFenetre': prefs.getString('distanceFenetre') ?? '',
      'distancePorte': prefs.getString('distancePorte') ?? '',
      'distanceEvacuation': prefs.getString('distanceEvacuation') ?? '',
      'distanceAspiration': prefs.getString('distanceAspiration') ?? '',
    };
  }
}