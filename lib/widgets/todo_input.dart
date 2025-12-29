import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoInput extends HookConsumerWidget {
  const TodoInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    void submitTodo() {
      final title = controller.text.trim();
      if (title.isNotEmpty) {
        ref.read(todoPodProvider.notifier).addTodo(title);
        controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('「$title」を追加しました'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '新しいタスクを入力',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => submitTodo(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'タスクを追加',
              onPressed: submitTodo,
            ),
          ),
        ],
      ),
    );
  }
}
