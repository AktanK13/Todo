import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const FavoritesState()) {
    on<FavoritesSubscriptionRequested>(_onSubscriptionRequested);
    on<FavoritesTodoFavoritesToggled>(_onTodoFavoritesToggled);
    on<FavoritesTodoCompletionToggled>(_onTodoCompletionToggled);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(FavoritesSubscriptionRequested event,
      Emitter<FavoritesState> emit) async {
    emit(state.copyWith(status: () => FavoritesStatus.loading));

    try {
      final favoritesTodos = await _todosRepository.getFavoritesTodos();
      emit(state.copyWith(
        status: () => FavoritesStatus.success,
        favoritesTodo: () => favoritesTodos,
      ));
    } catch (e) {
      emit(state.copyWith(status: () => FavoritesStatus.failure));
    }
  }

  Future<void> _onTodoFavoritesToggled(
      FavoritesTodoFavoritesToggled event, Emitter<FavoritesState> emit) async {
    final newTodo = event.todo.copyWith(isFavorite: event.isFavorites);
    await _todosRepository.saveTodo(newTodo);
    add(const FavoritesSubscriptionRequested());
  }

  Future<void> _onTodoCompletionToggled(
    FavoritesTodoCompletionToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
    add(const FavoritesSubscriptionRequested());
  }
}
