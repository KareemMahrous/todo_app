import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../../domain/repo/todo_repo.dart';
import '../contracts/todos_contracts.dart';

class DeleteTodoCommandImpl implements DeleteTodoCommand {
  final TodoRepo _repo;

  const DeleteTodoCommandImpl({required TodoRepo repo}) : _repo = repo;

  @override 
  Future<Either<Failure, bool>> call(String id) {
    return _repo.deleteTodo(id: id);
  }
}