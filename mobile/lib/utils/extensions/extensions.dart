import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extensions sur String
extension StringExtensions on String {
  /// Capitalise la première lettre
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Capitalise chaque mot
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
  
  /// Vérifie si c'est un email valide
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  /// Vérifie si c'est un numéro de téléphone français valide
  bool get isValidPhone {
    return RegExp(r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$').hasMatch(this);
  }
  
  /// Vérifie si c'est un nombre valide
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
  
  /// Convertit en double ou retourne null
  double? get toDoubleOrNull {
    return double.tryParse(this);
  }
  
  /// Convertit en int ou retourne null
  int? get toIntOrNull {
    return int.tryParse(this);
  }
  
  /// Tronque le texte avec des points de suspension
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
  
  /// Retire tous les espaces
  String get removeSpaces => replaceAll(' ', '');
  
  /// Retire les accents
  String get removeAccents {
    const withAccents = 'àáâãäåèéêëìíîïòóôõöùúûüýÿñç';
    const withoutAccents = 'aaaaaaeeeeiiiiooooouuuuyync';
    
    String result = this;
    for (int i = 0; i < withAccents.length; i++) {
      result = result.replaceAll(withAccents[i], withoutAccents[i]);
      result = result.replaceAll(withAccents[i].toUpperCase(), withoutAccents[i].toUpperCase());
    }
    return result;
  }
}

/// Extensions sur num (int et double)
extension NumExtensions on num {
  /// Formate le nombre avec un nombre de décimales
  String toStringWithDecimals(int decimals) {
    return toStringAsFixed(decimals);
  }
  
  /// Formate en pourcentage
  String toPercentString({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }
  
  /// Arrondit au multiple le plus proche
  double roundToMultiple(double multiple) {
    return (this / multiple).round() * multiple;
  }
  
  /// Vérifie si le nombre est entre min et max (inclusif)
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }
  
  /// Clamp avec syntaxe simplifiée
  num clampValue(num min, num max) {
    return clamp(min, max);
  }
}

/// Extensions sur DateTime
extension DateTimeExtensions on DateTime {
  /// Format court (dd/MM/yyyy)
  String get toShortString {
    return DateFormat('dd/MM/yyyy').format(this);
  }
  
  /// Format complet (dd/MM/yyyy HH:mm)
  String get toFullString {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }
  
  /// Format heure seulement (HH:mm)
  String get toTimeString {
    return DateFormat('HH:mm').format(this);
  }
  
  /// Format personnalisé
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
  
  /// Vérifie si c'est aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Vérifie si c'est hier
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  /// Retourne le début de la journée (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }
  
  /// Retourne la fin de la journée (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
  
  /// Différence en jours (arrondi)
  int daysDifference(DateTime other) {
    return difference(other).inDays;
  }
}

/// Extensions sur BuildContext
extension ContextExtensions on BuildContext {
  /// Accès rapide au thème
  ThemeData get theme => Theme.of(this);
  
  /// Accès rapide aux couleurs du thème
  ColorScheme get colors => theme.colorScheme;
  
  /// Accès rapide aux styles de texte
  TextTheme get textTheme => theme.textTheme;
  
  /// Taille de l'écran
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Largeur de l'écran
  double get screenWidth => screenSize.width;
  
  /// Hauteur de l'écran
  double get screenHeight => screenSize.height;
  
  /// Vérifie si on est en mode portrait
  bool get isPortrait => screenHeight > screenWidth;
  
  /// Vérifie si on est en mode paysage
  bool get isLandscape => screenWidth > screenHeight;
  
  /// Padding de sécurité (encoche, barre de navigation, etc.)
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;
  
  /// Affiche un SnackBar
  void showSnackBar(String message, {Color? backgroundColor, Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
  
  /// Navigation simple
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  /// Pop
  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }
  
  /// Ferme le clavier
  void closeKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

/// Extensions sur List
extension ListExtensions<T> on List<T> {
  /// Retourne l'élément à l'index ou null si hors limites
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
  
  /// Divise la liste en chunks de taille n
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
  
  /// Retourne une liste sans doublons
  List<T> unique() {
    return toSet().toList();
  }
}

/// Extensions sur Color
extension ColorExtensions on Color {
  /// Éclaircit la couleur
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Assombrit la couleur
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Retourne la couleur en hex
  String toHex() {
    final argb = toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
