# Commit Patterns for Flutter/Dart Projects

Flutter/Dartプロジェクトの変更を機能ごとに分類するためのパターン集。

## File Pattern Mapping

| ファイルパターン | グループ化ルール | コミットメッセージ例 | 絵文字 |
|----------------|----------------|-------------------|-------|
| `lib/models/{name}.dart` + `{name}.freezed.dart` + `{name}.g.dart` | 3ファイルを1グループ | `{Name} モデルの freezed を作成` | ✨ |
| `lib/providers/{name}_provider.dart` + `{name}_provider.g.dart` | 2ファイルを1グループ | `{Name}Pod プロバイダーを作成` | ✨ |
| `lib/widgets/{name}.dart` | 1ファイル = 1グループ | `{Name} ウィジェットを作成` | ✨ |
| `lib/screens/{name}.dart` | 1ファイル = 1グループ | `{Name} 画面を作成` | ✨ |
| `lib/main.dart` | 単独 | 内容に応じて（例: `アプリのエントリーポイントを作成`） | ✨ |
| `pubspec.yaml` | 単独 | `依存関係を更新` or `{パッケージ名} を追加` | 🔧 |
| `pubspec.lock` | 通常は他の変更と一緒にコミット | 依存関係更新と同じコミット | - |
| `analysis_options.yaml` | 単独 | `静的解析設定を更新` | 🔧 |
| `docs/**/*.md` | 内容ごとにグループ化 | `{機能名}のドキュメントを作成` | 📝 |
| `test/**/*_test.dart` | 1ファイル = 1グループ | `{対象名} のテストを追加` | ✅ |
| `android/**/*`, `ios/**/*` | プラットフォーム設定ごと | `Android の {設定内容} を更新` | 🔧 |
| `web/**/*`, `linux/**/*`, `macos/**/*`, `windows/**/*` | プラットフォーム設定ごと | `{プラットフォーム} の {設定内容} を更新` | 🔧 |

## Grouping Logic

### 1. Freezed Models

**パターン**: モデル定義 + 生成ファイル

```
lib/models/todo.dart
lib/models/todo.freezed.dart
lib/models/todo.g.dart
```

**グループ化**: 上記3ファイルを1つのコミット

**メッセージ**: `✨ Todo モデルの freezed を作成`

**判定基準**:
- `@freezed` アノテーションを含む `.dart` ファイル
- 対応する `.freezed.dart` と `.g.dart` が存在

### 2. Riverpod Providers

**パターン**: プロバイダー定義 + 生成ファイル

```
lib/providers/todo_provider.dart
lib/providers/todo_provider.g.dart
```

**グループ化**: 上記2ファイルを1つのコミット

**メッセージ**: `✨ TodoPod プロバイダーを作成`

**判定基準**:
- `@riverpod` アノテーションを含む `.dart` ファイル
- 対応する `.g.dart` が存在

### 3. Widgets

**パターン**: ウィジェット単体

```
lib/widgets/todo_input.dart
```

**グループ化**: 1ファイル = 1コミット

**メッセージ**: `✨ TodoInput ウィジェットを作成`

**判定基準**:
- `widgets/` ディレクトリ内の `.dart` ファイル
- 通常 `Widget` を継承するクラスを含む

### 4. Screens/Pages

**パターン**: 画面単体

```
lib/screens/home_screen.dart
```

**グループ化**: 1ファイル = 1コミット

**メッセージ**: `✨ ホーム画面を作成`

**判定基準**:
- `screens/` または `pages/` ディレクトリ内の `.dart` ファイル

### 5. Configuration Files

#### pubspec.yaml

**グループ化**: 単独コミット

**メッセージ例**:
- 複数パッケージ追加: `🔧 依存関係を更新`
- 単一パッケージ追加: `🔧 riverpod_annotation を追加`
- バージョン更新: `🔧 flutter_riverpod を 2.5.0 に更新`

**注意**: `pubspec.lock` は同じコミットに含める

#### analysis_options.yaml

**グループ化**: 単独コミット

**メッセージ**: `🔧 静的解析設定を更新`

### 6. Documentation

**パターン**: ドキュメントファイル

```
docs/features/todo_add.md
docs/features/todo_delete.md
```

**グループ化**: 内容ごと（1機能 = 1コミット）

**メッセージ例**:
- `📝 TODO追加機能のドキュメントを作成`
- `📝 TODO削除機能のドキュメントを作成`
- `📝 README を更新`

### 7. Tests

**パターン**: テストファイル

```
test/models/todo_test.dart
test/providers/todo_provider_test.dart
```

**グループ化**: 1ファイル = 1コミット

**メッセージ例**:
- `✅ Todo モデルのテストを追加`
- `✅ TodoPod プロバイダーのテストを追加`

### 8. Platform-Specific Files

**Android**:
```
android/app/build.gradle.kts
android/app/src/main/AndroidManifest.xml
```

**iOS**:
```
ios/Runner/Info.plist
ios/Podfile
```

**グループ化**: プラットフォーム × 設定内容ごと

**メッセージ例**:
- `🔧 Android のパッケージ名を変更`
- `🔧 iOS の Info.plist を更新`

## Special Cases

### Mixed Changes (複数機能が混在)

**NG例**: 以下を1コミットにまとめる
```
lib/models/todo.dart (新規)
lib/models/user.dart (新規)
lib/providers/todo_provider.dart (新規)
```

**OK例**: 3つのコミットに分割
```
コミット1: ✨ Todo モデルの freezed を作成
  - lib/models/todo.dart
  - lib/models/todo.freezed.dart
  - lib/models/todo.g.dart

コミット2: ✨ User モデルの freezed を作成
  - lib/models/user.dart
  - lib/models/user.freezed.dart
  - lib/models/user.g.dart

コミット3: ✨ TodoPod プロバイダーを作成
  - lib/providers/todo_provider.dart
  - lib/providers/todo_provider.g.dart
```

### Bug Fixes (バグ修正)

**パターン**: 既存ファイルの修正

**メッセージ例**:
- `🐛 フィルター機能の null チェックを修正`
- `🐛 TodoListItem の表示バグを修正`
- `🐛 TodoPod の状態更新ロジックを修正`

**判定基準**:
- 既存ファイルの変更（新規作成ではない）
- バグ修正の意図が明確

### Refactoring (リファクタリング)

**パターン**: 機能変更なしのコード改善

**メッセージ例**:
- `♻️ Todo モデルのプロパティ名を変更`
- `♻️ TodoPod のメソッドを分割`
- `♻️ ウィジェットツリーを最適化`

**判定基準**:
- 既存機能の動作は変わらない
- コード構造やネーミングの改善

### Style Changes (スタイル変更)

**パターン**: UI/デザインの変更

**メッセージ例**:
- `💄 TodoListItem のデザインを調整`
- `💄 ホーム画面のレイアウトを変更`
- `💄 カラーテーマを更新`

**判定基準**:
- 見た目の変更が主目的
- ロジックの変更は最小限

## Decision Tree

変更ファイルを見たときの判断フロー:

```
1. ファイルパスを確認
   ├─ models/ → Freezed model?
   │   └─ Yes → .dart + .freezed.dart + .g.dart をグループ化
   ├─ providers/ → Riverpod provider?
   │   └─ Yes → _provider.dart + _provider.g.dart をグループ化
   ├─ widgets/ → Widget単体としてグループ化
   ├─ screens/ → Screen単体としてグループ化
   ├─ docs/ → 内容ごとにグループ化
   ├─ test/ → テストファイル単体としてグループ化
   └─ pubspec.yaml, analysis_options.yaml → 単独コミット

2. 変更の性質を確認
   ├─ 新規ファイル → ✨
   ├─ バグ修正 → 🐛
   ├─ リファクタリング → ♻️
   ├─ ドキュメント → 📝
   ├─ スタイル変更 → 💄
   ├─ テスト → ✅
   └─ 設定変更 → 🔧

3. グループ内に複数機能が混在していないか確認
   └─ 混在している → さらに分割
```

## Examples

### Example 1: New Feature (新機能追加)

**変更ファイル**:
```
lib/models/todo.dart (new)
lib/models/todo.freezed.dart (new)
lib/models/todo.g.dart (new)
lib/providers/todo_provider.dart (new)
lib/providers/todo_provider.g.dart (new)
lib/widgets/todo_input.dart (new)
lib/widgets/todo_list_item.dart (new)
pubspec.yaml (modified)
```

**コミット分割**:
```
コミット1: ✨ Todo モデルの freezed を作成
  - lib/models/todo.dart
  - lib/models/todo.freezed.dart
  - lib/models/todo.g.dart

コミット2: ✨ TodoPod プロバイダーを作成
  - lib/providers/todo_provider.dart
  - lib/providers/todo_provider.g.dart

コミット3: ✨ TodoInput ウィジェットを作成
  - lib/widgets/todo_input.dart

コミット4: ✨ TodoListItem ウィジェットを作成
  - lib/widgets/todo_list_item.dart

コミット5: 🔧 freezed_annotation と riverpod_annotation を追加
  - pubspec.yaml
  - pubspec.lock
```

### Example 2: Bug Fix (バグ修正)

**変更ファイル**:
```
lib/providers/todo_provider.dart (modified)
lib/providers/todo_provider.g.dart (modified)
```

**コミット**:
```
コミット1: 🐛 TodoPod のフィルター機能を修正
  - lib/providers/todo_provider.dart
  - lib/providers/todo_provider.g.dart
```

### Example 3: Documentation (ドキュメント追加)

**変更ファイル**:
```
docs/features/todo_add.md (new)
docs/features/todo_delete.md (new)
docs/features/todo_filter.md (new)
```

**コミット分割**:
```
コミット1: 📝 TODO追加機能のドキュメントを作成
  - docs/features/todo_add.md

コミット2: 📝 TODO削除機能のドキュメントを作成
  - docs/features/todo_delete.md

コミット3: 📝 フィルタリング機能のドキュメントを作成
  - docs/features/todo_filter.md
```
