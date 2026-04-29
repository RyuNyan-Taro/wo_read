# デザインシステムの適用

## Context

`.junie/design/DESIGN.md` と `design_palette.png` で「Nobi-Nobi Note」デザインシステムが定義された。現在のアプリは `Colors.deepPurple` をシードカラーとして使い、各ウィジェットに色がハードコードされている。このプランでデザイントークンを一元化し、アプリ全体に反映させる。

---

## Approach

Material 3 の `ColorScheme` を明示的なカラートークン（DESIGN.md の hex 値）で構築し、Plus Jakarta Sans フォントを `google_fonts` パッケージ経由で適用する。すべてのトークンを `lib/common/app_theme.dart` に集約し、`main.dart` の `ThemeData` を差し替えることで、各画面を個別修正せずにテーマを伝播させる。その上で `lib/common/` の3ウィジェットも新テーマに準拠させる。

---

## File Changes

### 1. `pubspec.yaml` — **Modify**
- `dependencies` に `google_fonts: ^6.2.1` を追加

### 2. `lib/common/app_theme.dart` — **Create**
デザイントークンを集約するファイル。以下を定義：

**`AppColors`** (static const Color) — DESIGN.md の全カラートークンを Color 定数で管理

| トークン | hex |
|---|---|
| primary | #94492b |
| onPrimary | #ffffff |
| primaryContainer | #ff9e7a |
| onPrimaryContainer | #783317 |
| inversePrimary | #ffb59b |
| secondary | #366853 |
| onSecondary | #ffffff |
| secondaryContainer | #b8eed3 |
| onSecondaryContainer | #3c6e58 |
| tertiary | #765b06 |
| onTertiary | #ffffff |
| tertiaryContainer | #d6b35b |
| onTertiaryContainer | #5b4500 |
| error / onError / errorContainer / onErrorContainer | ... |
| surface | #fff8f5 |
| onSurface | #211a16 |
| surfaceContainerLowest〜Highest | #ffffff〜#ede0d9 |
| onSurfaceVariant | #54433d |
| outline / outlineVariant | #87736c / #dac1b9 |
| inverseSurface / onInverseSurface | #362f2b / #fceee7 |
| surfaceTint | #94492b |

**`AppTheme.themeData`** — 以下を含む ThemeData:
- `ColorScheme` に上記を明示的に設定
- `textTheme`: Plus Jakarta Sans で DESIGN.md の typography を再現
  - displayLarge: 40px/700, headlineMedium: 24px/600, headlineSmall: 20px/600
  - bodyLarge: 18px/400, bodyMedium: 16px/400, labelMedium: 14px/500
- `appBarTheme`: backgroundColor=surfaceContainerHigh, elevation=0
- `cardTheme`: elevation=0, borderRadius=16px, color=surfaceContainerLow
- `elevatedButtonTheme`: StadiumBorder, primaryContainer/onPrimaryContainer
- `floatingActionButtonTheme`: StadiumBorder, primaryContainer/onPrimaryContainer
- `inputDecorationTheme`: filled, fillColor=surfaceContainerHigh, 12px radius, focusedBorder=primary 2px
- `dialogTheme`: 16px borderRadius, surfaceContainerLowest background

### 3. `lib/main.dart` — **Modify**
- `import 'package:wo_read/common/app_theme.dart';` を追加
- `theme: ThemeData(colorScheme: ColorScheme.fromSeed(...), useMaterial3: true)` → `theme: AppTheme.themeData`

### 4. `lib/common/action_indicator.dart` — **Modify**
- `AlwaysStoppedAnimation(Colors.lightBlue)` → `AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary)`
- `const` を除去して context アクセスを可能にする

### 5. `lib/common/success_dialog.dart` — **Modify**
- title に `style: Theme.of(context).textTheme.headlineSmall` を追加
- OK ボタンに `style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary)` を追加

### 6. `lib/common/add_record_button.dart` — 変更なし
- `floatingActionButtonTheme` を自動継承するため修正不要

---

## Implementation Steps

1. `pubspec.yaml` — `google_fonts: ^6.2.1` を追加
2. `lib/common/app_theme.dart` を新規作成
3. `lib/main.dart` — import 追加 + theme 差し替え
4. `lib/common/action_indicator.dart` — lightBlue → theme primary
5. `lib/common/success_dialog.dart` — textTheme + foregroundColor 適用

---

## Acceptance Criteria

- [ ] `flutter analyze` がエラーなしで完了する
- [ ] アプリ起動時、背景が `#fff8f5` のオフホワイトになっている
- [ ] AppBar の背景が `#f3e5df` (surfaceContainerHigh) になっている
- [ ] ElevatedButton がピル形状でコーラル色 (#ff9e7a) になっている
- [ ] FAB がコーラル色 (#ff9e7a) になっている
- [ ] CircularProgressIndicator がプライマリカラー (#94492b) になっている
- [ ] テキストが Plus Jakarta Sans で表示されている
- [ ] Card の角丸が 16px になっている

## Verification Steps

```bash
flutter pub get
flutter analyze
flutter run
```

手動確認: Home・Record・Cook 画面で AppBar 色・ボタン形状・背景色・フォントを目視確認

## Risks & Mitigations

| リスク | 対策 |
|---|---|
| `google_fonts` が初回起動時にネットワーク取得する | オフライン時はシステムフォントにフォールバックするため機能は維持される |
| 既存画面のハードコード色（orangeAccent 等）がテーマカラーと競合する | このプランでは common/ と main.dart のみ変更。個別画面は別タスクとして分離 |
| ColorScheme コンストラクタに不足パラメータがある場合コンパイルエラー | `flutter analyze` で早期検出。不足時は `copyWith` で対応 |