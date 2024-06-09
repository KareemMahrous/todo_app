import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/core/extensions/text_styles.dart';
import 'package:task_manager_app/presentation/widgets/text_form_fields.dart';

import '../../core/theme/app_colors.dart';
import '../manager/todo/todo_bloc.dart';

class TodoDetailsScreen extends StatefulWidget {
  final int id;

  const TodoDetailsScreen({super.key, required this.id});

  @override
  State<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  late TextEditingController _todoController;
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(GetTodoByIdEvent(id: widget.id.toString()));
    _todoController = TextEditingController();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) => switch (state) {
                  LoadingState() =>
                    const Center(child: CircularProgressIndicator()),
                  SuccessState(todo: final todo) => FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 1)),
                      builder: (context, snapshot) => snapshot
                                  .connectionState ==
                              ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${widget.id}',
                                    style: const TextStyle(fontSize: 20)),
                                SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.02),
                                Text('Description: ${todo?.todo ?? "None"}',
                                    style: const TextStyle(fontSize: 18)),
                                SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.02),
                                TextFormFieldCustom(
                                    controller: _todoController,
                                    maxLines: 5,
                                    hintText: AppStrings.description),
                                SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.02),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      fixedSize: Size(
                                        MediaQuery.sizeOf(context).width * 0.9,
                                        MediaQuery.sizeOf(context).height *
                                            0.08,
                                      )),
                                  onPressed: () {
                                    context.read<TodoBloc>().add(
                                        UpdateTodoEvent(
                                            completed: false,
                                            id: widget.id.toString(),
                                            todo: _todoController.text));
                                    _todoController.clear();
                                  },
                                  child: Text(
                                    AppStrings.update,
                                    style: context.titleMedium
                                        .copyWith(color: AppColors.white),
                                  ),
                                )
                              ],
                            ),
                    ),
                  ErrorState(:final message) => Text(message)
                }),
      ),
    );
  }
}
