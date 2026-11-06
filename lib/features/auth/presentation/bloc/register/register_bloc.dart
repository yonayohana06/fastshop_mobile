import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/submission_status.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterUseCase registerUseCase})
      : _register = registerUseCase,
        super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  final RegisterUseCase _register;

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState(status: SubmissionStatus.loading));

    final result = await _register(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(
        RegisterState(
          status: SubmissionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) =>
          emit(RegisterState(status: SubmissionStatus.success, user: user)),
    );
  }
}
