import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/stats/bloc/stats_bloc.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ListTile(
            key: const Key('statsView_allTodos_listTile'),
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text("All todos"),
            trailing: Text(
              '${state.allTodos}',
              style: textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            key: const Key('statsView_completedTodos_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: const Text("Completed todos"),
            trailing: Text(
              '${state.completedTodos}',
              style: textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            key: const Key('statsView_activeTodos_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: const Text("Active todos"),
            trailing: Text(
              '${state.activeTodos}',
              style: textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            key: const Key('statsView_favoriteTodos_listTile'),
            leading: const Icon(Icons.favorite_outline_rounded),
            title: const Text("Active todos"),
            trailing: Text(
              '${state.favoriteTodos}',
              style: textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
