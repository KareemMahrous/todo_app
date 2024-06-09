import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../app/contracts/auth_contracts.dart';
import '../../../domain/entities/request/login_inputs.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

//Creating bloc using freezed package
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginCommand _loginQuery;
  AuthBloc({
    required LoginCommand loginQuery,
  })  : _loginQuery = loginQuery,
        super(const AuthState.intial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        // Login Event
        login: (value) async {
          emit(const AuthState.loading());
          final result = await _loginQuery(LoginInputs(
            username: value.username,
            password: value.password,
          ));
          result.fold(
            (l) => emit(AuthState.failure(l.message)),
            (r) => emit(const AuthState.success()),
          );
        },
      );
    });
  }
}
