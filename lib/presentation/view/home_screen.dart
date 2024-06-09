import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/shared_keys.dart';
import '../../core/extensions/text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/show_snack_bar.dart';
import '../../dependency_injection.dart';
import '../../domain/entities/request/todo_inputs.dart';
import '../manager/todo/todo_bloc.dart';
import '../widgets/add_todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    checkInternetConnectivity();
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    if (currentScroll >= (maxScroll * 0.70)) {
      context.read<TodoBloc>().add(const GetTodosEvent());
    }
  }

  bool hasInternet = false;
  Future<void> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        hasInternet = true;
      });
    } else {
      setState(() {
        hasInternet = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                context.read<TodoBloc>().add(const GetRandomTodoEvent());
                final randomId =
                    ((context.read<TodoBloc>().state as SuccessState).todo!.id);
                Future.delayed(const Duration(seconds: 3), () {
                  context.goNamed(Routes.taskDetails,
                      pathParameters: {'id': randomId.toString()});
                });
              },
              child: const Icon(Icons.shuffle),
            ),
            FloatingActionButton(
              onPressed: () {
                showAdaptiveDialog(
                    context: context,
                    builder: (_) {
                      return AddNewTodoDialog(
                        onPressed: (isCompleted) {
                          context.read<TodoBloc>().add(AddTodoEvent(
                                addTodoInputs: AddTodoInputs(
                                    todo: _controller.text,
                                    completed: isCompleted),
                              ));
                          _controller.clear();
                          context.pop(context);
                        },
                        controller: _controller,
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: AppColors.lightGreen,
          child: Column(children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${AppStrings.hello}${preferences.getString(SharedKeys.name)!}",
                          style: context.titleLarge,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () => context.goNamed(Routes.login),
                        icon: const Icon(Icons.logout))
                  ],
                ),
              ),
            ),
            BlocConsumer<TodoBloc, TodoState>(listener: (context, state) {
              if (state is SuccessState) {
                state.isAdded
                    ? ShowSnackbar.showCheckTopSnackBar(
                        context,
                        text: AppStrings.todoAddedSuccessfully,
                        type: SnackBarType.success,
                      )
                    : state.isDeleted
                        ? ShowSnackbar.showCheckTopSnackBar(
                            context,
                            text: AppStrings.todoDeletedSuccessfully,
                            type: SnackBarType.success,
                          )
                        : null;
              }
            }, builder: (context, state) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: switch (state) {
                  LoadingState() =>
                    const Center(child: CircularProgressIndicator()),
                  SuccessState(:final todos, localTodos: final localTodos) =>
                    ListView.builder(
                      itemCount:
                          hasInternet ? todos.length : localTodos!.length,
                      controller: hasInternet ? scrollController : null,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              log("pressed #$index");
                              context.pushNamed(Routes.taskDetails,
                                  pathParameters: {
                                    'id': todos[index].id.toString()
                                  });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.blackColorOpacity,
                                        spreadRadius: 7,
                                        blurRadius: 7,
                                        offset: Offset(4, 7))
                                  ]),
                              child: ListTile(
                                title: Text(
                                  hasInternet
                                      ? todos[index].todo!
                                      : localTodos![index].todo!,
                                  style: context.titleMedium,
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      context.read<TodoBloc>().add(
                                          DeleteTodoEvent(
                                              id: todos[index].id.toString()));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: AppColors.redColor,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ErrorState() => Expanded(
                      child: Column(
                        children: [
                          const Text(AppStrings.somethingWentWrong),
                          ElevatedButton(
                              onPressed: () => context
                                  .read<TodoBloc>()
                                  .add(const GetTodosEvent()),
                              child: const Text("Click here to retry")),
                        ],
                      ),
                    )
                },
              );
            })
          ]),
        ));
  }
}
