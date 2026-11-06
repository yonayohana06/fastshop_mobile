part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState._(this.status, [this.user]);

  const AuthState.unknown() : this._(AuthStatus.unknown);

  const AuthState.authenticated(User user)
      : this._(AuthStatus.authenticated, user);

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated);

  final AuthStatus status;
  final User? user;

  @override
  List<Object?> get props => [status, user];
}
