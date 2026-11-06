part of 'register_bloc.dart';

final class RegisterState extends Equatable {
  const RegisterState({
    this.status = SubmissionStatus.initial,
    this.user,
    this.errorMessage,
  });

  final SubmissionStatus status;
  final User? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
