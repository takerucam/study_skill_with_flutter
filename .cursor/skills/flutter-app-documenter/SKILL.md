---
name: flutter-app-documenter
description: Analyze Flutter applications and generate comprehensive markdown documentation for each feature. Create one markdown file per feature in docs/features/ directory, covering UI components, data models, state management (Riverpod/Provider), user flows, and implementation details. Use when users request to "summarize features," "document features," "create feature documentation," or "analyze Flutter app structure."
---

# Flutter App Documenter

## Overview

Analyze Flutter/Dart code and generate feature documentation as separate markdown files. Each feature gets its own file in `docs/features/` with sections for UI components, data models, state management, user flows, and implementation details.

## Workflow

### 1. Analyze Project Structure

Start by reading key files to understand the app:

```
1. Read pubspec.yaml - identify dependencies (Riverpod, Freezed, etc.)
2. List lib/ directory - find models/, providers/, widgets/, screens/
3. Read main.dart - understand app entry point and routing
```

### 2. Identify Features

Use pattern recognition from `references/flutter-patterns.md` to identify features:

- **From Providers**: `@riverpod` classes/functions indicate state management
- **From Widgets**: `ConsumerWidget`, `HookConsumerWidget` classes
- **From Models**: `@freezed` classes define data structures
- **From Methods**: Provider methods (addTodo, toggleTodo) indicate operations

Group related components into features. Example:
- TODO追加機能 = TodoInput widget + TodoPod.addTodo() + Todo model

### 3. Generate Documentation Files

For each identified feature, create a markdown file in `docs/features/`:

**Filename convention**: `{feature_name_in_snake_case}.md`

Use `assets/template.md` as the structure template. Replace placeholders:
- `{機能名}`: Feature name in Japanese or English
- `{画面構成}`: List of related widgets
- `{データモデル}`: Models used by this feature
- `{状態管理}`: Providers and methods
- `{ユーザーフロー}`: Step-by-step user actions (use mermaid or list)
- `{実装詳細}`: File paths and key code snippets

### 4. Create docs/features/ Directory

If `docs/features/` doesn't exist, create it:

```bash
mkdir -p docs/features
```

### 5. Write Feature Files

Write each feature documentation file to `docs/features/{feature_name}.md`.

## Pattern Recognition Guide

Consult `references/flutter-patterns.md` for detailed patterns on:

- Identifying Riverpod Providers (`@riverpod` annotation)
- Recognizing Freezed models (`@freezed`, `part`, factory constructors)
- Detecting widget types (ConsumerWidget, HookConsumerWidget)
- Finding dependencies (ref.watch, ref.read)
- Tracing routing and navigation

## Example Output Structure

For a TODO app with 4 features, generate:

```
docs/
└── features/
    ├── todo_add.md         # TODO追加機能
    ├── todo_toggle.md      # 完了/未完了切り替え機能
    ├── todo_delete.md      # TODO削除機能
    └── todo_filter.md      # フィルタリング機能
```

Each file follows the template structure with:
1. Feature name as title
2. UI components used
3. Data models involved
4. State management (Providers/methods)
5. User flow diagram or steps
6. Implementation details (file paths, code)

## Key Points

- **One feature = One file**: Never create a "feature list" section
- **Output location**: Always use `docs/features/` directory at project root
- **Template usage**: Follow `assets/template.md` structure consistently
- **Pattern reference**: Use `references/flutter-patterns.md` when identifying code patterns
- **Mermaid diagrams**: Use for user flows when visualizing steps helps understanding
- **Code snippets**: Include relevant code only when it clarifies the feature implementation

## Resources

- **assets/template.md**: Template for each feature documentation file
- **references/flutter-patterns.md**: Pattern recognition guide for Flutter/Riverpod code analysis
