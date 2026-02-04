/// Section Sécurité - Accessibilité et sécurité
class SecuriteSection {
  // Accessibilité lieu
  final bool? tousAccesOk;
  final bool? travauxHauteur;
  final bool? echafaudageNecessaire;
  final String? commentaireAccessibilite;

  // Conditions spéciales
  final bool? toitPentu;
  final bool? comblePresent;
  final bool? cavitePresente;

  // Notes particulières chantier
  final String? particularites;
  final String? travailsACharger;
  final String? travailsAMentionner;

  const SecuriteSection({
    this.tousAccesOk,
    this.travauxHauteur,
    this.echafaudageNecessaire,
    this.commentaireAccessibilite,
    this.toitPentu,
    this.comblePresent,
    this.cavitePresente,
    this.particularites,
    this.travailsACharger,
    this.travailsAMentionner,
  });

  SecuriteSection copyWith({
    bool? tousAccesOk,
    bool? travauxHauteur,
    bool? echafaudageNecessaire,
    String? commentaireAccessibilite,
    bool? toitPentu,
    bool? comblePresent,
    bool? cavitePresente,
    String? particularites,
    String? travailsACharger,
    String? travailsAMentionner,
  }) {
    return SecuriteSection(
      tousAccesOk: tousAccesOk ?? this.tousAccesOk,
      travauxHauteur: travauxHauteur ?? this.travauxHauteur,
      echafaudageNecessaire:
          echafaudageNecessaire ?? this.echafaudageNecessaire,
      commentaireAccessibilite:
          commentaireAccessibilite ?? this.commentaireAccessibilite,
      toitPentu: toitPentu ?? this.toitPentu,
      comblePresent: comblePresent ?? this.comblePresent,
      cavitePresente: cavitePresente ?? this.cavitePresente,
      particularites: particularites ?? this.particularites,
      travailsACharger: travailsACharger ?? this.travailsACharger,
      travailsAMentionner: travailsAMentionner ?? this.travailsAMentionner,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tousAccesOk': tousAccesOk,
      'travauxHauteur': travauxHauteur,
      'echafaudageNecessaire': echafaudageNecessaire,
      'commentaireAccessibilite': commentaireAccessibilite,
      'toitPentu': toitPentu,
      'comblePresent': comblePresent,
      'cavitePresente': cavitePresente,
      'particularites': particularites,
      'travailsACharger': travailsACharger,
      'travailsAMentionner': travailsAMentionner,
    };
  }

  factory SecuriteSection.fromJson(Map<String, dynamic> json) {
    return SecuriteSection(
      tousAccesOk: json['tousAccesOk'] as bool?,
      travauxHauteur: json['travauxHauteur'] as bool?,
      echafaudageNecessaire: json['echafaudageNecessaire'] as bool?,
      commentaireAccessibilite: json['commentaireAccessibilite'] as String?,
      toitPentu: json['toitPentu'] as bool?,
      comblePresent: json['comblePresent'] as bool?,
      cavitePresente: json['cavitePresente'] as bool?,
      particularites: json['particularites'] as String?,
      travailsACharger: json['travailsACharger'] as String?,
      travailsAMentionner: json['travailsAMentionner'] as String?,
    );
  }
}
