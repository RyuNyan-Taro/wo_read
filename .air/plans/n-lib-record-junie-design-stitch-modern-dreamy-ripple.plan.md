# Plan: lib/record UI Redesign — glow_record Design

## Context
`.junie/design/stitch_modern_family_growth_cooking/glow_record/` に新しいデザイン案が追加された。
現在の `lib/record` は機能的だが最小限の UI（シンプルな Card リスト + fl_chart の棒グラフ/円グラフ）になっている。
新デザインはウォームなカラーパレットを維持しつつ、以下 3 つのセクションへ刷新する：

1. **感情バランス** — ドーナツグラフ（中央に記録数）＋右側凡例（%表示）
2. **発達バランス** — 横プログレスバー（白い丸インジケーター付き）
3. **日々の活動** — タイムライン（縦線 + 色付き丸マーカー + ハッシュタグチップ付きカード）

既存の `AppTheme` / `AppColors` はすでにデザインのカラートークン（primaryContainer = `#FF9E7A`、secondaryContainer = `#B8EED3`、tertiaryContainer = `#D6B35B` 等）と一致しているため追加不要。

---

## Approach
- 変更対象は **2 ファイルのみ**（`record_analysis_section.dart` と `record.dart`）
- `fl_chart` の `PieChart` は `centerSpaceRadius` を使いドーナツ化し、Stack で中央ラベルを重ねる
- バーチャートは fl_chart を廃止し、`LayoutBuilder` + `Container` で横プログレスバーを実装
- タイムラインは `IntrinsicHeight` + `Row(Column[dot+Expanded line], content)` で縦線を実現
- 月齢（LunarAge）の計算は既存の `convertToLunarAge()` を再利用

---

## File Changes

### Modify: `lib/record/screens/record_analysis_section.dart`

**変更点：**

#### `RecordAnalysisSection.build()`
- `_FeelingPieChart` と `_DenverBarChart` を縦に並べるシンプルな `Column` を維持
- 各セクションに `_SectionHeader(icon, label)` プライベートウィジェットを追加（Icon + headlineSmall text）
- 外側ラッパーを白背景・角丸・サブトルシャドウ・outline-variant/50 ボーダーの Card に変更

#### `_FeelingPieChart` → `_FeelingDonutChart`（クラス名変更）
```
Card(color: surfaceContainerLowest) 
  └─ Padding(20)
      └─ Column
           ├─ _SectionHeader(Icons.mood, '感情バランス', color: primaryContainer)
           ├─ SizedBox(12)
           └─ Row
                ├─ SizedBox(128x128): Stack
                │    ├─ PieChart(centerSpaceRadius: 38, sections without text)
                │    └─ Center: Column['記録数' labelMedium, total headlineSmall]
                └─ Expanded: Column(gap 4)
                     └─ FeelingType values(except none, count > 0) each:
                          Row(justify: spaceBetween)
                            ├─ Row: [Container(12x12 circle, color), Text(feelingToJp)]
                            └─ Text('${pct}%', bold)
```

カラーマッピング（FeelingType → Color）:
- happiness → `AppColors.tertiaryContainer` (#D6B35B)
- pleasure  → `AppColors.primaryContainer` (#FF9E7A)
- sorrow    → `AppColors.secondaryContainer` (#B8EED3)
- anger     → `AppColors.errorContainer` (#FFDAD6)
- none      → `AppColors.outlineVariant`

#### `_DenverBarChart` → `_DenverProgressBars`（クラス名変更）
```
Card(color: surfaceContainerLowest)
  └─ Padding(20)
      └─ Column
           ├─ _SectionHeader(Icons.psychology, '発達バランス', color: secondaryContainer shade)
           ├─ SizedBox(12)
           └─ DenverType values(except none) each Column:
                ├─ Row(spaceBetween): [Text(denverToJp), Text(count, outline color)]
                ├─ SizedBox(4)
                └─ LayoutBuilder → Stack:
                     ├─ Container(h:12, full-width, color: surfaceVariant, borderRadius 6)
                     └─ FractionallySizedBox(widthFactor: count/maxCount):
                          Stack(clipBehavior: none):
                            ├─ Container(h:12, color: barColor, borderRadius 6)
                            └─ Positioned(right:2): Container(12x12 circle, white, shadow)
```

バーカラーマッピング（DenverType → Color）:
- personalSocial    → `AppColors.primaryContainer`
- fineMotorAdaptive → `AppColors.secondaryContainer`
- language          → `AppColors.tertiaryContainer`
- grossMotor        → `Color(0xFFFFB59B)` (primary-fixed-dim)

---

### Modify: `lib/record/record.dart`

#### `_recordsSet()` の変更
- 現行の `groupByLunarAge()` によるグルーピングレイアウトを廃止
- 新しいレイアウト：
```
SingleChildScrollView
  └─ Padding(horizontal: 20, vertical: 32)
      └─ Column
           ├─ RecordAnalysisSection(records)
           ├─ SizedBox(48)
           ├─ _SectionHeader(Icons.history_edu, '日々の活動', color: outlineVariant)
           ├─ SizedBox(12)
           └─ _RecordTimeline(records, backAction, birthday)
```

#### `_lunarAgeRecords()` 関数 → 削除、`_RecordCard` → 削除

#### 新規プライベートウィジェット群

**`_RecordTimeline`** (StatelessWidget):
- `records` リストを `List.generate` でイテレート
- 各アイテムを `IntrinsicHeight(child: Row(...))` で描画
- 左カラム（width: 20）：
  - `Container(12x12, circle, color: dotColor)` — dotColor は感情タイプに対応
  - `Expanded(child: Center(child: Container(width:1, color: outlineVariant.withOpacity(0.4))))` — 縦線（最後のアイテムは非表示）

**`_TimelineItem`** (StatelessWidget):
```
Column(crossAxisAlignment: start)
  ├─ Text('${lunar.year}歳 ${lunar.month}ヶ月 • $relativeDate', labelMedium, color: outline)
  ├─ SizedBox(4)
  └─ InkWell(onTap: navigate to ModifyRecordPage)
       └─ Container(decoration: white, rounded-xl(16), shadow, border outlineVariant/30)
            └─ Padding(12)
                 └─ Column
                      ├─ Text(record.content, bodyMedium, maxLines: 3, overflow: ellipsis)
                      └─ Wrap(spacing:4, runSpacing:4)
                           ├─ if denver != none: _TagChip(denverToJp[denver], denverChipStyle)
                           └─ if feeling != none: _TagChip(feelingToJp[feeling], feelingChipStyle)
```

**`_formatRelativeDate()` ヘルパー**:
- 今日 → "今日 HH:mm"、昨日 → "昨日 HH:mm"、それ以外 → "MM/dd HH:mm"

**チップカラー（`_TagChip` ウィジェット）**:
- Denver personalSocial/grossMotor → bg: primaryContainer/10%, fg: primary
- Denver fineMotorAdaptive → bg: secondaryContainer/20%, fg: secondary
- Denver language → bg: tertiaryContainer/20%, fg: tertiary
- Feeling pleasure → bg: primaryContainer/10%, fg: primary
- Feeling happiness → bg: tertiaryContainer/20%, fg: tertiary
- Feeling sorrow → bg: secondaryContainer/20%, fg: secondary
- Feeling anger → bg: errorContainer/20%, fg: error

---

## Implementation Steps

### Task 1: `record_analysis_section.dart`
1. `_SectionHeader` ウィジェット追加
2. `_FeelingPieChart` → `_FeelingDonutChart` に変更（`PieChartData(centerSpaceRadius: 38)` + Stack で中央ラベル + 右凡例）
3. `_DenverBarChart` → `_DenverProgressBars` に変更（fl_chart 廃止 → LayoutBuilder + FractionallySizedBox）
4. `RecordAnalysisSection.build()` を新しい 2 セクション構成に更新

### Task 2: `record.dart`
1. `_formatRelativeDate()` ヘルパー追加
2. `_TagChip` ウィジェット追加
3. `_feelingDotColor()` ヘルパー追加
4. `_TimelineItem` ウィジェット実装
5. `_RecordTimeline` ウィジェット実装
6. `_recordsSet()` 更新（グルーピング廃止・新レイアウト）
7. `_lunarAgeRecords()` と `_RecordCard` 削除
8. 不要 import（`groupByLunarAge`）を削除し `convertToLunarAge` のみ使用

---

## Acceptance Criteria
- [ ] 感情バランス：ドーナツグラフ中央に「記録数 N」表示
- [ ] 感情バランス：右凡例に日本語ラベルと%表示
- [ ] 発達バランス：横プログレスバー + 白丸インジケーター表示
- [ ] 日々の活動：縦線 + 色付き丸マーカーのタイムライン表示
- [ ] 各アイテムに月齢・相対日付・ハッシュタグチップ表示
- [ ] カードタップ → ModifyRecordPage 遷移
- [ ] FAB タップ → AddRecordPage 遷移
- [ ] records 空でもクラッシュしない
- [ ] `flutter analyze` エラーなし

---

## Verification Steps
1. `flutter run` → 成長記録タブ選択
2. 感情バランスのドーナツ・中央ラベル・凡例%を目視確認
3. 発達バランスの横バー・白丸インジケーターを目視確認
4. タイムラインで月齢・縦線・色付き丸・チップを目視確認
5. タイムラインアイテムタップで ModifyRecordPage が開くことを確認
6. `flutter analyze` でエラーなしを確認

---

## Risks & Mitigations

| リスク | 対策 |
|---|---|
| `Stack(clipBehavior: Clip.none)` で白丸が親からはみ出す | バー高さ 12px・白丸 12px に統一し親 Container に overflow 制限なし |
| `IntrinsicHeight` の描画コスト | 最大 100 件程度のリストで問題なし |
| maxCount == 0 で widthFactor が NaN | `maxCount == 0` 時は widthFactor = 0 にガード |
