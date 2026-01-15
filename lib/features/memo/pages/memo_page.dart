import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/memo_provider.dart';
import '../widgets/memo_input.dart';
import '../widgets/memo_list_item.dart';
import '../widgets/memo_edit_dialog.dart';

class MemoPage extends ConsumerWidget {
  const MemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memos = ref.watch(memoPodProvider);
    final memoCount = ref.watch(memoCountPodProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('メモ'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '合計: $memoCount件',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const MemoInput(),
          const Divider(),
          Expanded(
            child: memos.isEmpty
                ? Center(
                    child: Text(
                      'メモがありません',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: memos.length,
                    itemBuilder: (context, index) {
                      final memo = memos[index];
                      return MemoListItem(
                        memo: memo,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => MemoEditDialog(memo: memo),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
