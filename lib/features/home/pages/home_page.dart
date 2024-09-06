import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/core/constants/constants.dart';
import 'package:my_todo_app/features/edit_todo/pages/edit_todo.dart';
import 'package:my_todo_app/features/favorites/pages/favorites_page.dart';
import 'package:my_todo_app/features/home/cubit/home_cubit.dart';
import 'package:my_todo_app/features/stats/pages/stats_page.dart';
import 'package:my_todo_app/features/todos/pages/todos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: const <Widget>[
        TodosPage(),
        StatsPage(),
        FavoritesPage()
      ][selectedTab.index],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key(AppConsts.kHomeViewAddTodoFloatingActionButton),
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.todos,
              icon: const Icon(Icons.list_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.stats,
              icon: const Icon(Icons.show_chart_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.favorites,
              icon: const Icon(Icons.favorite_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color: groupValue != value
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.primary,
      icon: icon,
    );
  }
}
