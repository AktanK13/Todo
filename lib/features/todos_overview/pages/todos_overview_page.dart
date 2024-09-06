import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/edit_todo/pages/edit_todo.dart';
import 'package:my_todo_app/features/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:my_todo_app/features/todos_overview/widgets/todos_overview_search_button.dart';
import 'package:my_todo_app/features/todos_overview/widgets/widgets.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        actions: const [
          TodosOverviewSearchButton(),
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
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
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
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
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            log('data-unique: state: ${state} ');
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state.status != TodosOverviewStatus.success) {
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
                    context.read<TodosOverviewBloc>().add(
                          TodosOverviewTodoCompletionToggled(
                            todo: todo,
                            isCompleted: isCompleted,
                          ),
                        );
                  },
                  onToggleFavotired: (bool isFavorite) {
                    context.read<TodosOverviewBloc>().add(
                          TodosOverviewTodoFavoritesToggled(
                            todo: todo,
                            isFavorited: isFavorite,
                          ),
                        );
                  },
                  onDismissed: (_) {
                    context
                        .read<TodosOverviewBloc>()
                        .add(TodosOverviewTodoDeleted(todo));
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
