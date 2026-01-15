import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/todo.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoPod extends _$TodoPod {
  @override
  List<Todo> build() => [];

  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(id: DateTime.now().toString(), title: title);
    state = [...state, newTodo];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

enum TodoFilter { all, active, completed }

@riverpod
class TodoFilterPod extends _$TodoFilterPod {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) {
    state = filter;
  }
}

@riverpod
List<Todo> filteredTodosPod(FilteredTodosPodRef ref) {
  final filter = ref.watch(todoFilterPodProvider);
  final todos = ref.watch(todoPodProvider);

  switch (filter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.active:
      return todos.where((todo) => !todo.isCompleted).toList();
    case TodoFilter.completed:
      return todos.where((todo) => todo.isCompleted).toList();
  }
}

@riverpod
int uncompletedTodosCountPod(UncompletedTodosCountPodRef ref) {
  final todos = ref.watch(todoPodProvider);
  return todos.where((todo) => !todo.isCompleted).length;
}
