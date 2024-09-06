part of 'favorites_bloc.dart';

enum FavoritesStatus { initial, loading, success, failure }

final class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favoritesTodo = const [],
  });

  final FavoritesStatus status;
  final List<TodoModel> favoritesTodo;

  FavoritesState copyWith({
    FavoritesStatus Function()? status,
    List<TodoModel> Function()? favoritesTodo,
  }) {
    return FavoritesState(
      status: status != null ? status() : this.status,
      favoritesTodo:
          favoritesTodo != null ? favoritesTodo() : this.favoritesTodo,
    );
  }

  @override
  List<Object> get props => [status, favoritesTodo];
}
