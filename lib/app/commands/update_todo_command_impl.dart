import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';

import '../../domain/entities/request/todo_inputs.dart';
import '../../domain/entities/response/todo_entity.dart';

import '../../domain/repo/todo_repo.dart';
import '../contracts/todos_contracts.dart';

class UpdateTodoCommandImpl implements UpdateTodoCommand {
  final TodoRepo _repo;

  const UpdateTodoCommandImpl({required TodoRepo repo}) : _repo = repo;
  @override
  Future<Either<Failure, TodoEntity>> call(AddTodoInputs inputs) {
    return _repo.updateTodo(
        id: inputs.id.toString(),
        todo: inputs.todo,
        completed: inputs.completed);
  }
}
