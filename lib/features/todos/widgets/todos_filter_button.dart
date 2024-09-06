import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/todos/models/todos_view_filter.dart';

import '../bloc/todos_bloc.dart';

class TodosFilterButton extends StatelessWidget {
  const TodosFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.select((TodosBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: "Filter",
      onSelected: (filter) {
        context.read<TodosBloc>().add(TodosFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text("All"),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text("Active only"),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text("Completed only"),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
