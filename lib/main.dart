import 'package:flutter/material.dart';
import 'package:task_manager_app/dependency_injection.dart';

import 'task_manager_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();
  runApp(const TaskManagerApp());
}
