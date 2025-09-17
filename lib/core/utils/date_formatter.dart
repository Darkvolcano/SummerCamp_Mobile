import 'package:intl/intl.dart';

class DateFormatter {
  // Format full day time
  static String formatFull(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy HH:mm").format(dateTime);
  }

  // Format date
  static String formatDate(DateTime dateTime) {
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  // Format date from string
  static String formatFromString(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat("dd/MM/yyyy").format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }
}
