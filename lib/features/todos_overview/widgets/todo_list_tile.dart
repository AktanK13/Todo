import 'package:flutter/material.dart';
import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    this.onToggleCompleted,
    required this.onToggleFavotired,
    this.onDismissed,
    this.onTap,
  });

  final TodoModel todo;
  final ValueChanged<bool>? onToggleCompleted;
  final Function(bool) onToggleFavotired;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

    return Dismissible(
      key: Key('todoListTile_dismissible_${todo.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: !todo.isCompleted
              ? null
              : TextStyle(
                  color: captionColor,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        subtitle: Text(
          todo.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Checkbox(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          value: todo.isCompleted,
          onChanged: (value) => onToggleCompleted!(value!),
        ),
        trailing: IconButton(
          isSelected: todo.isFavorite,
          onPressed: () {
            onToggleFavotired(!todo.isFavorite);
          },
          icon: todo.isFavorite
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_outline_rounded),
        ),
      ),
    );
  }
}
