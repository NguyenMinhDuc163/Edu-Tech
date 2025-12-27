import 'package:intl/intl.dart';

extension CurrencyExtension on num {
  String formatCurrency() {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(this)} ₫';
  }
}

extension StringCurrencyExtension on String? {
  String formatCurrency() {
    if (this == null || this!.isEmpty) return '0 ₫';
    final value = double.tryParse(this!) ?? 0;
    return value.formatCurrency();
  }
}
