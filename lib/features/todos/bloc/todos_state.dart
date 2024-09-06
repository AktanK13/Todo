part of 'todos_bloc.dart';

enum TodosStatus { initial, loading, success, failure }

final class TodosState extends Equatable {
  const TodosState({
    this.status = TodosStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  final TodosStatus status;
  final List<TodoModel> todos;
  final TodosViewFilter filter;
  final TodoModel? lastDeletedTodo;

  Iterable<TodoModel> get filteredTodos => filter.applyAll(todos);

  TodosState copyWith({
    TodosStatus Function()? status,
    List<TodoModel> Function()? todos,
    TodosViewFilter Function()? filter,
    TodoModel? Function()? lastDeletedTodo,
  }) {
    return TodosState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedTodo,
      ];
}
