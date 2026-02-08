// Models for VMC integration
import 'dart:io';

enum BoucheType { extraction, soufflage }

class MesurePression {
  String pieceNom;
  BoucheType typeBouche;
  double pressionPa;
  double? pressionRef;
  String? commentaire;
  List<File> photos;

  MesurePression({
    required this.pieceNom,
    required this.typeBouche,
    required this.pressionPa,
    this.pressionRef = 80.0,
    this.commentaire,
    this.photos = const [],
  });
}

class Piece {
  String type;
  String nom;
  Piece({required this.type, required this.nom});
}

class Fenetre {
  String taille;
  bool ouverte;
  Fenetre({required this.taille, this.ouverte = false});
}

class MesureVMC {
  String piece;
  double debit;
  List<File> photos;
  bool conforme; // Added for conformity
  String? detailConformite;

  MesureVMC({
    required this.piece,
    required this.debit,
    this.photos = const [],
    this.conforme = true,
    this.detailConformite,
  });
}

// New models from calculator
class Bouche {
  String piece;
  int diametre;
  double debit;
  double vitesse;
  bool conforme;
  String? detail;

  Bouche({
    required this.piece,
    required this.diametre,
    required this.debit,
    required this.vitesse,
    this.conforme = true,
    this.detail,
  });
}

class EntreeAir {
  double debit;
  EntreeAir({required this.debit});
}