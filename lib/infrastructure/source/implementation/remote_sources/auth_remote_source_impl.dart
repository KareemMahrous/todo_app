import 'package:task_manager_app/core/constants/urls.dart';

import '../../../../core/constants/shared_keys.dart';
import '../../../../core/dio/base_dio.dart';
import '../../../../dependency_injection.dart';
import '../../abstract/auth_source.dart';

/// A class responsible for interacting with the authentication source.
class AuthSourceImpl implements AuthSource {
  /// The Dio client used for making HTTP requests.
  final BaseDio _dioClient;

  /// Constructs a new instance of [AuthSourceImpl] with the provided Dio client.
  AuthSourceImpl({required BaseDio dioClient}) : _dioClient = dioClient;

  /// Performs a login operation with the provided username and password.
  ///
  /// Returns a [Future] containing a map representing the response from the login operation.
  ///
  /// Throws an error if there's an issue during the login process.
  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(Urls.loginEndpoint, data: {
        'username': username,
        'password': password,
        'expiresInMins': 60
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves details of the authenticated user.
  ///
  /// Returns a [Future] containing a map representing the user details.
  ///
  /// Throws an error if there's an issue retrieving the user details.
  @override
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      final response = await _dioClient.get(Urls.meEndpoint);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Refreshes the authentication token.
  ///
  /// Returns a [Future] containing a map representing the response from the token refresh operation.
  ///
  /// Throws an error if there's an issue during the token refresh process.
  @override
  Future<Map<String, dynamic>> refresh() async {
    try {
      final response = await _dioClient.post(Urls.refreshEndpoint, data: {
        'refreshToken': preferences.getString(SharedKeys.refreshToken) ?? "",
        'expiresInMins': 60
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
