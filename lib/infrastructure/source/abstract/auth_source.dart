abstract class AuthSource {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  });

  Future<Map<String, dynamic>> getUserDetails();

  Future<Map<String, dynamic>> refresh();
}
