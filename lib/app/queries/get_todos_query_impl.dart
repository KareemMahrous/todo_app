import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';

import '../../domain/entities/request/todo_inputs.dart';

import '../../domain/entities/response/todo_entity.dart';

import '../../domain/repo/todo_repo.dart';
import '../contracts/todos_contracts.dart';

class GetTodosQueryImpl implements GetTodosQuery {
  final TodoRepo _repo;

  const GetTodosQueryImpl({required TodoRepo repo}) : _repo = repo;
  @override
  Future<Either<Failure, List<TodoEntity>>> call(GetTodoInputs params) {
    return _repo.getTodos(limit: params.limit, skip: params.skip);
  }
}
