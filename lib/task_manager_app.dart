import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/routes/go_routes.dart';
import 'dependency_injection.dart';
import 'presentation/manager/auth/auth_bloc.dart';
import 'presentation/manager/todo/todo_bloc.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc(
            getTodosQuery: getIt(),
            getRandomTodoQuery: getIt(),
            getTodoByIdQuery: getIt(),
            addTodoCommand: getIt(),
            deleteTodoCommand: getIt(),
            updateTodoCommand: getIt(),
          )..add(const GetTodosEvent()),
        ),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: allRoutes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
