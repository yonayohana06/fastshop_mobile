import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fastshop_mobile/core/error/failures.dart';
import 'package:fastshop_mobile/core/utils/submission_status.dart';
import 'package:fastshop_mobile/features/auth/domain/entities/user.dart';
import 'package:fastshop_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:fastshop_mobile/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;

  const tUser = User(
    id: '1',
    name: 'Yona',
    email: 'yona@mail.com',
    role: 'user',
  );
  const tParams = LoginParams(email: 'yona@mail.com', password: 'secret123');
  const tEvent = LoginSubmitted(email: 'yona@mail.com', password: 'secret123');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
  });

  blocTest<LoginBloc, LoginState>(
    'emit [loading, success] saat login berhasil',
    build: () {
      when(() => loginUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));
      return LoginBloc(loginUseCase: loginUseCase);
    },
    act: (bloc) => bloc.add(tEvent),
    expect: () => const [
      LoginState(status: SubmissionStatus.loading),
      LoginState(status: SubmissionStatus.success, user: tUser),
    ],
    verify: (_) => verify(() => loginUseCase(tParams)).called(1),
  );

  blocTest<LoginBloc, LoginState>(
    'emit [loading, failure] saat login gagal',
    build: () {
      when(() => loginUseCase(any())).thenAnswer(
        (_) async =>
            const Left(UnauthorizedFailure('Email atau password salah')),
      );
      return LoginBloc(loginUseCase: loginUseCase);
    },
    act: (bloc) => bloc.add(tEvent),
    expect: () => const [
      LoginState(status: SubmissionStatus.loading),
      LoginState(
        status: SubmissionStatus.failure,
        errorMessage: 'Email atau password salah',
      ),
    ],
  );
}
