part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();
}

class AddTodoEvent extends TodoEvent {
  final AddTodoInputs addTodoInputs;
  const AddTodoEvent({required this.addTodoInputs});
  @override
  List<Object?> get props => [addTodoInputs];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  const DeleteTodoEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final String todo;
  final bool completed;
  const UpdateTodoEvent(
      {required this.todo, required this.completed, required this.id});
  @override
  List<Object?> get props => [id];
}

class GetTodosEvent extends TodoEvent {
  const GetTodosEvent();
  @override
  List<Object?> get props => [];
}

class GetRandomTodoEvent extends TodoEvent {
  const GetRandomTodoEvent();
  @override
  List<Object?> get props => [];
}

class GetTodoByIdEvent extends TodoEvent {
  final String id;
  const GetTodoByIdEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
