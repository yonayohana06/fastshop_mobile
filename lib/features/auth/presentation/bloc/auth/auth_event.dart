part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Dikirim sekali saat app start untuk memulihkan sesi.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Dikirim setelah login/register berhasil.
final class AuthUserAuthenticated extends AuthEvent {
  const AuthUserAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Dikirim internal saat server membalas 401 pada request terautentikasi.
final class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}
