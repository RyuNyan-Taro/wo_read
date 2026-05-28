# AddRecordPage / ModifyRecordPage デザイン統一計画

## Context
`AddRecordPage` と `ModifyRecordPage` は `AppTheme` のデザイントークンを無視した独自スタイル（`inversePrimary` AppBar 背景、`OutlineInputBorder` 直書き等）を持ち、`RecordBody` と視覚的に乖離している。`app_theme.dart` のテーマ定義と `record.dart` のレイアウトパターンに統一する。

## Goal
`lib/record/screens/add_record.dart` と `lib/record/screens/modify_record.dart` のUI を `record.dart` のデザイン言語に合わせる。ロジック変更なし、スタイル・レイアウトのみ。

## Approach
- 独自カラー指定を削除し、`AppTheme` のウィジェットテーマが自動適用されるようにする
- `record.dart` の `_recordsSet` / `_TimelineItem` と同じレイアウト構造・カラー定数を使用
- 新規ファイル・新規クラスは一切作成しない

## File Changes

| ファイル | 種別 | 変更内容 |
|---|---|---|
| `lib/record/screens/add_record.dart` | Modify | 全UI変更 |
| `lib/record/screens/modify_record.dart` | Modify | 全UI変更（型セレクタ・2ボタン対応あり） |

---

## add_record.dart の変更

### Step A-1: Import追加
`app_theme.dart` を import して `AppColors.*` を参照可能にする。

### Step A-2: AppBar 修正
- `backgroundColor: Theme.of(context).colorScheme.inversePrimary` を削除
- title を `'記録を追加'` に変更
- → `AppBarTheme`（`surfaceContainerLowest` 背景、丸底角、styled title）が自動適用

### Step A-3: Body を ScrollView + Padding に変更
`record.dart` の `_recordsSet` と同じ `SingleChildScrollView > Padding(horizontal:20, vertical:32) > Column(crossAxisAlignment: start)` 構造に変更。

### Step A-4: 日付選択ボタン → スタイル付きカード
`ElevatedButton` を `InkWell(borderRadius:16)` + `Container` に置き換え。`_TimelineItem` のカードスタイルを踏襲:
- `color: AppColors.surfaceContainerLowest`, `borderRadius:16`, `outlineVariant.withValues(alpha:0.3)` border, shadow
- 内部: `Row(Icon(calendar_today, size:18, AppColors.outline) + SizedBox(10) + Text(yyyy/MM/dd, w500/16/onSurface))`

### Step A-5: セクションヘッダー追加
日付カードと TextFormField の間に `SizedBox(20)` + `Row(Icon(edit_note, outlineVariant, 22) + SizedBox(6) + Text('活動内容', w600/20/onSurface))` + `SizedBox(12)` を挿入。

### Step A-6: TextFormField の InputDecoration 修正
- `border: OutlineInputBorder()` を削除（`InputDecorationTheme` が適用される）
- `labelText: "content"` → `hintText: 'メモ'`
- `key: formKey`・`autofocus: true`・`controller` はそのまま維持

### Step A-7: 追加ボタンを全幅に
`SizedBox(height:24)` + `SizedBox(width: double.infinity, child: ElevatedButton(...))` でラップ。

---

## modify_record.dart の変更

### Step M-1: Import追加
`app_theme.dart` を import して `AppColors.*` を参照可能にする。

### Step M-2: AppBar 修正
- `backgroundColor: Theme.of(context).colorScheme.inversePrimary` を削除
- title を `'記録を編集'` に変更

### Step M-3: Body を ScrollView + Padding に変更
`add_record.dart` と同じ `SingleChildScrollView > Padding(horizontal:20, vertical:32) > Column(crossAxisAlignment: start)` 構造に変更。

### Step M-4: `_buildDatePicker` を日付カードに変更
`add_record.dart` と同じカードスタイル（`InkWell + Container`）に変更。フォーマットを `'yyyy/MM/dd'` に統一。

### Step M-5: セクションヘッダー（タグ）追加
日付カードと `_buildTypeSelectors` の間に `SizedBox(20)` + `Row(Icon(label_outline, outlineVariant, 22) + SizedBox(6) + Text('タグ', w600/20/onSurface))` + `SizedBox(12)` を挿入。

### Step M-6: `_buildTypeSelectors` のスタイル統一
`DropdownButton` を `DropdownButtonFormField` に変更（`AppTheme` の `InputDecorationTheme` が自動適用。filled/rounded スタイルに統一）。AI ボタン（SVG アイコン）はそのまま維持。

```dart
DropdownButtonFormField<String>(
  value: _controller.feeling.name,
  decoration: const InputDecoration(labelText: 'きもち'),
  items: FeelingType.values.map(...).toList(),
  onChanged: (v) { if (v != null) setState(() { _controller.feeling = convertToFeelingType(label: v); }); },
),
```

### Step M-7: '活動内容' セクションヘッダー追加
`_buildTypeSelectors` と `_buildContentField` の間に `SizedBox(20)` + `Row(Icon(edit_note, ...) + Text('活動内容', ...))` + `SizedBox(12)` を挿入。

### Step M-8: `_buildContentField` の InputDecoration 修正
- `border: OutlineInputBorder()` を削除
- `labelText: "content"` → `hintText: 'メモ'`

### Step M-9: `_buildActionButtons` をスタイル統一
`Column` で縦配置・全幅:
- '変更': `SizedBox(width: double.infinity, child: ElevatedButton(...))`
- '削除': `SizedBox(width: double.infinity, child: OutlinedButton(..., style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: BorderSide(color: AppColors.error))))`

---

## Acceptance Criteria
### add_record.dart
- AppBar 背景が `surfaceContainerLowest`、タイトル `'記録を追加'` が表示
- 日付がカードスタイルで表示される
- '活動内容' セクションヘッダーが表示される
- TextFormField が filled/rounded スタイル（`InputDecorationTheme` 適用）
- '追加' ボタンが全幅
- 日付選択・保存・ダイアログ・画面pop が正常動作

### modify_record.dart
- AppBar 背景が `surfaceContainerLowest`、タイトル `'記録を編集'` が表示
- 日付がカードスタイルで表示される
- `DropdownButtonFormField` がテーマ統一スタイルで表示
- 'タグ'・'活動内容' セクションヘッダーが表示される
- TextFormField が filled/rounded スタイル
- '変更' ボタンが全幅 ElevatedButton スタイル
- '削除' ボタンが全幅 OutlinedButton エラー色スタイル
- 変更・削除・AI ラベル・ダイアログ・画面pop が正常動作

## Verification Steps
1. `flutter analyze` でエラーなし
2. FAB → `AddRecordPage`: 外観確認 → 日付選択 → テキスト入力 → 追加 → 一覧に戻る
3. タイムラインアイテムをタップ → `ModifyRecordPage`: 各フィールド操作 → 変更・削除それぞれ動作確認

## Risks & Mitigations
- **`formKey`**: `TextFormField` の `key` として使われているが `Form` に渡されていない（既存のバグ）。今回は変更しない。
- **`DropdownButton` → `DropdownButtonFormField`**: API 互換。`onChanged` の型 `String?` はそのまま動作する。
- **削除ボタンの色**: 元は `TextStyle(color: Colors.red)` 直指定。`AppColors.error` で置き換えデザイントークンに統一。