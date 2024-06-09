import '../../../core/constants/urls.dart';
import '../../../core/dio/base_dio.dart';
import '../abstract/todo_source.dart';

/// A class responsible for interacting with the local source of todo data.
class TodoLocalSourceImpl implements TodoLocalSource {
  /// The Dio client used for making HTTP requests.
  final BaseDio _dioClient;

  /// Constructs a new instance of [TodoLocalSourceImpl] with the provided Dio client.
  TodoLocalSourceImpl({required BaseDio dioClient}) : _dioClient = dioClient;

  /// Retrieves todos from the local data source.
  ///
  /// Returns a [Future] containing a map representing the todos.
  /// The keys in the map represent various todo properties such as id, todo, and completed.
  ///
  /// Throws an error if there's an issue retrieving the todos.
  @override
  Future<Map<String, dynamic>> getTodos() async {
    try {
      // Make an HTTP GET request to fetch todos
      final localResponse = await _dioClient.get(
        "${Urls.todosEndpoint}?limit=300&skip=0",
      );

      // Return the data from the response
      return localResponse.data;
    } catch (e) {
      // Re-throw the caught error to be handled by the caller
      rethrow;
    }
  }
}
