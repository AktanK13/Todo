import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TodosRepository _todosRepository;

  FutureOr<void> _onSubscriptionRequested(
      StatsSubscriptionRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));
    try {
      final todos = await _todosRepository.getTodos();
      emit(state.copyWith(
        status: StatsStatus.success,
        completedTodos: todos.where((todo) => todo.isCompleted).length,
        activeTodos: todos.where((todo) => !todo.isCompleted).length,
      ));
    } catch (e) {
      emit(state.copyWith(status: StatsStatus.failure));
    }
  }
}
