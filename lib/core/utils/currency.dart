/// Format Rupiah: `formatRupiah(1250000)` → `Rp1.250.000`.
String formatRupiah(num amount) {
  final negative = amount < 0;
  final digits = amount.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}Rp$buffer';
}
