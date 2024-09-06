import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/core/utils/highlight_utils.dart';
import 'package:my_todo_app/features/edit_todo/pages/edit_todo.dart';
import 'package:my_todo_app/features/todos/bloc/todos_bloc.dart';

class TodosOverviewSearchButton extends StatelessWidget {
  const TodosOverviewSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: "Search Todos",
      onPressed: () {
        final todosBloc = context.read<TodosBloc>();
        showSearch(
          context: context,
          delegate: TodosSearchDelegate(todosBloc: todosBloc),
        );
      },
    );
  }
}

class TodosSearchDelegate extends SearchDelegate {
  TodosSearchDelegate({required this.todosBloc});

  final TodosBloc todosBloc;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestedTodos = todosBloc.state.todos.where((todo) {
      return todo.title.toLowerCase().contains(query.toLowerCase()) ||
          todo.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (suggestedTodos.isEmpty) {
      return Center(
        child: Text(
          "No todos found for \"$query\".",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView(
      children: suggestedTodos.map((todo) {
        final titleSpans = highlightSearchResult(todo.title, query);
        final descriptionSpans = highlightSearchResult(todo.description, query);
        return ListTile(
          title: Text.rich(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            TextSpan(
              children: titleSpans,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          subtitle: Text.rich(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            TextSpan(
              children: descriptionSpans,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
              EditTodoPage.route(initialTodo: todo),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestedTodos = todosBloc.state.todos.where((todo) {
      return todo.title.toLowerCase().contains(query.toLowerCase()) ||
          todo.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView(
      children: suggestedTodos.map((todo) {
        final titleSpans = highlightSearchResult(todo.title, query);
        final descriptionSpans = highlightSearchResult(todo.description, query);
        return ListTile(
          title: Text.rich(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            TextSpan(
              children: titleSpans,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          subtitle: Text.rich(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            TextSpan(
              children: descriptionSpans,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
              EditTodoPage.route(initialTodo: todo),
            );
          },
        );
      }).toList(),
    );
  }
}
