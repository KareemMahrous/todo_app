import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/constants/shared_keys.dart';
import '../../core/failure/failure.dart';
import '../../dependency_injection.dart';
import '../../domain/entities/response/todo_entity.dart';
import '../../domain/repo/todo_repo.dart';
import '../source/abstract/todo_source.dart';

class TodoRepoImpl implements TodoRepo {
  final TodoRemoteSource _remoteSource;
  final TodoLocalSource _localSource;

  const TodoRepoImpl(
      {required TodoRemoteSource remoteSource,
      required TodoLocalSource localSource})
      : _remoteSource = remoteSource,
        _localSource = localSource;
  @override
  Future<Either<Failure, TodoEntity>> addTodo(
      {required String todo, required bool completed}) async {
    try {
      final response =
          await _remoteSource.addTodo(todo: todo, completed: completed);

      return right(TodoEntity.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTodo({required String id}) async {
    try {
      final response = await _remoteSource.deleteTodo(id: id);
      return response['isDeleted']
          ? const Right(true)
          : const Left(ServerFailure("Something went wrong"));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> getRandomTodo() async {
    try {
      final response = await _remoteSource.getRandomTodo();
      return right(TodoEntity.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> getTodoById({required String id}) async {
    try {
      final response = await _remoteSource.getTodoById(id: id);
      return right(TodoEntity.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos(
      {int? limit, String? skip}) async {
    try {
      final response = await _remoteSource.getTodos(limit: limit, skip: skip);
      final localResponse = await _localSource.getTodos();

      preferences.setString(SharedKeys.todos, jsonEncode(localResponse));
      return (response['todos'] as List<dynamic>).isNotEmpty
          ? Right((response['todos'] as List<dynamic>)
              .map((e) => TodoEntity.fromJson(e))
              .toList())
          : const Left(NotFoundFailure("There's no Todos"));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> updateTodo(
      {required String id,
      required String todo,
      required bool completed}) async {
    try {
      final response = await _remoteSource.updateTodo(
          id: id, todo: todo, completed: completed);
      return right(TodoEntity.fromJson(response));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
