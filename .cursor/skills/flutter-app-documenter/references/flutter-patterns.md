# Flutter解析パターン集

このドキュメントは、Flutterアプリを解析してドキュメント化する際に使用するパターン認識ガイドです。

## Riverpod Providerの識別

### @riverpodアノテーション付きクラス

```dart
@riverpod
class TodoPod extends _$TodoPod {
  @override
  List<Todo> build() => [];
  
  void addTodo(String title) { ... }
}
```

- `@riverpod`アノテーションが付いているクラスはProvider
- クラス名から「Pod」を除いた部分が機能名のヒント
- メソッドは状態操作として記録

### @riverpod関数Provider

```dart
@riverpod
List<Todo> filteredTodosPod(FilteredTodosPodRef ref) {
  // 計算ロジック
}
```

- `@riverpod`アノテーション付き関数もProvider
- 名前から機能を推測（例: filteredTodos → フィルタリング機能）

## Freezedモデルの識別

### @freezedアノテーション

```dart
@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
  }) = _Todo;
}
```

識別ポイント:
- `@freezed`アノテーション
- `part 'filename.freezed.dart'`ディレクティブ
- `with _$ClassName`ミックスイン
- `const factory`コンストラクタ
- フィールド定義（required, @Default等）

## Widget/画面の識別

### ConsumerWidget

```dart
class TodoPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI構築
  }
}
```

- `ConsumerWidget`を継承 → Riverpod使用の画面
- クラス名が「Page」「Screen」で終わる → 主要画面
- クラス名が「Input」「Item」「Chip」等 → UIコンポーネント

### HookConsumerWidget

```dart
class TodoInput extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    // ...
  }
}
```

- `HookConsumerWidget`を継承 → Hooks + Riverpod使用
- `use*`関数呼び出し → Flutter Hooks使用

### StatelessWidget/StatefulWidget

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) { ... }
}
```

- 基本的なWidget
- 状態管理の記述は不要

## 機能の識別方法

### Providerから機能を推測

- `TodoPod` + `addTodo()` → TODO追加機能
- `TodoFilterPod` + `setFilter()` → フィルタリング機能
- `filteredTodosPod` → フィルタ適用機能

### Widgetから機能を推測

- `TodoInput` → 入力機能
- `TodoListItem` → 一覧表示機能
- `TodoFilterChips` → フィルタUI機能

### 機能のグルーピング

関連するProvider、Widget、Modelをグルーピング:

例: TODO追加機能
- Widget: `TodoInput`
- Provider: `TodoPod.addTodo()`
- Model: `Todo`

## ルーティング・画面遷移

### MaterialApp/GoRouter

```dart
MaterialApp(
  home: const TodoPage(),
  routes: {
    '/detail': (context) => DetailPage(),
  },
)
```

- `home`パラメータ → 初期画面
- `routes`マップ → ルート定義
- `Navigator.pushNamed()` → 遷移コード

### GoRouter

```dart
GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/detail/:id', builder: (context, state) => DetailPage()),
  ],
)
```

- `GoRoute`の`path` → ルートパス
- パスパラメータ（`:id`等）に注目

## 依存関係の追跡

### ref.watch/ref.read

```dart
final todos = ref.watch(todoPodProvider);
final filter = ref.watch(todoFilterPodProvider);
```

- `ref.watch()` → 依存する他のProvider
- これにより機能間の関連性を追跡

### インポート文

```dart
import '../models/todo.dart';
import '../providers/todo_provider.dart';
```

- インポート文からファイル間の依存関係を把握

## pubspec.yamlの解析

### 依存パッケージ

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  freezed_annotation: ^2.4.4
  hooks_riverpod: ^2.6.1
```

- 使用している状態管理ライブラリを特定
- Riverpod/Provider/Blocなどを識別
