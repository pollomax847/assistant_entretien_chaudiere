import 'package:intl/intl.dart';

/// Helper pour la gestion des dates
class DateHelper {
  // Formats de date couramment utilisés
  static final DateFormat _shortFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _longFormat = DateFormat('dd MMMM yyyy', 'fr_FR');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'fr_FR');
  static final DateFormat _isoFormat = DateFormat('yyyy-MM-dd');
  
  /// Formate une date au format court (dd/MM/yyyy)
  static String formatShort(DateTime date) => _shortFormat.format(date);
  
  /// Formate une date au format long (dd MMMM yyyy)
  static String formatLong(DateTime date) => _longFormat.format(date);
  
  /// Formate une heure (HH:mm)
  static String formatTime(DateTime date) => _timeFormat.format(date);
  
  /// Formate une date et heure (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);
  
  /// Formate au format mois année (MMMM yyyy)
  static String formatMonthYear(DateTime date) => _monthYearFormat.format(date);
  
  /// Formate au format ISO (yyyy-MM-dd)
  static String formatISO(DateTime date) => _isoFormat.format(date);
  
  /// Parse une date au format dd/MM/yyyy
  static DateTime? parseShort(String dateString) {
    try {
      return _shortFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  /// Parse une date au format ISO (yyyy-MM-dd)
  static DateTime? parseISO(String dateString) {
    try {
      return _isoFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  /// Retourne true si la date est aujourd'hui
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
  
  /// Retourne true si la date est hier
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }
  
  /// Retourne true si la date est demain
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
  
  /// Retourne une chaîne relative (Aujourd'hui, Hier, ou la date)
  static String formatRelative(DateTime date) {
    if (isToday(date)) return 'Aujourd\'hui';
    if (isYesterday(date)) return 'Hier';
    if (isTomorrow(date)) return 'Demain';
    return formatShort(date);
  }
  
  /// Calcule la différence en jours entre deux dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
  
  /// Calcule l'âge à partir d'une date de naissance
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  /// Retourne le premier jour du mois
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  /// Retourne le dernier jour du mois
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
  
  /// Retourne true si l'année est bissextile
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
  
  /// Retourne le nombre de jours dans un mois
  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
  
  /// Ajoute des jours ouvrés (lundi-vendredi)
  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var daysToAdd = days.abs();
    var increment = days > 0 ? 1 : -1;
    
    while (daysToAdd > 0) {
      result = result.add(Duration(days: increment));
      // Saute les week-ends (6 = samedi, 7 = dimanche)
      if (result.weekday < 6) {
        daysToAdd--;
      }
    }
    
    return result;
  }
}
