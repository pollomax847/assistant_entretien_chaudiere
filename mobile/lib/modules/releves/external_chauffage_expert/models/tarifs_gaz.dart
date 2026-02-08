// models/tarifs_gaz.dart
class TarifsGaz {
  static const Map<String, double> PRIX_KWH = {
    'B0': 0.1188, // < 1000 kWh/an
    'B1': 0.0993, // 1000-6000 kWh/an
    'B2i': 0.0799, // 6000-30000 kWh/an
    'B2S': 0.0699, // 30000-150000 kWh/an
    'B2M': 0.0599, // 150000-300000 kWh/an
  };

  static const Map<String, double> ABONNEMENT_MENSUEL = {
    'B0': 8.32,
    'B1': 9.96,
    'B2i': 24.37,
    'B2S': 24.37,
    'B2M': 24.37,
  };

  static const double TVA = 0.20;
  static const double CTA = 0.2074; // Contribution Tarifaire d'Acheminement
  static const double TICGN =
      0.00843; // Taxe Intérieure sur Consommation Gaz Naturel

  static double calculerEstimationFacture({
    required double consommationKWh,
    required int nombreJours,
    required String typeContrat,
  }) {
    // Prix HT
    double prixKWh = consommationKWh * PRIX_KWH[typeContrat]!;
    double abonnement = (nombreJours / 30) * ABONNEMENT_MENSUEL[typeContrat]!;

    // Taxes
    double ticgn = consommationKWh * TICGN;
    double cta = abonnement * CTA;

    // Total HT
    double totalHT = prixKWh + abonnement + ticgn + cta;

    // TVA
    double tva = totalHT * TVA;

    // Total TTC
    return totalHT + tva;
  }

  static Map<String, double> getDetailedEstimation({
    required double consommationKWh,
    required int nombreJours,
    required String typeContrat,
  }) {
    double prixKWh = consommationKWh * PRIX_KWH[typeContrat]!;
    double abonnement = (nombreJours / 30) * ABONNEMENT_MENSUEL[typeContrat]!;
    double ticgn = consommationKWh * TICGN;
    double cta = abonnement * CTA;
    double totalHT = prixKWh + abonnement + ticgn + cta;
    double tva = totalHT * TVA;
    double totalTTC = totalHT + tva;

    return {
      'prixKWh': prixKWh,
      'abonnement': abonnement,
      'ticgn': ticgn,
      'cta': cta,
      'totalHT': totalHT,
      'tva': tva,
      'totalTTC': totalTTC,
    };
  }
}
