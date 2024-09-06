import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';

abstract class TodosApi {
  const TodosApi();

  Stream<List<TodoModel>> getTodos();
  Future<List<TodoModel>> getFavoritesTodos();
  Future<void> saveTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
  Future<void> close();
}

class TodoNotFoundException implements Exception {}
