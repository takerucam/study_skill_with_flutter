---
name: riverpod-hooks-best-practices
description: Flutter Riverpod (riverpod_generator & flutter_hooks) のベストプラクティスに基づいてコードレビューを実施します。命名規則、アノテーション使用、Hooks活用、ref.read/watchの適切な使い分けなどをチェックします。参考: https://riverpod.dev/docs/concepts/about_code_generation
---

# Riverpod (Generator & Hooks) Best Practices Reviewer

## 目的
Flutter Riverpod (with `riverpod_generator` & `flutter_hooks`) のコード規約に基づいて、コードの変更差分をレビューし、アンチパターンおよび命名規則違反を検出します。

参考: 
- https://riverpod.dev/docs/concepts/about_code_generation
- https://pub.dev/packages/riverpod_generator
- https://pub.dev/packages/flutter_hooks

## レビュー観点

### 1. 命名規則 (Naming Convention)
- [ ] `riverpod_generator`の対象となるクラス名または関数名が`Pod`で終わっているか
- [ ] 生成されるProvider名が`〇〇PodProvider`の形式になるよう設計されているか
- [ ] 一貫性のある命名パターンが使用されているか

**チェック対象:**
```dart
// ❌ NG: Podサフィックスがない
@riverpod
class UserNotifier extends _$UserNotifier {
  // 生成物: userNotifierProvider (長い & 冗長)
}

// ✅ OK: Podサフィックスあり
@riverpod
class UserPod extends _$UserPod {
  // 生成物: userPodProvider (簡潔 & 一貫性)
}

// ❌ NG: 関数ベースでPodサフィックスがない
@riverpod
String title(Ref ref) {
  // 生成物: titleProvider
}

// ✅ OK: 関数ベースでもPodサフィックス
@riverpod
String titlePod(TitlePodRef ref) {
  // 生成物: titlePodProvider
}
```

**理由:**
- 生成されるProvider名を統一的に`〇〇PodProvider`にすることで、コードベース全体で一貫性が保たれます
- `Provider`という接尾辞の前に`Pod`を付けることで、riverpod_generatorで生成されたものであることが明確になります
- 命名の冗長性を避け、可読性を向上させます

### 2. Riverpod Generator アノテーション使用
- [ ] 手動で`Provider`や`StateNotifierProvider`を定義せず、`@riverpod`アノテーションを使用しているか
- [ ] 適切なアノテーションパラメータ（`keepAlive`など）が設定されているか
- [ ] `part`ディレクティブが正しく記述されているか

**チェック対象:**
```dart
// ❌ NG: 手動でProviderを定義
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

// ✅ OK: @riverpodアノテーションを使用
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserPod extends _$UserPod {
  @override
  User build() => User.empty();
  
  void updateName(String name) {
    state = state.copyWith(name: name);
  }
}

// ✅ OK: keepAliveオプションの使用
@Riverpod(keepAlive: true)
class ConfigPod extends _$ConfigPod {
  @override
  Config build() => Config.load();
}

// ✅ OK: 関数ベースのProvider
@riverpod
Future<List<Todo>> todoPod(TodoPodRef ref) async {
  return await fetchTodos();
}
```

### 3. 型定義の正確性
- [ ] 非同期処理の場合、`Future<T>`または`Stream<T>`を返しているか
- [ ] 同期処理の場合、適切な戻り値の型を指定しているか
- [ ] 生成される`Notifier`の型（`AutoDisposeNotifier`、`AutoDisposeAsyncNotifier`など）が適切か

**チェック対象:**
```dart
// ❌ NG: 非同期処理なのにFutureを返していない
@riverpod
class DataPod extends _$DataPod {
  @override
  Data build() {
    fetchData(); // 非同期処理を呼んでいるが適切に処理していない
    return Data.empty();
  }
}

// ✅ OK: 非同期処理の適切な実装
@riverpod
class DataPod extends _$DataPod {
  @override
  Future<Data> build() async {
    return await fetchData();
  }
}

// ✅ OK: Streamの使用
@riverpod
class MessagesPod extends _$MessagesPod {
  @override
  Stream<List<Message>> build() {
    return messageStream();
  }
}

// ✅ OK: 同期的な値の提供
@riverpod
class CounterPod extends _$CounterPod {
  @override
  int build() => 0;
  
  void increment() => state++;
}
```

### 4. Flutter Hooks の活用
- [ ] `ConsumerWidget`の代わりに`HookConsumerWidget`を使用しているか
- [ ] UI固有の一時的な状態にはHooksを使用しているか
- [ ] Hooksとプロバイダーの使い分けが適切か

**チェック対象:**
```dart
// ❌ NG: Hooksを使えるのにConsumerWidgetを使用
class TodoInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(); // TextEditingControllerの管理が煩雑
  }
}

// ✅ OK: HookConsumerWidgetでuseTextEditingControllerを使用
class TodoInput extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    
    return TextField(
      controller: controller,
      onSubmitted: (value) {
        ref.read(todoPodProvider.notifier).addTodo(value);
        controller.clear();
      },
    );
  }
}

// ❌ NG: UI状態をProviderで管理
@riverpod
class TextFieldPod extends _$TextFieldPod {
  @override
  String build() => '';
  
  void update(String value) => state = value;
}

// ✅ OK: UI状態はuseStateで管理
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = useState('');
    
    return TextField(
      onChanged: (value) => text.value = value,
    );
  }
}
```

**使い分けガイドライン:**
- **Providerを使うべき:** ビジネスロジック、共有状態、永続化が必要な状態
- **Hooksを使うべき:** TextEditingController、AnimationController、FocusNode、画面固有の一時的な状態

### 5. ref.read vs ref.watch の使い分け
- [ ] `build`メソッド内では`ref.watch`を使用しているか
- [ ] イベントハンドラ内では`ref.read`を使用しているか
- [ ] `ref.listen`を適切に使用しているか

**チェック対象:**
```dart
// ❌ NG: buildメソッドでref.readを使用
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userPodProvider); // 再ビルドされない！
    return Text(user.name);
  }
}

// ✅ OK: buildメソッドでref.watchを使用
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userPodProvider);
    return Text(user.name);
  }
}

// ❌ NG: イベントハンドラでref.watchを使用
ElevatedButton(
  onPressed: () {
    final user = ref.watch(userPodProvider); // 不要なリビルドの原因
    ref.read(todoPodProvider.notifier).addTodo(user.name);
  },
  child: Text('追加'),
)

// ✅ OK: イベントハンドラでref.readを使用
ElevatedButton(
  onPressed: () {
    final user = ref.read(userPodProvider);
    ref.read(todoPodProvider.notifier).addTodo(user.name);
  },
  child: Text('追加'),
)

// ✅ OK: ref.listenで副作用を処理
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(errorPodProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next)),
        );
      }
    });
    
    return Container();
  }
}
```

### 6. 副作用とライフサイクル管理
- [ ] プロバイダーの作成時やWidgetの`build`中に副作用（ナビゲーション、SnackBar表示など）を実行していないか
- [ ] `ref.listen`を使って副作用を適切に処理しているか
- [ ] `keepAlive`の設定が適切か

**チェック対象:**
```dart
// ❌ NG: build内で直接ナビゲーション
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authPodProvider);
    
    if (!isLoggedIn) {
      Navigator.pushNamed(context, '/login'); // ビルド中の副作用！
    }
    
    return Container();
  }
}

// ✅ OK: ref.listenで副作用を処理
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authPodProvider, (previous, next) {
      if (!next) {
        Navigator.pushNamed(context, '/login');
      }
    });
    
    return Container();
  }
}

// ❌ NG: 画面を離れても保持すべき状態なのにautoDispose
@riverpod
class ShoppingCartPod extends _$ShoppingCartPod {
  @override
  List<Item> build() => [];
}

// ✅ OK: keepAliveを使用
@Riverpod(keepAlive: true)
class ShoppingCartPod extends _$ShoppingCartPod {
  @override
  List<Item> build() => [];
  
  void addItem(Item item) {
    state = [...state, item];
  }
}
```

### 7. プロバイダーの依存関係
- [ ] 他のプロバイダーに依存する場合、適切に`ref.watch`または`ref.read`を使用しているか
- [ ] 循環参照を避けているか
- [ ] 依存関係が明確で保守しやすいか

**チェック対象:**
```dart
// ✅ OK: 他のプロバイダーへの依存
@riverpod
class FilteredTodosPod extends _$FilteredTodosPod {
  @override
  List<Todo> build() {
    final todos = ref.watch(todoPodProvider);
    final filter = ref.watch(filterPodProvider);
    
    return todos.where((todo) {
      switch (filter) {
        case Filter.all:
          return true;
        case Filter.active:
          return !todo.isCompleted;
        case Filter.completed:
          return todo.isCompleted;
      }
    }).toList();
  }
}

// ✅ OK: 関数ベースのProvider依存
@riverpod
Future<User> userPod(UserPodRef ref, String id) async {
  final client = ref.watch(httpClientPodProvider);
  return await client.fetchUser(id);
}
```

### 8. テスタビリティとオーバーライド
- [ ] テストでオーバーライド可能な設計になっているか
- [ ] 外部依存（API、データベースなど）がプロバイダーとして抽出されているか

**チェック対象:**
```dart
// ✅ OK: テスト可能な設計
@riverpod
class ApiClientPod extends _$ApiClientPod {
  @override
  ApiClient build() => ApiClient();
}

@riverpod
class UserRepositoryPod extends _$UserRepositoryPod {
  @override
  UserRepository build() {
    final client = ref.watch(apiClientPodProvider);
    return UserRepository(client);
  }
}

// テストでのオーバーライド例
final container = ProviderContainer(
  overrides: [
    apiClientPodProvider.overrideWith(() => MockApiClient()),
  ],
);
```

## よく使われるパターン

### 状態管理パターン
```dart
// シンプルな状態管理
@riverpod
class CounterPod extends _$CounterPod {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
}

// 非同期データの読み込み
@riverpod
class UserPod extends _$UserPod {
  @override
  Future<User> build(String id) async {
    return await fetchUser(id);
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchUser(id));
  }
}

// フィルタリング・計算
@riverpod
int uncompletedCountPod(UncompletedCountPodRef ref) {
  final todos = ref.watch(todoPodProvider);
  return todos.where((todo) => !todo.isCompleted).length;
}
```

### Hooksパターン
```dart
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TextEditingController
    final controller = useTextEditingController();
    
    // useState
    final counter = useState(0);
    
    // useEffect (componentDidMount/willUnmount相当)
    useEffect(() {
      print('マウントされました');
      return () => print('アンマウントされます');
    }, []);
    
    // useMemoized (高コストな計算のキャッシュ)
    final expensiveValue = useMemoized(() => expensiveCalculation(), [dependency]);
    
    return Container();
  }
}
```

## レビュー手順

1. **コード差分の確認**
   - 新規追加・変更されたプロバイダーとウィジェットを特定
   - 命名規則を最優先でチェック

2. **各チェック項目の検証**
   - 上記の8つの観点でコードをレビュー
   - 違反がある場合は理由と修正案を提示

3. **パフォーマンスの考慮**
   - 不要な再ビルドが発生していないか
   - `ref.read` vs `ref.watch`の使い分けが適切か

4. **保守性の確認**
   - コードが読みやすく、意図が明確か
   - 一貫性のあるパターンが使用されているか

## レビューテンプレート

```markdown
## Riverpod/Hooks レビュー結果

### ✅ 問題なし
- [観点名]: 説明

### ⚠️ 改善推奨
- [観点名]: 問題の説明
  - **ファイル**: [ファイル名]
  - **現状**: コードの該当箇所
  - **理由**: なぜ問題なのか
  - **推奨**: 修正案

### 🚨 要対応（命名規則違反）
- **命名規則違反**: クラス/関数名に`Pod`サフィックスがありません
  - **ファイル**: `lib/providers/user_provider.dart`
  - **現状**: 
    ```dart
    @riverpod
    class UserNotifier extends _$UserNotifier { ... }
    ```
  - **理由**: 生成されるProvider名が`userNotifierProvider`となり冗長です。`Pod`サフィックスを付けることで`userPodProvider`として一貫性のある命名になります
  - **必須対応**: 
    ```dart
    @riverpod
    class UserPod extends _$UserPod { ... }
    ```

### 🚨 要対応（ref.read/watch誤用）
- **ref.read誤用**: `build`メソッド内で`ref.read`を使用
  - **ファイル**: `lib/widgets/user_widget.dart`
  - **現状**:
    ```dart
    Widget build(BuildContext context, WidgetRef ref) {
      final user = ref.read(userPodProvider);
    ```
  - **理由**: `build`メソッド内では状態変化を検知するため`ref.watch`を使用する必要があります
  - **必須対応**:
    ```dart
    Widget build(BuildContext context, WidgetRef ref) {
      final user = ref.watch(userPodProvider);
    ```
```

## 参考リンク

- [Riverpod - About code generation](https://riverpod.dev/docs/concepts/about_code_generation)
- [Riverpod - Providers](https://riverpod.dev/docs/concepts/providers)
- [Riverpod Generator - pub.dev](https://pub.dev/packages/riverpod_generator)
- [Flutter Hooks - pub.dev](https://pub.dev/packages/flutter_hooks)
- [Riverpod - Testing](https://riverpod.dev/docs/cookbooks/testing)
