import 'package:equatable/equatable.dart';

class LoginEntity with EquatableMixin {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String token;
  final String refreshToken;

  const LoginEntity({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    required this.token,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        gender,
        image,
        token,
        refreshToken
      ];

  LoginEntity copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? token,
    String? refreshToken,
  }) {
    return LoginEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    return LoginEntity(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      image: json['image'] as String?,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
