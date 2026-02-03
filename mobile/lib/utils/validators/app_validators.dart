import 'package:chauffageexpert/utils/constants/app_constants.dart';

/// Validateurs pour les formulaires
class AppValidators {
  /// Champ requis
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? AppConstants.erreurChampRequis;
    }
    return null;
  }
  
  /// Email valide
  static String? email(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return null; // Utiliser avec required() si besoin
    }
    
    final emailRegex = RegExp(AppConstants.regexEmail);
    if (!emailRegex.hasMatch(value)) {
      return message ?? AppConstants.erreurEmailInvalide;
    }
    return null;
  }
  
  /// Téléphone français valide
  static String? phone(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final phoneRegex = RegExp(AppConstants.regexTelephone);
    if (!phoneRegex.hasMatch(value)) {
      return message ?? AppConstants.erreurTelInvalide;
    }
    return null;
  }
  
  /// Nombre valide
  static String? number(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (double.tryParse(value) == null) {
      return message ?? AppConstants.erreurNombreInvalide;
    }
    return null;
  }
  
  /// Nombre dans une plage
  static String? numberInRange(
    String? value, {
    double? min,
    double? max,
    String? message,
  }) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return AppConstants.erreurNombreInvalide;
    }
    
    if (min != null && number < min) {
      return message ?? 'La valeur doit être supérieure ou égale à $min';
    }
    
    if (max != null && number > max) {
      return message ?? 'La valeur doit être inférieure ou égale à $max';
    }
    
    return null;
  }
  
  /// Longueur minimale
  static String? minLength(String? value, int length, {String? message}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length < length) {
      return message ?? 'Minimum $length caractères requis';
    }
    return null;
  }
  
  /// Longueur maximale
  static String? maxLength(String? value, int length, {String? message}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length > length) {
      return message ?? 'Maximum $length caractères autorisés';
    }
    return null;
  }
  
  /// Code postal français
  static String? codePostal(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final codePostalRegex = RegExp(AppConstants.regexCodePostal);
    if (!codePostalRegex.hasMatch(value)) {
      return message ?? 'Code postal invalide (5 chiffres)';
    }
    return null;
  }
  
  /// Regex personnalisé
  static String? regex(String? value, String pattern, {String? message}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return message ?? AppConstants.erreurFormatInvalide;
    }
    return null;
  }
  
  /// Combine plusieurs validateurs
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
  
  /// Champ requis + email
  static String? Function(String?) requiredEmail({String? requiredMessage, String? emailMessage}) {
    return combine([
      (v) => required(v, message: requiredMessage),
      (v) => email(v, message: emailMessage),
    ]);
  }
  
  /// Champ requis + téléphone
  static String? Function(String?) requiredPhone({String? requiredMessage, String? phoneMessage}) {
    return combine([
      (v) => required(v, message: requiredMessage),
      (v) => phone(v, message: phoneMessage),
    ]);
  }
  
  /// Champ requis + nombre
  static String? Function(String?) requiredNumber({
    String? requiredMessage,
    String? numberMessage,
    double? min,
    double? max,
  }) {
    return combine([
      (v) => required(v, message: requiredMessage),
      (v) => number(v, message: numberMessage),
      if (min != null || max != null) (v) => numberInRange(v, min: min, max: max),
    ]);
  }
}
