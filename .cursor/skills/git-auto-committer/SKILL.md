---
name: git-auto-committer
description: Git差分を解析して機能ごとに細かく分割したコミット案を日本語で提案し、ユーザー確認後に実行する。Flutter/Dart プロジェクトに特化し、freezed/provider/widget を別々のコミットに分割。「コミットして」「差分をコミット」「変更をコミット」「git commit」などの指示で使用。
---

# Git Auto Committer

## Workflow

1. Check git diff and status (parallel: `git status`, `git diff --staged`, `git diff`)
2. Group changed files by feature (consult `references/commit-patterns.md`)
3. Create commit message for each group (use `.commit.template` format)
4. Present proposals to user
5. Execute commits sequentially after approval

## Grouping Rules

Consult `references/commit-patterns.md` for Flutter/Dart file patterns:

- **Freezed models**: `models/*.dart` + `*.freezed.dart` + `*.g.dart` → 1 group
- **Riverpod providers**: `providers/*_provider.dart` + `*.g.dart` → 1 group  
- **Widgets**: `widgets/*.dart` → separate groups
- **Screens**: `screens/*.dart` → separate groups
- **Config files**: `pubspec.yaml`, `analysis_options.yaml` → individual
- **Docs**: `docs/**/*.md` → by content
- **Tests**: `test/**/*.dart` → individual

**Key principle**: 1 group = 1 feature. Split if multiple features are mixed.

## Commit Message Format

`{emoji} {summary in Japanese}`

Emoji selection:
- ✨ New feature
- 🐛 Bug fix
- ♻️ Refactor
- 📝 Docs
- 💄 UI/style
- ✅ Test
- 🔧 Config/tools
- 🏗️ Build
- 🗑️ Remove

Rules:
1. Japanese only
2. End with verb (「〜を作成」「〜を修正」)
3. Include specific names (model/provider/widget)
4. Keep concise (one line)

Examples:
```
✨ Todo モデルの freezed を作成
✨ TodoPod プロバイダーを作成
🐛 フィルター機能の null チェックを修正
```

## Presentation Format

```markdown
## コミット案

### コミット 1
**対象ファイル**: lib/models/todo.dart, lib/models/todo.freezed.dart, ...
**メッセージ**: ✨ Todo モデルの freezed を作成

### コミット 2
...

このコミット案でよろしいですか？
```

## Execution

After user approval, execute sequentially:

```bash
git add {files}
git commit -m "{message}"
```

Check `git status` after each commit. Stop on error.

## Key Principles

- Split finely: 1 commit = 1 feature
- Japanese required for messages
- Always get user approval before executing
- Execute sequentially (not parallel)
- Consult `references/commit-patterns.md` when uncertain

## Commit Independence (コミット独立性)

各コミットは削除してもビルドが通る状態を保つ。

### 依存関係に基づく順序

コミット順序は依存関係の下流から上流へ:

1. モデル（データ構造の定義）
2. プロバイダー（状態管理・ビジネスロジック）
3. ウィジェット（UI コンポーネント）
4. 画面（ページ全体）

### 機能単位での分割

1ファイル内でも複数機能は別コミットに分割:
- 作成機能 → 保存機能 → 編集機能 → 削除機能

例: `memo_provider.dart` に複数機能がある場合
```
コミット1: ✨ メモ作成機能を追加
コミット2: ✨ メモ保存機能を追加
コミット3: ✨ メモ編集機能を追加
コミット4: ✨ メモ削除機能を追加
```

### 独立性チェック

各コミット提案時に確認:
- 各コミットが単独で動作可能か
- 未使用のimportや参照がないか
- ビルドエラーが発生しないか
