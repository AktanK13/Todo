part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

final class FavoritesSubscriptionRequested extends FavoritesEvent {
  const FavoritesSubscriptionRequested();
}

final class FavoritesTodoFavoritesToggled extends FavoritesEvent {
  const FavoritesTodoFavoritesToggled({
    required this.todo,
    required this.isFavorites,
  });

  final TodoModel todo;
  final bool isFavorites;

  @override
  List<Object> get props => [todo, isFavorites];
}


final class FavoritesTodoCompletionToggled extends FavoritesEvent {
  const FavoritesTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final TodoModel todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}