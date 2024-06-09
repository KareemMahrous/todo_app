import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/infrastructure/source/implementation/todo_local_source_impl.dart';

import 'app/commands/add_todo_command_impl.dart';
import 'app/commands/delete_todo_command_impl.dart';
import 'app/commands/login_command_impl.dart';
import 'app/commands/update_todo_command_impl.dart';
import 'app/contracts/auth_contracts.dart';
import 'app/contracts/todos_contracts.dart';
import 'app/queries/get_random_todo_query_impl.dart';
import 'app/queries/get_todo_by_id_query_impl.dart';
import 'app/queries/get_todos_query_impl.dart';
import 'core/constants/urls.dart';
import 'core/dio/base_dio.dart';
import 'core/dio/dio_client.dart';
import 'core/dio/dio_interceptor.dart';
import 'domain/repo/auth_repo.dart';
import 'domain/repo/todo_repo.dart';
import 'infrastructure/repo/auth_repo_impl.dart';
import 'infrastructure/repo/todo_repo_impl.dart';
import 'infrastructure/source/abstract/auth_source.dart';
import 'infrastructure/source/abstract/todo_source.dart';
import 'infrastructure/source/implementation/remote_sources/auth_remote_source_impl.dart';
import 'infrastructure/source/implementation/remote_sources/todo_remote_source_impl.dart';
import 'presentation/manager/auth/auth_bloc.dart';
import 'presentation/manager/todo/todo_bloc.dart';

GetIt getIt = GetIt.instance;
SharedPreferences preferences = getIt<SharedPreferences>();

Future<void> initDependencyInjection() async {
  await registerSingletons();
  registerDataSources();
  registerRepositories();
  registerQueries();
  registerCommands();
  registerFactories();
}

// Register all Data Sources
void registerDataSources() {
  getIt.registerSingleton<TodoRemoteSource>(
      TodoRemoteSourceImpl(dioClient: getIt()));

  getIt.registerSingleton<TodoLocalSource>(
      TodoLocalSourceImpl(dioClient: getIt()));

  getIt.registerSingleton<AuthSource>(AuthSourceImpl(dioClient: getIt()));
}

// Register all Repos
void registerRepositories() {
  getIt.registerSingleton<TodoRepo>(TodoRepoImpl(
    remoteSource: getIt(),
    localSource: getIt(),
  ));

  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(authSource: getIt()));
}

// Register all Commands
void registerCommands() {
  getIt.registerSingleton<DeleteTodoCommand>(
      DeleteTodoCommandImpl(repo: getIt()));

  getIt.registerSingleton<AddTodoCommand>(AddTodoCommandImpl(repo: getIt()));

  getIt.registerSingleton<UpdateTodoCommand>(
      UpdateTodoCommandImpl(repo: getIt()));

  getIt.registerSingleton<LoginCommand>(LoginCommandImpl(authRepo: getIt()));
}

// Register all Queries
void registerQueries() {
  getIt.registerSingleton<GetTodosQuery>(GetTodosQueryImpl(repo: getIt()));

  getIt
      .registerSingleton<GetTodoByIdQuery>(GetTodoByIdQueryImpl(repo: getIt()));

  getIt.registerSingleton<GetRandomTodoQuery>(
      GetRandomTodoQueryImpl(repo: getIt()));
}

// Register all BloCs
void registerFactories() {
  getIt.registerFactory<AuthBloc>(() => AuthBloc(loginQuery: getIt()));

  getIt.registerFactory<TodoBloc>(() => TodoBloc(
      getTodosQuery: getIt(),
      getRandomTodoQuery: getIt(),
      getTodoByIdQuery: getIt(),
      addTodoCommand: getIt(),
      deleteTodoCommand: getIt(),
      updateTodoCommand: getIt()));
}

/// Register all Core singletons
Future<void> registerSingletons() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  BaseOptions options = BaseOptions(
    baseUrl: Urls.restBaseUrl,
    followRedirects: false,
    headers: {
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );

  /// Singleton register
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<BaseDio>(
    DioClient(
      options: options,
      dio: Dio(),
      interceptors: [DioInterceptor()],
    ),
  );
}
