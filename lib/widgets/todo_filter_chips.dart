import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoFilterChips extends ConsumerWidget {
  const TodoFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(todoFilterPodProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterChip(
            label: const Text('すべて'),
            selected: currentFilter == TodoFilter.all,
            onSelected: (_) {
              ref
                  .read(todoFilterPodProvider.notifier)
                  .setFilter(TodoFilter.all);
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('未完了'),
            selected: currentFilter == TodoFilter.active,
            onSelected: (_) {
              ref
                  .read(todoFilterPodProvider.notifier)
                  .setFilter(TodoFilter.active);
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('完了'),
            selected: currentFilter == TodoFilter.completed,
            onSelected: (_) {
              ref
                  .read(todoFilterPodProvider.notifier)
                  .setFilter(TodoFilter.completed);
            },
          ),
        ],
      ),
    );
  }
}
