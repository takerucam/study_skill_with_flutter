import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';

class MemoListItem extends ConsumerWidget {
  const MemoListItem({super.key, required this.memo, required this.onTap});

  final Memo memo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: memo.title,
      button: true,
      child: Dismissible(
        key: ValueKey(memo.id),
        onDismissed: (_) {
          ref.read(memoPodProvider.notifier).removeMemo(memo.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('「${memo.title}」を削除しました'),
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
          leading: const Icon(Icons.note),
          title: Text(
            memo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: memo.content.isNotEmpty
              ? Text(
                  memo.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                )
              : null,
          trailing: IconButton(
            iconSize: 24,
            padding: const EdgeInsets.all(12),
            icon: const Icon(Icons.delete),
            tooltip: '削除',
            onPressed: () {
              ref.read(memoPodProvider.notifier).removeMemo(memo.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('「${memo.title}」を削除しました')),
              );
            },
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
