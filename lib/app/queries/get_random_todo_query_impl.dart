import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../../core/utils/no_params_input.dart';
import '../../domain/entities/response/todo_entity.dart';
import '../../domain/repo/todo_repo.dart';
import '../contracts/todos_contracts.dart';

class GetRandomTodoQueryImpl implements GetRandomTodoQuery {
  final TodoRepo _repo;

  const GetRandomTodoQueryImpl({required TodoRepo repo}) : _repo = repo;
  @override
  Future<Either<Failure, TodoEntity>> call(NoParams params) {
    return _repo.getRandomTodo();
  }
}
