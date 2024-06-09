import 'package:equatable/equatable.dart';

class TodoEntity with EquatableMixin {
  int id;
  String? todo;
  bool? completed;
  int userId;

  TodoEntity({
    required this.id,
    this.todo,
    this.completed,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, todo, completed, userId];

  TodoEntity copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  factory TodoEntity.fromJson(Map<String, dynamic> json) {
    return TodoEntity(
      id: json['id'] as int,
      todo: json['todo'] as String?,
      completed: json['completed'] as bool?,
      userId: json['userId'] as int,
    );
  }
}
