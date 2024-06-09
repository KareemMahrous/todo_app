import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/dependency_injection.dart';

import '../../../app/contracts/todos_contracts.dart';
import '../../../core/constants/shared_keys.dart';
import '../../../core/utils/no_params_input.dart';
import '../../../domain/entities/request/todo_inputs.dart';
import '../../../domain/entities/response/todo_entity.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosQuery _getTodosQuery;
  final GetRandomTodoQuery _getRandomTodoQuery;
  final GetTodoByIdQuery _getTodoByIdQuery;
  final AddTodoCommand _addTodoCommand;
  final DeleteTodoCommand _deleteTodoCommand;
  final UpdateTodoCommand _updateTodoCommand;
  TodoBloc(
      {required GetTodosQuery getTodosQuery,
      required GetRandomTodoQuery getRandomTodoQuery,
      required GetTodoByIdQuery getTodoByIdQuery,
      required AddTodoCommand addTodoCommand,
      required DeleteTodoCommand deleteTodoCommand,
      required UpdateTodoCommand updateTodoCommand})
      : _updateTodoCommand = updateTodoCommand,
        _deleteTodoCommand = deleteTodoCommand,
        _addTodoCommand = addTodoCommand,
        _getTodoByIdQuery = getTodoByIdQuery,
        _getRandomTodoQuery = getRandomTodoQuery,
        _getTodosQuery = getTodosQuery,
        super(LoadingState()) {
    int lastIndex = 0;
    on<GetTodosEvent>(
      (event, emit) async {
        emit(LoadingState());

        final List<TodoEntity> oldTodos =
            (state is SuccessState) ? (state as SuccessState).todos : [];
        final result = await _getTodosQuery
            .call(GetTodoInputs(limit: 20, skip: lastIndex.toString()));
        await result
            .fold((failure) async => emit(ErrorState(message: failure.message)),
                (todos) async {
          final localTodos = preferences.getString(SharedKeys.todos)!;
          final Map<String, dynamic> decode = await jsonDecode(localTodos);
          final allLocalTodos = (decode["todos"] as List)
              .map((e) => TodoEntity.fromJson(e))
              .toList();
          if (oldTodos.isNotEmpty) {
            final fetchedTodos = [
              ...oldTodos,
              ...todos,
            ];
            lastIndex = fetchedTodos.length;

            emit(SuccessState(todos: fetchedTodos, localTodos: allLocalTodos));
          } else {
            emit(SuccessState(todos: todos, localTodos: allLocalTodos));
            lastIndex = todos.length;
          }
        });
      },
      transformer: sequential(),
    );
    on<AddTodoEvent>(_addTodo);
    on<DeleteTodoEvent>(_deleteTodo);
    on<UpdateTodoEvent>(_updateTodo);
    on<GetRandomTodoEvent>(_getRandomTodo);
    on<GetTodoByIdEvent>(_getTodoById);
  }

  FutureOr<void> _addTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final result = await _addTodoCommand.call(event.addTodoInputs);
    result.fold((failure) => emit(ErrorState(message: failure.message)),
        (todo) async {
      if (state is SuccessState) {
        emit((state as SuccessState).copyWith(isAdded: true));
        await Future.delayed(const Duration(seconds: 2), () async {
          await _getTodosQuery.call(const GetTodoInputs(skip: "0", limit: 10));
        });
      } else {
        emit(const ErrorState(message: "Something went wrong"));
      }
    });
  }

  FutureOr<void> _deleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    final result = await _deleteTodoCommand.call(event.id);
    result.fold((failure) => emit(ErrorState(message: failure.message)),
        (isDeleted) async {
      if (state is SuccessState) {
        emit((state as SuccessState).copyWith(isDeleted: true));
        await Future.delayed(const Duration(seconds: 2), () async {
          await _getTodosQuery.call(const GetTodoInputs(skip: "0", limit: 20));
        });
      } else {
        emit(const ErrorState(message: "Something went wrong"));
      }
    });
  }

  FutureOr<void> _updateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    final result = await _updateTodoCommand.call(AddTodoInputs(
        id: event.id, todo: event.todo, completed: event.completed));
    result.fold((failure) => emit(ErrorState(message: failure.message)),
        (isUpdated) async {
      if (state is SuccessState) {
        emit((state as SuccessState).copyWith(isUpdated: true));
        await Future.delayed(const Duration(seconds: 2), () async {
          await _getTodosQuery.call(const GetTodoInputs(skip: "0", limit: 10));
        });
      } else {
        emit(const ErrorState(message: "Something went wrong"));
      }
    });
  }

  FutureOr<void> _getRandomTodo(
      GetRandomTodoEvent event, Emitter<TodoState> emit) async {
    final result = await _getRandomTodoQuery.call(NoParams());
    result.fold((failure) => emit(ErrorState(message: failure.message)),
        (todo) async {
      emit((state as SuccessState).copyWith(todo: todo));
    });
  }

  FutureOr<void> _getTodoById(
      GetTodoByIdEvent event, Emitter<TodoState> emit) async {
    final result = await _getTodoByIdQuery.call(event.id);
    result.fold((failure) => emit(ErrorState(message: failure.message)),
        (todo) async {
      emit((state as SuccessState).copyWith(todo: todo));
    });
  }
}
