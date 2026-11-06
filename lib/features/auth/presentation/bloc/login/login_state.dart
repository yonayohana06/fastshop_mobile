part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
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
