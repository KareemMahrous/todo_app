import 'package:flutter/material.dart';
import 'package:task_manager_app/core/extensions/text_styles.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import 'text_form_fields.dart';

class AddNewTodoDialog extends StatefulWidget {
  const AddNewTodoDialog(
      {super.key, required this.controller, required this.onPressed});

  final Function(bool) onPressed;
  final TextEditingController controller;
  @override
  State<AddNewTodoDialog> createState() => _AddNewTodoDialogState();
}

class _AddNewTodoDialogState extends State<AddNewTodoDialog> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text(AppStrings.addNewTodo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormFieldCustom(
            maxLines: 5,
            controller: widget.controller,
            hintText: AppStrings.description,
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          Row(
            children: [
              Checkbox(
                value: _isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompleted = value!;
                  });
                },
              ),
              const Text(AppStrings.markAsCompleted),
            ],
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          ElevatedButton(
            onPressed: () => widget.onPressed.call(_isCompleted),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size(
                  MediaQuery.sizeOf(context).width * 0.9,
                  MediaQuery.sizeOf(context).width * 0.05,
                )),
            child: Text(AppStrings.submit,
                style: context.titleMedium.copyWith(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
