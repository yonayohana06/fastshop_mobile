import 'user_model.dart';

/// Respons `POST /auth/login`:
/// ```json
/// {
///   "code": 200,
///   "message": "Login berhasil",
///   "data": {
///     "user": { "id": "2", "name": "...", "email": "...", "role": "user" },
///     "token": "<jwt>"
///   }
/// }
/// ```
/// Backend hanya mengirim satu `token` (tanpa refresh token).
class AuthResponseModel {
  const AuthResponseModel({required this.accessToken, required this.user});

  final String accessToken;
  final UserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponseModel(
      accessToken: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
