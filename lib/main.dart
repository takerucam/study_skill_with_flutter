import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/todo_provider.dart';
import 'widgets/todo_input.dart';
import 'widgets/todo_list_item.dart';
import 'widgets/todo_filter_chips.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOアプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTodos = ref.watch(filteredTodosPodProvider);
    final uncompletedCount = ref.watch(uncompletedTodosCountPodProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TODOアプリ'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '未完了: $uncompletedCount件',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const TodoInput(),
          const TodoFilterChips(),
          const Divider(),
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
                    child: Text(
                      'タスクがありません',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoListItem(todo: todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
