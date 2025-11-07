import 'package:intl/intl.dart';

class PriceFormatter {
  static String format(double price) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)}đ";
  }
}
