import 'package:dartz/dartz.dart';
import 'package:task_manager_app/core/failure/failure.dart';
import 'package:task_manager_app/dependency_injection.dart';
import 'package:task_manager_app/domain/entities/response/login_entity.dart';
import 'package:task_manager_app/infrastructure/source/abstract/auth_source.dart';

import '../../core/constants/shared_keys.dart';
import '../../core/utils/update_prefrences.dart';
import '../../domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthSource _authSource;

  AuthRepoImpl({required AuthSource authSource}) : _authSource = authSource;
  @override
  Future<Either<Failure, LoginEntity>> getUserDetails() async {
    try {
      final response = await _authSource.getUserDetails();
      return right(LoginEntity.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginEntity>> login(
      {required String username, required String password}) async {
    try {
      final response =
          await _authSource.login(username: username, password: password);
      updatingPrefrences(response);
      return right(LoginEntity.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> refresh() async {
    try {
      final response = await _authSource.refresh();
      if (response['refreshToken'] != null && response['token'] != null) {
        preferences.setString(
            SharedKeys.refreshToken, response['refreshToken']);
        preferences.setString(SharedKeys.accessToken, response['token']);
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
