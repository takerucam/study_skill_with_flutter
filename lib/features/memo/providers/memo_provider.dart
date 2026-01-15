import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/memo.dart';

part 'memo_provider.g.dart';

@riverpod
class MemoPod extends _$MemoPod {
  @override
  List<Memo> build() => [];

  void addMemo(String title, {String content = ''}) {
    if (title.trim().isEmpty) return;

    final now = DateTime.now();
    final newMemo = Memo(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: now,
    );
    state = [...state, newMemo];
  }

  void updateMemo(String id, {String? title, String? content}) {
    state = [
      for (final memo in state)
        if (memo.id == id)
          memo.copyWith(
            title: title ?? memo.title,
            content: content ?? memo.content,
            updatedAt: DateTime.now(),
          )
        else
          memo,
    ];
  }

  void removeMemo(String id) {
    state = state.where((memo) => memo.id != id).toList();
  }
}

@riverpod
int memoCountPod(MemoCountPodRef ref) {
  final memos = ref.watch(memoPodProvider);
  return memos.length;
}
