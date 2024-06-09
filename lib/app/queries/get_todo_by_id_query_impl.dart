import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../../domain/entities/response/todo_entity.dart';
import '../../domain/repo/todo_repo.dart';
import '../contracts/todos_contracts.dart';

class GetTodoByIdQueryImpl implements GetTodoByIdQuery {
  final TodoRepo _repo;

  const GetTodoByIdQueryImpl({required TodoRepo repo}) : _repo = repo;
  @override
  Future<Either<Failure, TodoEntity>> call(String id) {
    return _repo.getTodoById(id: id);
  }
}
