import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/core/constants/shared_keys.dart';
import 'package:task_manager_app/core/constants/urls.dart';
import 'package:task_manager_app/core/dio/base_dio.dart';
import 'package:task_manager_app/dependency_injection.dart';
import 'package:task_manager_app/infrastructure/source/abstract/todo_source.dart';
import 'package:task_manager_app/infrastructure/source/implementation/remote_sources/todo_remote_source_impl.dart';

// Mock classes
class MockBaseDio extends Mock implements BaseDio {}

class MockPreferences extends Mock implements SharedPreferences {}

void main() {
  late TodoRemoteSource todoRemoteSource;
  late MockBaseDio mockBaseDio;
  late MockPreferences mockPreferences;

  setUp(() {
    mockBaseDio = MockBaseDio();
    mockPreferences = MockPreferences();
    todoRemoteSource = TodoRemoteSourceImpl(dioClient: mockBaseDio);

    // Ensure the preferences singleton is correctly mocked
    preferences = mockPreferences;
  });

  group('TodoRemoteSourceImpl', () {
    test('getTodos should return todos data', () async {
      // Arrange
      const limit = 10;
      const skip = '0';
      final expectedResponse = {'data': 'testTodos'};
      final response = Response(
        requestOptions: RequestOptions(
            path: "${Urls.todosEndpoint}?limit=$limit&skip=$skip"),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() =>
              mockBaseDio.get("${Urls.todosEndpoint}?limit=$limit&skip=$skip"))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRemoteSource.getTodos(limit: limit, skip: skip);

      // Assert
      expect(result, expectedResponse);
      verify(() =>
              mockBaseDio.get("${Urls.todosEndpoint}?limit=$limit&skip=$skip"))
          .called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('addTodo should add new todo and return data', () async {
      // Arrange
      const todo = 'testTodo';
      const completed = false;
      const userId = 'testUserId';

      when(() => mockPreferences.getString(SharedKeys.userId))
          .thenReturn(userId);

      final expectedResponse = {'data': 'addedTodo'};
      final response = Response(
        requestOptions: RequestOptions(path: Urls.addTodoEndpoint),
        data: expectedResponse,
        statusCode: 200,
      );

      final postData = {
        "todo": todo,
        "completed": completed,
        "userId": userId,
      };

      when(() => mockBaseDio.post(Urls.addTodoEndpoint, data: postData))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRemoteSource.addTodo(
        todo: todo,
        completed: completed,
      );

      // Assert
      expect(result, expectedResponse);
      verify(() => mockPreferences.getString(SharedKeys.userId)).called(1);
      verify(() => mockBaseDio.post(Urls.addTodoEndpoint, data: postData))
          .called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('getRandomTodo should return random todo data', () async {
      // Arrange
      final expectedResponse = {'data': 'randomTodo'};
      final response = Response(
        requestOptions: RequestOptions(path: Urls.getRandomTodoEndpoint),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.get(Urls.getRandomTodoEndpoint))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRemoteSource.getRandomTodo();

      // Assert
      expect(result, expectedResponse);
      verify(() => mockBaseDio.get(Urls.getRandomTodoEndpoint)).called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('getTodoById should return todo data by id', () async {
      // Arrange
      const id = 'testId';
      final expectedResponse = {'data': 'todoById'};
      final response = Response(
        requestOptions: RequestOptions(path: "${Urls.todosEndpoint}/$id"),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.get("${Urls.todosEndpoint}/$id"))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRemoteSource.getTodoById(id: id);

      // Assert
      expect(result, expectedResponse);
      verify(() => mockBaseDio.get("${Urls.todosEndpoint}/$id")).called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('deleteTodo should delete todo by id and return data', () async {
      // Arrange
      const id = 'testId';
      final expectedResponse = {'data': 'deletedTodo'};
      final response = Response(
        requestOptions: RequestOptions(path: "${Urls.todosEndpoint}/$id"),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.delete("${Urls.todosEndpoint}/$id"))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRemoteSource.deleteTodo(id: id);

      // Assert
      expect(result, expectedResponse);
      verify(() => mockBaseDio.delete("${Urls.todosEndpoint}/$id")).called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('updateTodo should update todo by id and return data', () async {
      // Arrange
      const id = 'testId';
      final expectedResponse = {'data': 'updatedTodo'};
      final response = Response(
        requestOptions: RequestOptions(path: "${Urls.todosEndpoint}/$id"),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.put("${Urls.todosEndpoint}/$id"))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRemoteSource.updateTodo(
          id: id, completed: false, todo: 'testTodo');

      // Assert
      expect(result, expectedResponse);
      verify(() => mockBaseDio.put("${Urls.todosEndpoint}/$id")).called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });
  });
}
