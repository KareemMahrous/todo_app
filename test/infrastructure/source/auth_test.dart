import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/core/constants/urls.dart';
import 'package:task_manager_app/core/constants/shared_keys.dart';
import 'package:task_manager_app/core/dio/base_dio.dart';
import 'package:task_manager_app/dependency_injection.dart';
import 'package:task_manager_app/infrastructure/source/implementation/remote_sources/auth_remote_source_impl.dart';

// Mock classes
class MockBaseDio extends Mock implements BaseDio {}

class MockPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthSourceImpl authSource;
  late MockBaseDio mockBaseDio;
  late MockPreferences mockPreferences;

  setUp(() {
    mockBaseDio = MockBaseDio();
    mockPreferences = MockPreferences();
    authSource = AuthSourceImpl(dioClient: mockBaseDio);

    // Ensure the preferences singleton is correctly mocked
    preferences = mockPreferences;
  });

  group('AuthSourceImpl', () {
    const username = 'testUser';
    const password = 'testPassword';

    test('login should return user data on successful login', () async {
      // Arrange
      final loginData = {
        'username': username,
        'password': password,
        'expiresInMins': 60,
      };

      final expectedResponse = {'token': 'testToken'};
      final response = Response(
        requestOptions: RequestOptions(path: Urls.loginEndpoint),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.post(Urls.loginEndpoint, data: loginData))
          .thenAnswer((_) async => response);

      // Act
      final result =
          await authSource.login(username: username, password: password);

      // Assert
      expect(result, expectedResponse);
      verify(() => mockBaseDio.post(Urls.loginEndpoint, data: loginData))
          .called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('getUserDetails should return user data', () async {
      // Arrange
      final expectedResponse = {'id': 'testUserId', 'name': 'testUser'};
      final response = Response(
        requestOptions: RequestOptions(path: Urls.meEndpoint),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.get(Urls.meEndpoint))
          .thenAnswer((_) async => response);

      // Act
      final result = await authSource.getUserDetails();

      // Assert
      expect(result, expectedResponse);
      verify(() => mockBaseDio.get(Urls.meEndpoint)).called(1);
      verifyNoMoreInteractions(mockBaseDio);
    });

    test('refresh should return new token', () async {
      // Arrange
      const refreshToken = 'testRefreshToken';
      when(() => mockPreferences.getString(SharedKeys.refreshToken))
          .thenReturn(refreshToken);

      final refreshData = {
        'refreshToken': refreshToken,
        'expiresInMins': 60,
      };

      final expectedResponse = {'token': 'newTestToken'};
      final response = Response(
        requestOptions: RequestOptions(path: Urls.refreshEndpoint),
        data: expectedResponse,
        statusCode: 200,
      );

      when(() => mockBaseDio.post(Urls.refreshEndpoint, data: refreshData))
          .thenAnswer((_) async => response);

      // Act
      final result = await authSource.refresh();

      // Assert
      expect(result, expectedResponse);
      verify(() => mockPreferences.getString(SharedKeys.refreshToken))
          .called(1);
      verify(() => mockBaseDio.post(Urls.refreshEndpoint, data: refreshData))
          .called(1);
      verifyNoMoreInteractions(mockBaseDio);
      verifyNoMoreInteractions(mockPreferences);
    });
  });
}
