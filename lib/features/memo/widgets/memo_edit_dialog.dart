import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';

class MemoEditDialog extends HookConsumerWidget {
  const MemoEditDialog({super.key, required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: memo.title);
    final contentController = useTextEditingController(text: memo.content);

    return AlertDialog(
      title: const Text('メモを編集'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: '内容',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () {
            final title = titleController.text.trim();
            if (title.isNotEmpty) {
              ref.read(memoPodProvider.notifier).updateMemo(
                    memo.id,
                    title: title,
                    content: contentController.text,
                  );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('メモを更新しました'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
