import 'package:dartz/dartz.dart';
import 'package:fastshop_mobile/core/error/failures.dart';
import 'package:fastshop_mobile/features/auth/domain/entities/user.dart';
import 'package:fastshop_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:fastshop_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  const tUser = User(
    id: '1',
    name: 'Yona',
    email: 'yona@mail.com',
    role: 'user',
  );
  const tParams = LoginParams(email: 'yona@mail.com', password: 'secret123');

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('mengembalikan User saat repository berhasil', () async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    final result = await useCase(tParams);

    expect(result, const Right<Failure, User>(tUser));
    verify(
      () => repository.login(email: 'yona@mail.com', password: 'secret123'),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('meneruskan Failure dari repository', () async {
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await useCase(tParams);

    expect(result, const Left<Failure, User>(NetworkFailure()));
  });
}
