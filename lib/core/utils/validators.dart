/// Validator form yang bisa dipakai ulang di `TextFormField.validator`.
class Validators {
  const Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value, {String field = 'Kolom ini'}) {
    if (value == null || value.trim().isEmpty) return '$field wajib diisi';
    return null;
  }

  static String? email(String? value) {
    final empty = required(value, field: 'Email');
    if (empty != null) return empty;
    if (!_emailRegex.hasMatch(value!.trim())) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    final empty = required(value, field: 'Password');
    if (empty != null) return empty;
    if (value!.length < minLength) return 'Password minimal $minLength karakter';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      final empty = required(value, field: 'Konfirmasi password');
      if (empty != null) return empty;
      if (value != original()) return 'Password tidak sama';
      return null;
    };
  }
}
