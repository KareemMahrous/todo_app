import '../../core/failure/failure.dart';
import '../entities/response/todo_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepo {
  Future<Either<Failure, TodoEntity>> getTodoById({required String id});
  Future<Either<Failure, List<TodoEntity>>> getTodos(
      {int? limit, String? skip});
  Future<Either<Failure, TodoEntity>> addTodo(
      {required String todo, required bool completed});
  Future<Either<Failure, bool>> deleteTodo({required String id});
  Future<Either<Failure, TodoEntity>> updateTodo(
      {required String id, required String todo, required bool completed});
  Future<Either<Failure, TodoEntity>> getRandomTodo();
}
