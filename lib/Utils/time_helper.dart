import 'package:intl/intl.dart';

class TimeHelper {
  static DateTime? stringToDate(String dateText) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parse(dateText);
      final now = DateTime.now();
      final start = DateTime(now.year - 100, now.month, now.day);
      final end = DateTime(now.year + 100, now.month, now.day);
      if (parsedDate.isBefore(start) || parsedDate.isAfter(end)) {
        return DateTime.now();
      }
      return parsedDate;
    } catch (e) {
      return null;
    }
  }

  static bool isValidDate(String date) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isPassDate(String date) {
    try {
      final inputDate = DateFormat('dd/MM/yyyy').parseStrict(date);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return inputDate.isBefore(today);
    } catch (e) {
      return false;
    }
  }

  static String convertDateFormat(String? inputDate, bool isHttpRquest) {
    if (inputDate == null || inputDate.isEmpty || inputDate == "--") return "";

    if (inputDate.contains("T")) {
      inputDate = inputDate.split("T")[0];
    }

    if (isHttpRquest) {
      final parts = inputDate.split('/');
      if (parts.length < 3) return "";
      final day = parts[0].padLeft(2, '0');
      final month = parts[1].padLeft(2, '0');
      final year = parts[2];
      return '$year-$month-$day';
    } else {
      final parts = inputDate.split('-');
      if (parts.length < 3) return "";
      final year = parts[0];
      final month = parts[1].padLeft(2, '0');
      final day = parts[2].padLeft(2, '0');
      return '$day/$month/$year';
    }
  }
}
