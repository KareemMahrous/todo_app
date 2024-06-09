abstract class TodoRemoteSource {
  Future<Map<String, dynamic>> getTodos({int? limit, String? skip});
  Future<Map<String, dynamic>> addTodo({
    required String todo,
    required bool completed,
  });
  Future<Map<String, dynamic>> deleteTodo({required String id});
  Future<Map<String, dynamic>> getTodoById({required String id});
  Future<Map<String, dynamic>> getRandomTodo();
  Future<Map<String, dynamic>> updateTodo(
      {required String id, required String todo, required bool completed});
}

abstract class TodoLocalSource {
  Future<Map<String, dynamic>> getTodos();
}
