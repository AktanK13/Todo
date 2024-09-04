import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/home/pages/home_page.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';
import 'package:my_todo_app/common/theme/theme.dart';

class App extends StatelessWidget {
  const App({required this.todosRepository, super.key});

  final TodosRepository todosRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todosRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlutterTodosTheme.light,
        darkTheme: FlutterTodosTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
