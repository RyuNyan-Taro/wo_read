## 1. Goal
GalleryBody、AddImagePage、AddCategoryPage の見た目を `lib/common/app_theme.dart` の色・タイポグラフィに統一し、`CookBody` の写真カード感と `RecordBody` の余白・セクション・白カード表現に親和性のある UI にする。

## 2. Approach
既存の `AppTheme` は `AppColors`、Material 3、Plus Jakarta Sans、丸みのある AppBar/FAB/Input を定義済みなので、Gallery 側では独自色や `inversePrimary` 上書きを減らし、`AppColors` と `Theme.of(context).textTheme` を直接使う。`GalleryBody` は `CookBody` の `SingleChildScrollView` + 見出し + bento grid 構成（`lib/cook/cook.dart:48-58`, `lib/cook/cook.dart:71-104`）と、`CookItemCard` の白カード・角丸・影・画像プレースホルダー（`lib/cook/screens/cook_item_card.dart:17-30`, `lib/cook/screens/cook_item_card.dart:93-118`）に寄せる。フォーム系 2 ページは `RecordBody` の余白と白カード（`lib/record/record.dart:62-71`, `lib/record/record.dart:216-231`）を採用しつつ、現在の `AddImagePage` の画像未選択クラッシュ（`lib/gallery/screens/add_image_page.dart:22`, `lib/gallery/screens/add_image_page.dart:46`）と `AddCategoryPage` のカテゴリ読込中 validator クラッシュ（`lib/gallery/screens/add_category_page.dart:74-88`）も UI 状態として整理する。

## 3. File Changes
- **Modify** `lib/gallery/gallery.dart:1-85`
  - `package:wo_read/common/app_theme.dart` を import し、`GalleryBody` の一覧を現状の縦一列画像（`lib/gallery/gallery.dart:43-80`）から、見出し・セクションヘッダー・bento grid・角丸画像カードへ変更する。
  - `Positioned` の FAB グループを `left: 16, bottom: 16`（`lib/gallery/gallery.dart:46-55`）から Cook/Record と同じ右下寄せ（`lib/cook/cook.dart:62-65`, `lib/record/record.dart:47-50`）へ変更する。
  - 画像カード用の private widget/helper を同ファイル内に追加し、`CachedNetworkImage` の placeholder/error を `AppColors.surfaceContainerHigh` と `Icons.no_photography` に統一する。

- **Modify** `lib/gallery/screens/add_image_page.dart:1-63`
  - `package:wo_read/common/app_theme.dart` と `package:wo_read/common/action_indicator.dart` を import する。
  - `initState` の非同期画像選択（`lib/gallery/screens/add_image_page.dart:20-23`）を `WidgetsBinding.instance.addPostFrameCallback` 経由の `_handlePickImage()` に変更し、選択後に `setState` する。
  - `File(_controller.image!.path)` の強制 unwrap（`lib/gallery/screens/add_image_page.dart:45-47`）を、未選択時プレースホルダー付きの 4:3 画像プレビューカードに置き換える。
  - 既存の 2 つの `ElevatedButton`（`lib/gallery/screens/add_image_page.dart:51-58`）を、全幅の `OutlinedButton.icon` と `FilledButton.icon` に変更し、保存時は `showActionIndicator(context, _handleSave())` を使う。
  - AppBar タイトルを日本語の `画像を追加` にし、`backgroundColor: inversePrimary` の個別指定（`lib/gallery/screens/add_image_page.dart:36-39`）を外して `AppTheme.appBarTheme`（`lib/common/app_theme.dart:133-152`）へ委ねる。

- **Modify** `lib/gallery/screens/add_category_page.dart:1-109`
  - `package:wo_read/common/app_theme.dart` を import する。
  - AppBar タイトルを誤った `Add record`（`lib/gallery/screens/add_category_page.dart:66-68`）から `カテゴリーを追加` に変更し、AppBar 背景の個別指定を外す。
  - `body: Column`（`lib/gallery/screens/add_category_page.dart:70-105`）を `SingleChildScrollView` + `Padding(horizontal: 20, vertical: 16)` + 白いフォームカードに変更し、Record の余白・カード表現（`lib/record/record.dart:62-71`, `lib/record/record.dart:216-231`）に寄せる。
  - `_categories` 読込中は `CircularProgressIndicator` または入力 disabled 状態を表示し、`_categories!.contains(value)`（`lib/gallery/screens/add_category_page.dart:87`）を null-safe にする。
  - `AutovalidateMode.always`（`lib/gallery/screens/add_category_page.dart:74`）を `onUserInteraction` に変更し、入力中だけ validation を出す。
  - 追加ボタン（`lib/gallery/screens/add_category_page.dart:94-103`）を全幅 `FilledButton.icon` に変更し、`AppColors.primaryContainer` / `onPrimaryContainer` と 56px 高のフォーム系ボタンに統一する。

## 4. Implementation Steps
### Task 1: Gallery 一覧の構造を Cook/Record 寄りにする
1. `lib/gallery/gallery.dart:1-7` に `package:wo_read/common/app_theme.dart` を追加 import する。
2. `lib/gallery/gallery.dart:28-35` の `_getGalleries()` に `if (!mounted) return;` を追加し、Cook 側の mounted guard（`lib/cook/cook.dart:24-32`）に合わせる。
3. `lib/gallery/gallery.dart:41-45` を `SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 120))` に置き換え、`Column(crossAxisAlignment: CrossAxisAlignment.start)` の先頭へ `Text('ギャラリー', style: Theme.of(context).textTheme.headlineMedium)` とセクションヘッダーを配置する。
4. `lib/gallery/gallery.dart:46-55` の FAB 位置を `right: 16, bottom: 20` に変更し、縦積みの順序は `addImageButton` → `addCategoryButton` のまま維持する。
5. `lib/gallery/gallery.dart:62-84` の `_galleriesList` を `_bentoGrid(List<GalleryItem>)` に差し替え、先頭 1 件は全幅 featured card、2 件目以降は `Row` + `Expanded` の 2 カラムにする。間隔は Cook と同じ `12` を使う（`lib/cook/cook.dart:85-92`）。
6. `lib/gallery/gallery.dart` に `_GalleryPhotoCard` private widget を追加し、`Container` の `BoxDecoration` は `AppColors.surfaceContainerLowest`、featured は `borderRadius: 24`、通常は `16`、`Border.all(color: AppColors.surfaceContainerHigh, width: 0.5)`、`BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 30, offset: Offset(0, 8))` として `CookItemCard`（`lib/cook/screens/cook_item_card.dart:17-30`）に合わせる。
7. `_GalleryPhotoCard` の画像領域は featured `192.0`、通常 `132.0` の `SizedBox` にし、`CachedNetworkImage` の `fit: BoxFit.cover`、placeholder/error は `AppColors.surfaceContainerHigh` + `CircularProgressIndicator` / `Icons.no_photography` にする（`lib/cook/screens/cook_item_card.dart:52-68`, `lib/cook/screens/cook_item_card.dart:93-118`）。

### Task 2: AddImagePage を画像プレビュー中心のフォーム画面にする
1. `lib/gallery/screens/add_image_page.dart:5-7` に `action_indicator.dart` と `app_theme.dart` の import を追加する。
2. `lib/gallery/screens/add_image_page.dart:20-23` の `initState` を、`WidgetsBinding.instance.addPostFrameCallback((_) => _handlePickImage())` に変更する。
3. `_handlePickImage()` を追加し、`await _controller.pickImage(); if (mounted) setState(() {});` の形で画像選択後に再描画する。
4. `lib/gallery/screens/add_image_page.dart:35-61` の body を `SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16))` に置き換え、`Text('画像を追加', headlineMedium)`、説明用の `labelMedium`、画像プレビュー、操作ボタンの順に配置する。
5. `lib/gallery/screens/add_image_page.dart:42-50` の固定 `SizedBox(height: 300)` と `File(_controller.image!.path)` を `_ImagePreviewCard` private widget に移し、`_controller.image == null` なら `AppColors.surfaceContainerHigh` 背景、`Icons.add_photo_alternate_outlined`、`Text('画像を選択')` を表示する。
6. プレビューカードは `AspectRatio(aspectRatio: 4 / 3)`、`borderRadius: 24`、`Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4))`、`clipBehavior: Clip.antiAlias` を使い、Cook の画像プレビューの安定した比率（`lib/cook/screens/cook_form_page.dart:166-189`）と Gallery 用の色に合わせる。
7. `lib/gallery/screens/add_image_page.dart:51-58` のボタンを、画像選択用 `OutlinedButton.icon(icon: Icons.photo_library_outlined)` と保存用 `FilledButton.icon(icon: Icons.check_circle_outline)` に変更し、保存ボタンは `_controller.image != null` のときだけ有効にする。
8. `_handleSave()` 呼び出しは `showActionIndicator(context, _handleSave())` に包み、既存の保存成功ダイアログ（`lib/gallery/screens/add_image_page.dart:25-30`）は維持する。

### Task 3: AddCategoryPage を Record 風のフォームカードにする
1. `lib/gallery/screens/add_category_page.dart:1-4` に `app_theme.dart` import を追加する。
2. `lib/gallery/screens/add_category_page.dart:66-69` の AppBar を `title: const Text('カテゴリーを追加')` のみにし、個別背景色を削除する。
3. `lib/gallery/screens/add_category_page.dart:70-105` を `SingleChildScrollView` + `Padding(horizontal: 20, vertical: 16)` に変更し、`Text('カテゴリーを追加', headlineMedium)`、`labelMedium` の補足、フォームカード、追加ボタンの順にする。
4. フォームカードは `Container(width: double.infinity, padding: EdgeInsets.all(16))`、`AppColors.surfaceContainerLowest`、`borderRadius: 16`、`Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))`、軽い `BoxShadow` を使い、Record の timeline item カード（`lib/record/record.dart:216-231`）に合わせる。
5. `lib/gallery/screens/add_category_page.dart:73-92` の `Form` はカード内に移し、`AutovalidateMode.onUserInteraction`、`TextFormField` の `prefixIcon: Icon(Icons.sell_outlined)`、`labelText: 'カテゴリー名'`、`hintText: '例: おでかけ'` に変更する。
6. `lib/gallery/screens/add_category_page.dart:83-91` の validator は `final text = value?.trim() ?? ''; if (text.isEmpty) return 'カテゴリー名を入力してください'; if ((_categories ?? const <String>[]).contains(text)) return '既に存在するカテゴリーです';` として null-safe にする。
7. `lib/gallery/screens/add_category_page.dart:37-43` の `_getCategories()` に `if (!mounted) return;` を追加し、読込中は `TextFormField(enabled: false)` またはカード内ローディングを出す。
8. `lib/gallery/screens/add_category_page.dart:45-53` の `_saveCategory` 呼び出し時に `descriptionController.text.trim()` を渡し、空白だけのカテゴリ登録を防ぐ。
9. `lib/gallery/screens/add_category_page.dart:94-103` の `ElevatedButton` を 56px 高の全幅 `FilledButton.icon` に置き換え、`_isFormValid && _categories != null` のときのみ有効にする。

## 5. Acceptance Criteria
- `lib/gallery/gallery.dart` の一覧画面に `ギャラリー` 見出しが表示され、Cook の `食事の記録` 見出し（`lib/cook/cook.dart:53-56`）と同じ `headlineMedium` を使っている。
- `lib/gallery/gallery.dart` の画像一覧は、1 件目が全幅カード、2 件目以降が 2 カラムカードで表示され、各カード間の横・縦余白が 12px である。
- `lib/gallery/gallery.dart` の画像カードは `AppColors.surfaceContainerLowest`、`AppColors.surfaceContainerHigh`、`AppColors.primary.withValues(alpha: 0.08)` を使い、Cook のカード装飾（`lib/cook/screens/cook_item_card.dart:17-30`）と同系統になっている。
- `lib/gallery/gallery.dart` の FAB グループは右下 `right: 16, bottom: 20` に表示され、Cook/Record の FAB 配置（`lib/cook/cook.dart:62-65`, `lib/record/record.dart:47-50`）と揃っている。
- `lib/gallery/screens/add_image_page.dart` は画像未選択状態でも `File(_controller.image!.path)` に到達せず、プレースホルダーを表示する。
- `lib/gallery/screens/add_image_page.dart` の保存ボタンは画像未選択時に disabled、画像選択後に enabled になる。
- `lib/gallery/screens/add_image_page.dart` の AppBar は `backgroundColor: Theme.of(context).colorScheme.inversePrimary` を指定せず、`AppTheme.appBarTheme`（`lib/common/app_theme.dart:133-152`）を使う。
- `lib/gallery/screens/add_category_page.dart` の AppBar タイトルは `カテゴリーを追加` で、誤った `Add record` は残っていない。
- `lib/gallery/screens/add_category_page.dart` は `_categories == null` の間に validator が走っても例外を投げない。
- `lib/gallery/screens/add_category_page.dart` は空文字・空白のみ・既存カテゴリ名を追加できず、それぞれ入力エラーまたは disabled 状態で保存されない。
- `lib/gallery/screens/add_category_page.dart` のフォームカードは `AppColors.surfaceContainerLowest`、`AppColors.outlineVariant.withValues(alpha: 0.3)`、16px 角丸を使い、Record のカード（`lib/record/record.dart:216-231`）と視覚的に揃っている。
- 変更後に `flutter analyze` が Gallery 関連の新規 analyzer error を出さない。

## 6. Verification Steps
1. `flutter analyze` を実行し、`lib/gallery/gallery.dart`、`lib/gallery/screens/add_image_page.dart`、`lib/gallery/screens/add_category_page.dart` に新規 error がないことを確認する。
2. アプリを起動し、BottomNavigation の `ギャラリー` タブを開く。画像が 0 件の場合は空状態が崩れず、1 件の場合は全幅カード、3 件以上の場合は 1 件目全幅 + 2 カラムで表示されることを確認する。
3. Gallery 画面の右下 FAB から画像追加画面を開き、画像選択をキャンセルする。画面がクラッシュせず、プレースホルダーと disabled 保存ボタンが表示されることを確認する。
4. 画像追加画面で画像を選択し直し、プレビューが 4:3 の角丸カード内に表示され、保存ボタンが有効化されることを確認する。
5. 画像保存を実行し、処理中インジケータと `画像が追加されたよ` ダイアログが表示され、閉じると Gallery へ戻ることを確認する。
6. Gallery 画面の右下 FAB からカテゴリ追加画面を開き、カテゴリ読込中でも入力欄やローディング表示が崩れないことを確認する。
7. カテゴリ追加画面で空欄、空白のみ、既存カテゴリ名、新規カテゴリ名を試し、空欄/空白/既存名は保存不可、新規名は `カテゴリーが追加されたよ` ダイアログ後に戻ることを確認する。
8. 小さい端末幅のエミュレータで Gallery 一覧、画像追加、カテゴリ追加を開き、カード・ボタン・テキストが横 overflow しないことを確認する。

## 7. Risks & Mitigations
- `AddImagePage` は現在 `initState` 直後に `pickImage()` を呼び、その完了前に `image!` を参照する構造（`lib/gallery/screens/add_image_page.dart:20-23`, `lib/gallery/screens/add_image_page.dart:45-47`）なのでクラッシュしやすい。`_handlePickImage()` と null-safe preview に置き換えて、キャンセル時も画面を成立させる。
- `AddCategoryPage` は `_categories!` を validator で強制 unwrap しており、`AutovalidateMode.always` により読込前に例外化する可能性がある（`lib/gallery/screens/add_category_page.dart:74-88`）。`_categories ?? const <String>[]` と読込中 UI にして回避する。
- Gallery の写真は外部 URL 依存なので、読み込み失敗時に空白カードになりやすい（現状 `errorWidget` なし、`lib/gallery/gallery.dart:75-80`）。Cook と同様の error placeholder を入れて、失敗時もレイアウトを維持する。
- 2 つの FAB を右下に積むと下部ナビゲーションと近くなる可能性がある。`SingleChildScrollView` の下 padding を 120px にし、`bottom: 20` の FAB とリスト末尾が重ならないようにする。