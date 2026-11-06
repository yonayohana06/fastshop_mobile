import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/submission_status.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUseCase loginUseCase})
      : _login = loginUseCase,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase _login;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState(status: SubmissionStatus.loading));

    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(
        LoginState(
          status: SubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(LoginState(status: SubmissionStatus.success, user: user)),
    );
  }
}
