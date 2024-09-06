import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends Equatable {
  TodoModel({
    required this.title,
    String? id,
    this.description = '',
    this.isCompleted = false,
    this.isFavorite = false,
  }) : id = id ?? const Uuid().v4();

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool isCompleted;
  @HiveField(4)
  final bool isFavorite;

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isFavorite,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [id, title, description, isCompleted, isFavorite];
}
