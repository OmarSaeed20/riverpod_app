import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A read-only description of a todo-item
@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

/// Creates a [TodoList] and initialise it with pre-defined values.
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);

/// An object that controls a list of [Todo].
class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [
    const Todo(id: 'todo-0', description: 'Buy cookies'),
    const Todo(id: 'todo-1', description: 'Star Riverpod'),
    const Todo(id: 'todo-2', description: 'Have a walk'),
  ];

  void add(String description) {
    state = [...state, Todo(id: _uuid.v4(), description: description)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(description: description) else todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

/// A read-only description of a todo-item
@immutable
class TodoItem extends Todo {
  const TodoItem({
    required super.id,
    required super.description,
    required super.completed,
  });
}
