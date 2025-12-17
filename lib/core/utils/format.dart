String formatNumber(num value, {int maxDecimal = 1}) {
  final fixed = value.toStringAsFixed(maxDecimal);
  return fixed.replaceFirst(RegExp(r"\.0$"), '');
}

String formatCurrency(num value, {int maxDecimal = 1}) {
  return '¥${formatNumber(value, maxDecimal: maxDecimal)}';
}

String formatDiscount(num value) {
  return '${formatNumber(value, maxDecimal: 1)}折';
}

String formatScore(num value) {
  return formatNumber(value, maxDecimal: 1);
}
