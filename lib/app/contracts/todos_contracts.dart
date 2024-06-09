import 'package:dartz/dartz.dart';
import '../../domain/entities/request/todo_inputs.dart';

import '../../core/failure/failure.dart';
import '../../core/utils/base_contract.dart';
import '../../core/utils/no_params_input.dart';
import '../../domain/entities/response/todo_entity.dart';

abstract class GetTodosQuery extends BaseQuery<
    Future<Either<Failure, List<TodoEntity>>>, GetTodoInputs> {}

abstract class GetRandomTodoQuery
    extends BaseQuery<Future<Either<Failure, TodoEntity>>, NoParams> {}

abstract class GetTodoByIdQuery
    extends BaseQuery<Future<Either<Failure, TodoEntity>>, String> {}

abstract class AddTodoCommand
    extends BaseCommand<Future<Either<Failure, TodoEntity>>, AddTodoInputs> {}

abstract class DeleteTodoCommand
    extends BaseCommand<Future<Either<Failure, bool>>, String> {}

abstract class UpdateTodoCommand
    extends BaseCommand<Future<Either<Failure, TodoEntity>>, AddTodoInputs> {}
