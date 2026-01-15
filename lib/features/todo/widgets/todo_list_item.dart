import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoListItem extends ConsumerWidget {
  const TodoListItem({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: '${todo.title}、${todo.isCompleted ? "完了済み" : "未完了"}',
      button: true,
      child: Dismissible(
        key: ValueKey(todo.id),
        onDismissed: (_) {
          ref.read(todoPodProvider.notifier).removeTodo(todo.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('「${todo.title}」を削除しました'),
              action: SnackBarAction(
                label: '元に戻す',
                onPressed: () {
                  ref.read(todoPodProvider.notifier).addTodo(todo.title);
                },
              ),
            ),
          );
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            semanticLabel: '削除',
          ),
        ),
        child: ListTile(
          leading: SizedBox(
            width: 48,
            height: 48,
            child: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) {
                ref.read(todoPodProvider.notifier).toggleTodo(todo.id);
              },
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todo.isCompleted
                  ? Colors.grey
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          trailing: IconButton(
            iconSize: 24,
            padding: const EdgeInsets.all(12),
            icon: const Icon(Icons.delete),
            tooltip: '削除',
            onPressed: () {
              ref.read(todoPodProvider.notifier).removeTodo(todo.id);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('「${todo.title}」を削除しました')));
            },
          ),
        ),
      ),
    );
  }
}
