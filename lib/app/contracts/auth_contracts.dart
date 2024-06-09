import 'package:dartz/dartz.dart';
import 'package:task_manager_app/core/utils/base_contract.dart';
import 'package:task_manager_app/core/utils/no_params_input.dart';
import 'package:task_manager_app/domain/entities/request/login_inputs.dart';

import '../../core/failure/failure.dart';
import '../../domain/entities/response/login_entity.dart';

abstract class LoginCommand
    extends BaseCommand<Future<Either<Failure, LoginEntity>>, LoginInputs> {}

abstract class GetUserDetailsCommand
    extends BaseCommand<Future<Either<Failure, LoginEntity>>, NoParams> {}
