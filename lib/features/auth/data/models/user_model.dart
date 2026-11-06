import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.phoneNumber,
  });

  /// `id` bisa berupa string (`"2"`, login/me) atau angka (`2`, register),
  /// jadi selalu dinormalisasi ke string.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: '${json['id']}',
      name: json['name'] as String,
      email: json['email'] as String,
      role: (json['role'] as String?) ?? 'user',
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'phone_number': phoneNumber,
      };
}
