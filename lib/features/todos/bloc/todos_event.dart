part of 'todos_bloc.dart';

sealed class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

final class TodosSubscriptionRequested extends TodosEvent {
  const TodosSubscriptionRequested();
}

final class TodosTodoCompletionToggled extends TodosEvent {
  const TodosTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final TodoModel todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TodosTodoFavoritesToggled extends TodosEvent {
  const TodosTodoFavoritesToggled({
    required this.todo,
    required this.isFavorited,
  });

  final TodoModel todo;
  final bool isFavorited;

  @override
  List<Object> get props => [todo, isFavorited];
}

final class TodosTodoDeleted extends TodosEvent {
  const TodosTodoDeleted(this.todo);

  final TodoModel todo;

  @override
  List<Object> get props => [todo];
}

final class TodosUndoDeletionRequested extends TodosEvent {
  const TodosUndoDeletionRequested();
}

class TodosFilterChanged extends TodosEvent {
  const TodosFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class TodosToggleAllRequested extends TodosEvent {
  const TodosToggleAllRequested();
}

class TodosClearCompletedRequested extends TodosEvent {
  const TodosClearCompletedRequested();
}
