import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../entities/response/login_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginEntity>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, bool>> refresh();

  Future<Either<Failure, LoginEntity>> getUserDetails();
}
