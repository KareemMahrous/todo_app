import 'package:task_manager_app/core/constants/urls.dart';

import '../../../../core/constants/shared_keys.dart';
import '../../../../core/dio/base_dio.dart';
import '../../../../dependency_injection.dart';
import '../../abstract/todo_source.dart';

/// A class responsible for interacting with the remote source of todo data.
class TodoRemoteSourceImpl extends TodoRemoteSource {
  /// The Dio client used for making HTTP requests.
  final BaseDio _dioClient;

  /// Constructs a new instance of [TodoRemoteSourceImpl] with the provided Dio client.
  TodoRemoteSourceImpl({required BaseDio dioClient}) : _dioClient = dioClient;

  /// Retrieves todos from the remote data source with pagination support.
  ///
  /// Returns a [Future] containing a map representing the retrieved todos.
  ///
  /// Throws an error if there's an issue retrieving the todos.
  @override
  Future<Map<String, dynamic>> getTodos({int? limit, String? skip}) async {
    try {
      final response =
          await _dioClient.get("${Urls.todosEndpoint}?limit=$limit&skip=$skip");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Adds a new todo to the remote data source.
  ///
  /// Returns a [Future] containing a map representing the added todo.
  ///
  /// Throws an error if there's an issue adding the todo.
  @override
  Future<Map<String, dynamic>> addTodo(
      {required String todo, required bool completed}) async {
    try {
      final response = await _dioClient.post(Urls.addTodoEndpoint, data: {
        "todo": todo,
        "completed": completed,
        "userId": preferences.getString(SharedKeys.userId) ?? "",
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves a random todo from the remote data source.
  ///
  /// Returns a [Future] containing a map representing the retrieved todo.
  ///
  /// Throws an error if there's an issue retrieving the random todo.
  @override
  Future<Map<String, dynamic>> getRandomTodo() async {
    try {
      final response = await _dioClient.get(Urls.getRandomTodoEndpoint);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves a todo by its ID from the remote data source.
  ///
  /// Returns a [Future] containing a map representing the retrieved todo.
  ///
  /// Throws an error if there's an issue retrieving the todo.
  @override
  Future<Map<String, dynamic>> getTodoById({required String id}) async {
    try {
      final response = await _dioClient.get("${Urls.todosEndpoint}/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a todo by its ID from the remote data source.
  ///
  /// Returns a [Future] containing a map representing the deleted todo.
  ///
  /// Throws an error if there's an issue deleting the todo.
  @override
  Future<Map<String, dynamic>> deleteTodo({required String id}) async {
    try {
      final response = await _dioClient.delete("${Urls.todosEndpoint}/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Updates a todo by its ID in the remote data source.
  ///
  /// Returns a [Future] containing a map representing the updated todo.
  ///
  /// Throws an error if there's an issue updating the todo.
  @override
  Future<Map<String, dynamic>> updateTodo(
      {required String id,
      required String todo,
      required bool completed}) async {
    try {
      final response = await _dioClient.put("${Urls.todosEndpoint}/$id", data: {
        "completed": completed,
        "todo": todo,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
