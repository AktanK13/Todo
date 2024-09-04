import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';
import 'package:my_todo_app/hive/todos_api/todos_api.dart';
import 'package:rxdart/subjects.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveTodosApi extends TodosApi {
  HiveTodosApi() {
    _init();
  }

  late final _todoStreamController = BehaviorSubject<List<TodoModel>>.seeded(
    const [],
  );

  static const kTodosCollectionKey = '__todos_collection_key__';

  static initHive() async {
    final applicationDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(applicationDocumentDir.path)
      ..registerAdapter(TodoModelAdapter());
    if (!Hive.isBoxOpen(kTodosCollectionKey)) {
      await Hive.openBox<TodoModel>(kTodosCollectionKey);
    }
  }

  List<TodoModel> _getValue(String key) {
    final allTodos = Hive.box<TodoModel>(key).values.toList();
    return allTodos;
  }

  Future<void> _setValue(String key, List<TodoModel> value) {
    return Hive.box<TodoModel>(key).putAll(
      {for (var todo in value) todo.id: todo},
    );
  }

  void _init() {
    final todos = _getValue(kTodosCollectionKey);
    _todoStreamController.add(todos);
  }

  @override
  Stream<List<TodoModel>> getTodos() =>
      _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(TodoModel todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }

    _todoStreamController.add(todos);
    return _setValue(kTodosCollectionKey, todos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(kTodosCollectionKey, todos);
    }
  }

  @override
  Future<int> clearCompleted() async {
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todoStreamController.add(todos);
    await _setValue(kTodosCollectionKey, todos);
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount =
        todos.where((t) => t.isCompleted != isCompleted).length;
    final newTodos = [
      for (final todo in todos) todo.copyWith(isCompleted: isCompleted),
    ];
    _todoStreamController.add(newTodos);
    await _setValue(kTodosCollectionKey, newTodos);
    return changedTodosAmount;
  }

  @override
  Future<void> close() {
    return _todoStreamController.close();
  }
}
