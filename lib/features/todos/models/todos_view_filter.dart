import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';

enum TodosViewFilter { all, activeOnly, completedOnly }

extension TodosViewFilterX on TodosViewFilter {
  bool apply(TodoModel todo) {
    switch (this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<TodoModel> applyAll(Iterable<TodoModel> todos) {
    return todos.where(apply);
  }
}
