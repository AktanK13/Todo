import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/edit_todo/pages/edit_todo.dart';
import 'package:my_todo_app/features/todos/bloc/todos_bloc.dart';
import 'package:my_todo_app/features/todos/widgets/todos_search_button.dart';
import 'package:my_todo_app/features/todos/widgets/widgets.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosSubscriptionRequested()),
      child: const TodosView(),
    );
  }
}

class TodosView extends StatelessWidget {
  const TodosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        actions: const [
          TodosSearchButton(),
          TodosFilterButton(),
          TodosOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosBloc, TodosState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("An error occurred while loading todos."),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosBloc, TodosState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text("Todo todoTitle deleted."),
                    action: SnackBarAction(
                      label: "Undo ${deletedTodo.title}",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosBloc>()
                            .add(const TodosUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosStatus.loading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state.status != TodosStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    "No todos found with the selected filters.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return ListView.builder(
              itemCount: state.filteredTodos.toList().length,
              itemBuilder: (context, index) {
                final todos = state.filteredTodos.toList();
                final todo = todos[index];
                return TodoListTile(
                  todo: todo,
                  onToggleCompleted: (isCompleted) {
                    context.read<TodosBloc>().add(
                          TodosTodoCompletionToggled(
                            todo: todo,
                            isCompleted: isCompleted,
                          ),
                        );
                  },
                  onToggleFavotired: (bool isFavorite) {
                    context.read<TodosBloc>().add(
                          TodosTodoFavoritesToggled(
                            todo: todo,
                            isFavorited: isFavorite,
                          ),
                        );
                  },
                  onDismissed: (_) {
                    context.read<TodosBloc>().add(TodosTodoDeleted(todo));
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      EditTodoPage.route(initialTodo: todo),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
