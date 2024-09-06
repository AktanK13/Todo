part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

final class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.completedTodos = 0,
    this.activeTodos = 0,
    this.favoriteTodos = 0,
    this.allTodos = 0,
  });

  final StatsStatus status;
  final int completedTodos;
  final int activeTodos;
  final int favoriteTodos;
  final int allTodos;

  StatsState copyWith({
    StatsStatus? status,
    int? completedTodos,
    int? activeTodos,
    int? favoriteTodos,
    int? allTodos,
  }) {
    return StatsState(
      status: status ?? this.status,
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
      favoriteTodos: favoriteTodos ?? this.favoriteTodos,
      allTodos: allTodos ?? this.allTodos,
    );
  }

  @override
  List<Object> get props => [status, completedTodos, activeTodos, favoriteTodos, allTodos];
}
