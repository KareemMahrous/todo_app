import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';

import '../../domain/entities/request/todo_inputs.dart';

import '../../domain/entities/response/todo_entity.dart';
import '../../domain/repo/todo_repo.dart';

import '../contracts/todos_contracts.dart';

class AddTodoCommandImpl implements AddTodoCommand {
  final TodoRepo _repo;

  AddTodoCommandImpl({required TodoRepo repo}) : _repo = repo;
  @override
  Future<Either<Failure, TodoEntity>> call(AddTodoInputs params) {
      return _repo.addTodo(todo: params.todo, completed: params.completed);
  }
}
