// new_project/lib/models/client.dart

class Client {
  final String nom;
  final String adresse;
  final String codePostal;
  final String ville;

  Client({
    required this.nom,
    required this.adresse,
    required this.codePostal,
    required this.ville,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'adresse': adresse,
      'codePostal': codePostal,
      'ville': ville,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      nom: map['nom'] as String,
      adresse: map['adresse'] as String,
      codePostal: map['codePostal'] as String,
      ville: map['ville'] as String,
    );
  }

  Client copyWith({
    String? nom,
    String? adresse,
    String? codePostal,
    String? ville,
  }) {
    return Client(
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
      codePostal: codePostal ?? this.codePostal,
      ville: ville ?? this.ville,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client &&
          runtimeType == other.runtimeType &&
          nom == other.nom &&
          adresse == other.adresse &&
          codePostal == other.codePostal &&
          ville == other.ville;

  @override
  int get hashCode => Object.hash(nom, adresse, codePostal, ville);

  @override
  String toString() {
    return 'Client{nom: $nom, adresse: $adresse, codePostal: $codePostal, ville: $ville}';
  }
}
