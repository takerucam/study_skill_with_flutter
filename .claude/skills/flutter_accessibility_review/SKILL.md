---
name: flutter-accessibility-review
description: FlutterアプリケーションのコードレビューでFlutter公式のアクセシビリティガイドラインへの準拠をチェックします。コード差分でスクリーンリーダー対応、コントラスト比、タップ領域、色覚特性対応などのアクセシビリティ要件を検証する際に使用してください。参考: https://docs.flutter.dev/ui/accessibility
---

# Flutter Accessibility Review Skill

## 目的
Flutter公式のアクセシビリティガイドラインに基づいて、コード差分がアクセシビリティ要件に準拠しているかをレビューします。

参考: https://docs.flutter.dev/ui/accessibility

## レビュー観点

### 1. アクティブな操作 (Active interactions)
- [ ] すべてのインタラクティブな要素（ボタン、タップ可能なウィジェット）に適切な動作が実装されているか
- [ ] `onPressed`コールバックが空またはnullの場合、適切な処理（SnackBar表示など）が実装されているか
- [ ] ユーザーが操作した際に何らかのフィードバックがあるか

**チェック対象:**
```dart
// ❌ NG: 何もしないボタン
ElevatedButton(onPressed: () {}, child: Text('ボタン'))

// ✅ OK: 適切なフィードバック
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ボタンが押されました')),
    );
  },
  child: Text('ボタン'),
)
```

### 2. スクリーンリーダー対応 (Screen reader testing)
- [ ] すべてのウィジェットに`Semantics`またはセマンティック情報が適切に設定されているか
- [ ] 画像には意味のある`semanticLabel`が設定されているか
- [ ] カスタムウィジェットには`Semantics`ウィジェットでラベルが提供されているか
- [ ] TalkBack (Android) / VoiceOver (iOS) で正しく読み上げられるか

**チェック対象:**
```dart
// ❌ NG: セマンティック情報がない画像
Image.asset('assets/logo.png')

// ✅ OK: セマンティックラベル付き
Image.asset(
  'assets/logo.png',
  semanticLabel: 'アプリケーションロゴ',
)

// ✅ OK: カスタムウィジェットにSemantics
Semantics(
  label: 'プロフィール編集ボタン',
  button: true,
  child: CustomButton(),
)
```

### 3. コントラスト比 (Contrast ratios)
- [ ] テキストと背景のコントラスト比が最低4.5:1以上であるか
- [ ] 画像やアイコンのコントラストが十分であるか
- [ ] 無効化された要素を除き、すべてのUI要素が十分なコントラストを持つか
- [ ] カラーコードの変更がある場合、アクセシビリティツールで確認されているか

**チェック対象:**
```dart
// ❌ NG: コントラストが低い
Text(
  'テキスト',
  style: TextStyle(color: Colors.grey[400]),
) // 薄いグレーの背景に薄いグレーのテキスト

// ✅ OK: 十分なコントラスト
Text(
  'テキスト',
  style: TextStyle(color: Colors.black87),
) // 白い背景に黒いテキスト
```

### 4. コンテキストの自動切り替え (Context switching)
- [ ] ユーザーが入力中に、確認なしでコンテキストが自動的に変更されないか
- [ ] フォーカスの移動が予期しないタイミングで発生しないか
- [ ] 自動スクロールやページ遷移が適切に制御されているか

**チェック対象:**
```dart
// ❌ NG: 入力中に自動でページ遷移
TextField(
  onChanged: (value) {
    if (value.length == 10) {
      Navigator.push(...); // ユーザーの意図しない遷移
    }
  },
)

// ✅ OK: 確認後に遷移
TextField(
  controller: controller,
  decoration: InputDecoration(
    suffixIcon: IconButton(
      icon: Icon(Icons.send),
      onPressed: () {
        if (controller.text.length == 10) {
          Navigator.push(...);
        }
      },
    ),
  ),
)
```

### 5. タップ可能領域 (Tappable targets)
- [ ] すべてのタップ可能な要素が最低48x48ピクセル以上のサイズであるか
- [ ] アイコンボタンやタップ領域が十分な大きさを持っているか
- [ ] 隣接する要素間に適切な間隔があるか

**チェック対象:**
```dart
// ❌ NG: タップ領域が小さい
IconButton(
  iconSize: 16,
  padding: EdgeInsets.zero,
  icon: Icon(Icons.close),
  onPressed: () {},
)

// ✅ OK: 十分なタップ領域
IconButton(
  iconSize: 24,
  padding: EdgeInsets.all(12), // 合計48x48ピクセル以上
  icon: Icon(Icons.close),
  onPressed: () {},
)

// ✅ OK: SizedBoxで領域を確保
SizedBox(
  width: 48,
  height: 48,
  child: Center(
    child: Icon(Icons.close, size: 24),
  ),
)
```

### 6. エラー処理とアンドゥ (Errors and Undo)
- [ ] 重要なアクションには確認ダイアログがあるか
- [ ] エラーメッセージが表示される際、修正方法の提案があるか
- [ ] 削除などの重要な操作はアンドゥ可能か
- [ ] フォームバリデーションのエラーメッセージが適切か

**チェック対象:**
```dart
// ❌ NG: エラーメッセージのみ
TextField(
  decoration: InputDecoration(
    errorText: 'エラー',
  ),
)

// ✅ OK: 修正方法の提案
TextField(
  decoration: InputDecoration(
    errorText: 'メールアドレスの形式が正しくありません。例: user@example.com',
  ),
)

// ✅ OK: 削除前に確認
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('削除の確認'),
        content: Text('本当に削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('削除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      // 削除処理
    }
  },
)
```

### 7. 色覚特性対応 (Color vision deficiency testing)
- [ ] 情報を色だけで伝えていないか（アイコン、テキスト、パターンなどと併用）
- [ ] 色覚多様性のある人でも区別できる色の組み合わせか
- [ ] グレースケールモードでも使用可能か

**チェック対象:**
```dart
// ❌ NG: 色だけで情報を伝達
Container(
  color: Colors.red, // エラーを色だけで表現
  child: Text('エラー'),
)

// ✅ OK: アイコンとテキストで補完
Row(
  children: [
    Icon(Icons.error, color: Colors.red),
    Text('エラー: 入力内容を確認してください'),
  ],
)

// ✅ OK: 状態をアイコンで明示
ListTile(
  leading: isCompleted
    ? Icon(Icons.check_circle, color: Colors.green)
    : Icon(Icons.circle_outlined),
  title: Text('タスク'),
)
```

### 8. スケールファクター対応 (Scale factors)
- [ ] 大きなテキストサイズでもUIが崩れないか
- [ ] 表示スケールを変更してもレイアウトが適切に機能するか
- [ ] 固定サイズではなく、相対的なサイズ指定を使用しているか
- [ ] オーバーフローエラーが発生しないか

**チェック対象:**
```dart
// ❌ NG: 固定サイズで切れる可能性
Container(
  width: 100,
  child: Text('長いテキストが切れてしまう'),
)

// ✅ OK: フレキシブルなレイアウト
Flexible(
  child: Text(
    '長いテキストでも適切に折り返される',
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  ),
)

// ✅ OK: MediaQueryを使用
Text(
  'テキスト',
  style: TextStyle(
    fontSize: MediaQuery.of(context).textScaleFactor * 16,
  ),
)
```

## アクセシビリティ関連のFlutterウィジェット

### 必ずチェックすべきウィジェット
- `Semantics`: セマンティック情報を提供
- `MergeSemantics`: 複数の要素のセマンティクスを統合
- `ExcludeSemantics`: セマンティックツリーから除外
- `SemanticsDebugger`: アクセシビリティのデバッグ用

### よく使われるプロパティ
```dart
Semantics(
  label: '説明テキスト',
  hint: '操作のヒント',
  value: '現在の値',
  button: true, // ボタンとして認識
  enabled: true, // 有効/無効
  focusable: true, // フォーカス可能
  header: true, // ヘッダーとして認識
  image: true, // 画像として認識
  link: true, // リンクとして認識
  onTap: () {}, // タップ時の動作
  child: widget,
)
```

## レビュー手順

1. **コード差分の確認**
   - 新規追加・変更されたウィジェットを特定
   - インタラクティブな要素を優先的に確認

2. **各チェック項目の検証**
   - 上記の8つの観点でコードをレビュー
   - 問題がある場合は具体的な修正案を提示

3. **テストの推奨**
   - TalkBack (Android) または VoiceOver (iOS) での動作確認を推奨
   - アクセシビリティスキャナーの使用を推奨
   - 実機での大きなテキストサイズでの確認を推奨

4. **ドキュメント確認**
   - 必要に応じて Flutter 公式ドキュメントを参照
   - https://docs.flutter.dev/ui/accessibility
   - https://docs.flutter.dev/ui/accessibility/ui-design-and-styling

## 参考リンク

- [Flutter Accessibility - 公式ドキュメント](https://docs.flutter.dev/ui/accessibility)
- [WCAG 2.1 ガイドライン](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Accessibility](https://m3.material.io/foundations/accessibility/overview)
- [TalkBack (Android)](https://support.google.com/accessibility/android/answer/6283677?hl=en)
- [VoiceOver (iOS)](https://www.apple.com/accessibility/iphone/vision/)

## レビューテンプレート

```markdown
## アクセシビリティレビュー結果

### ✅ 問題なし
- [観点名]: 説明

### ⚠️ 改善推奨
- [観点名]: 問題の説明
  - **現状**: コードの該当箇所
  - **推奨**: 修正案

### ❌ 要対応
- [観点名]: 重大な問題の説明
  - **現状**: コードの該当箇所
  - **必須対応**: 修正案
  - **理由**: なぜこの対応が必要か
```
