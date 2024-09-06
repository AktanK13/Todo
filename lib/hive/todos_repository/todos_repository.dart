import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';
import 'package:my_todo_app/hive/todos_api/todos_api.dart';

class TodosRepository {
  const TodosRepository({
    required TodosApi todosApi,
  }) : _todosApi = todosApi;

  final TodosApi _todosApi;

  Stream<List<TodoModel>> getTodos() => _todosApi.getTodos();
  Future<List<TodoModel>> getFavoritesTodos() => _todosApi.getFavoritesTodos();

  Future<void> saveTodo(TodoModel todo) => _todosApi.saveTodo(todo);

  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);

  Future<int> clearCompleted() => _todosApi.clearCompleted();

  Future<int> completeAll({required bool isCompleted}) =>
      _todosApi.completeAll(isCompleted: isCompleted);
}
