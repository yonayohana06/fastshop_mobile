import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/session_events.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_current_session_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc global untuk status sesi. Dipakai router untuk redirect
/// antara halaman publik (login/register) dan halaman terproteksi.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentSessionUseCase getCurrentSession,
    required LogoutUseCase logout,
    required SessionEvents sessionEvents,
  })  : _getCurrentSession = getCurrentSession,
        _logout = logout,
        super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthUserAuthenticated>(
      (event, emit) => emit(AuthState.authenticated(event.user)),
    );
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);

    _sessionSub = sessionEvents.onUnauthorized.listen(
      (_) => add(const AuthSessionExpired()),
    );
  }

  final GetCurrentSessionUseCase _getCurrentSession;
  final LogoutUseCase _logout;
  late final StreamSubscription<void> _sessionSub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _getCurrentSession(const NoParams());
    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status != AuthStatus.authenticated) return;
    await _logout(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _sessionSub.cancel();
    return super.close();
  }
}
