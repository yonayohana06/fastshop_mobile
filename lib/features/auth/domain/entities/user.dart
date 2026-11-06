import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
  });

  final String id;
  final String name;
  final String email;

  /// Peran dari backend, mis. `user`. Admin tidak bisa login di app ini.
  final String role;

  /// Hanya terisi dari `GET /auth/me`; tidak ada di respons login.
  final String? phoneNumber;

  @override
  List<Object?> get props => [id, name, email, role, phoneNumber];
}
