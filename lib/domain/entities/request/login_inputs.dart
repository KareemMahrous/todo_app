import 'package:equatable/equatable.dart';

class LoginInputs extends Equatable {
  final String username;
  final String password;

  const LoginInputs({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
