part of 'todo_bloc.dart';

sealed class TodoState extends Equatable {
  const TodoState();
}

final class LoadingState extends TodoState {
  @override
  List<Object?> get props => [];
}

final class SuccessState extends TodoState {
  final List<TodoEntity> todos;
  final TodoEntity? todo;
  final List<TodoEntity>? localTodos;
  final bool isDeleted;
  final bool isUpdated;
  final bool isAdded;

  const SuccessState({
    this.localTodos,
    required this.todos,
    this.todo,
    this.isDeleted = false,
    this.isUpdated = false,
    this.isAdded = false,
  });

  @override
  List<Object?> get props => [
        todos,
        todo,
        isDeleted,
        isUpdated,
        isAdded,
      ];

  SuccessState copyWith({
    List<TodoEntity>? todos,
    TodoEntity? todo,
    bool? isDeleted,
    bool? isUpdated,
    bool? isAdded,
  }) {
    return SuccessState(
      todos: todos ?? this.todos,
      todo: todo ?? this.todo,
      isDeleted: isDeleted ?? this.isDeleted,
      isUpdated: isUpdated ?? this.isUpdated,
      isAdded: isAdded ?? this.isAdded,
    );
  }
}

final class ErrorState extends TodoState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
