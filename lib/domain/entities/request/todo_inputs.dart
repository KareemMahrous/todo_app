import 'package:equatable/equatable.dart';

class GetTodoInputs extends Equatable {
  final int limit;
  final String skip;

  const GetTodoInputs({required this.limit, required this.skip});

  @override
  List<Object?> get props => [limit, skip];
}

class AddTodoInputs extends Equatable {
  final String? id;
  final String todo;
  final bool completed;

  const AddTodoInputs({this.id, required this.todo, required this.completed});

  @override
  List<Object?> get props => [todo, completed, id];
}
