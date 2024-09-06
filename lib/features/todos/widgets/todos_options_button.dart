import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/todos/bloc/todos_bloc.dart';

@visibleForTesting
enum TodosOption { toggleAll, clearCompleted }

class TodosOptionsButton extends StatelessWidget {
  const TodosOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodosBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodosOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: "Options",
      onSelected: (options) {
        switch (options) {
          case TodosOption.toggleAll:
            context.read<TodosBloc>().add(const TodosToggleAllRequested());
          case TodosOption.clearCompleted:
            context.read<TodosBloc>().add(const TodosClearCompletedRequested());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? "Mark all as incomplete"
                  : "Mark all as completed",
            ),
          ),
          PopupMenuItem(
            value: TodosOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: const Text("Clear completed"),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
