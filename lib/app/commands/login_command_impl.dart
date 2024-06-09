import 'package:dartz/dartz.dart';
import 'package:task_manager_app/domain/repo/auth_repo.dart';

import '../../core/failure/failure.dart';
import '../../domain/entities/request/login_inputs.dart';
import '../../domain/entities/response/login_entity.dart';
import '../contracts/auth_contracts.dart';

class LoginCommandImpl implements LoginCommand {
  final AuthRepo _authRepo;

  LoginCommandImpl({required AuthRepo authRepo}) : _authRepo = authRepo;
  @override
  Future<Either<Failure, LoginEntity>> call(LoginInputs inputs) async {
    return _authRepo.login(
        username: inputs.username, password: inputs.password);
  }
}
