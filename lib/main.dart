import 'package:flutter/material.dart';
import 'package:my_todo_app/app.dart';
import 'package:my_todo_app/hive/hive_todos_api/hive_todos_api.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveTodosApi.initHive();

  runApp(
    App(
      todosRepository: TodosRepository(
        todosApi: HiveTodosApi(),
      ),
    ),
  );
}
