import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/edit_todo/pages/edit_todo.dart';
import 'package:my_todo_app/features/favorites/bloc/favorites_bloc.dart';
import 'package:my_todo_app/features/todos/widgets/todo_list_tile.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const FavoritesSubscriptionRequested()),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites Todo"),
      ),
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FavoritesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("An error occurred while loading todos."),
                ),
              );
          }
        },
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state.favoritesTodo.isEmpty) {
              if (state.status == FavoritesStatus.loading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state.status != FavoritesStatus.success) {
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
              itemCount: state.favoritesTodo.toList().length,
              itemBuilder: (context, index) {
                final todos = state.favoritesTodo.toList();
                final todo = todos[index];
                return TodoListTile(
                  todo: todo,
                  onToggleCompleted: (isCompleted) {
                    context.read<FavoritesBloc>().add(
                          FavoritesTodoCompletionToggled(
                            todo: todo,
                            isCompleted: isCompleted,
                          ),
                        );
                  },
                  onToggleFavotired: (bool isFavorites) {
                    context.read<FavoritesBloc>().add(
                          FavoritesTodoFavoritesToggled(
                            todo: todo,
                            isFavorites: isFavorites,
                          ),
                        );
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
