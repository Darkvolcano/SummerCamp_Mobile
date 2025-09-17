import 'package:intl/intl.dart';

class PriceFormatter {
  static String format(int price) {
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)}đ";
  }
}
