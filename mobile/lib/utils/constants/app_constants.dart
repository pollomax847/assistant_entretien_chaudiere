/// Constantes de l'application
class AppConstants {
  // Informations de l'app
  static const String appName = 'Chauffage Expert';
  static const String appVersion = '1.0.0';
  
  // Clés SharedPreferences
  static const String prefKeyDernierTirage = 'dernier_tirage';
  static const String prefKeyEntrepriseNom = 'entreprise_nom';
  static const String prefKeyEntrepriseAdresse = 'entreprise_adresse';
  static const String prefKeyEntrepriseTel = 'entreprise_tel';
  static const String prefKeyEntrepriseEmail = 'entreprise_email';
  static const String prefKeyThemeMode = 'theme_mode';
  
  // Réglementation Gaz - Préfixes
  static const String prefPrefixRegGaz = 'reg_gaz_';
  
  // Limites de validation
  static const double tirageMin = -0.50;
  static const double tirageMax = -0.05;
  static const double tirageLimiteBasse = -0.100;
  static const double tirageIdealMin = -0.200;
  static const double tirageIdealMax = -0.300;
  
  static const double coMin = 50.0;
  static const double coMax = 1200.0;
  static const double coLimite = 500.0;
  
  static const double o2Min = 1.5;
  static const double o2Max = 7.5;
  
  static const double co2Min = 7.0;
  static const double co2Max = 11.0;
  
  // Durées
  static const int snackBarDurationShort = 2;
  static const int snackBarDurationMedium = 3;
  static const int snackBarDurationLong = 4;
  
  static const int splashScreenDuration = 2;
  static const int animationDurationFast = 200;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;
  
  // Formats de date
  static const String dateFormatFull = 'dd/MM/yyyy HH:mm';
  static const String dateFormatShort = 'dd/MM/yyyy';
  static const String dateFormatTime = 'HH:mm';
  
  // Formats de nombres
  static const int decimalPlaces = 2;
  static const int decimalPlacesPressure = 3;
  
  // PDF
  static const String pdfDossier = 'Documents/ChauffageExpert';
  static const String jsonDossier = 'Documents/ChauffageExpert/JSON';
  
  // URLs
  static const String githubRepo = 'https://github.com/pollomax847/assitant_entreiten_chaudiere';
  static const String supportEmail = 'memo.chaudiere@gmail.com';
  
  // Gaz types avec PCS (kWh/m³)
  static const Map<String, Map<String, dynamic>> gasTypes = {
    'Gaz naturel (H)': {'pcs': 11.1},
    'Gaz naturel (B)': {'pcs': 9.94},
    'Propane': {'pcs': 28.0},
    'Butane': {'pcs': 31.3},
  };
  
  // Labels communs
  static const String labelOui = 'Oui';
  static const String labelNon = 'Non';
  static const String labelNC = 'NC';
  
  static const List<String> ouiNonNC = [labelOui, labelNon, labelNC];
  
  // Messages d'erreur courants
  static const String erreurChampRequis = 'Ce champ est requis';
  static const String erreurFormatInvalide = 'Format invalide';
  static const String erreurNombreInvalide = 'Veuillez entrer un nombre valide';
  static const String erreurEmailInvalide = 'Email invalide';
  static const String erreurTelInvalide = 'Numéro de téléphone invalide';
  
  // Messages de succès
  static const String successSauvegarde = 'Sauvegardé avec succès';
  static const String successExportPDF = 'PDF généré avec succès';
  static const String successExportJSON = 'JSON exporté avec succès';
  static const String successCopie = 'Copié !';
  
  // Regex patterns
  static const String regexEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String regexTelephone = r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$';
  static const String regexNombre = r'^-?\d+\.?\d*$';
  static const String regexCodePostal = r'^\d{5}$';
}
