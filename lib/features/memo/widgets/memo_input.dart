import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/memo_provider.dart';

class MemoInput extends HookConsumerWidget {
  const MemoInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();

    void submitMemo() {
      final title = titleController.text.trim();
      if (title.isNotEmpty) {
        ref.read(memoPodProvider.notifier).addMemo(title);
        titleController.clear();
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
              controller: titleController,
              decoration: const InputDecoration(
                hintText: '新しいメモのタイトルを入力',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => submitMemo(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'メモを追加',
              onPressed: submitMemo,
            ),
          ),
        ],
      ),
    );
  }
}
