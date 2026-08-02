## Goal

Limit every startup-loaded record feed to its latest 20 entries, while preserving newest-first presentation and the existing page refresh behavior.

## Approach

Change the four service-layer read queries that feed the app’s record collections, rather than altering UI widgets or adding client-side slicing. This makes Supabase transfer only the required records on initial load and on the existing post-create/post-edit refreshes. Keep gallery category lookups unchanged: they support complete category selection and duplicate detection rather than a chronological feed, so applying a 20-item limit there would lose functionality.

## File Changes

- **Modify** `lib/record/service/record_service.dart:10-28` — reduce the growth-record query limit from 200 to 20; retain descending `timestamp` ordering.
- **Modify** `lib/record/service/morning_ready_service.dart:9-16` — change the default retrieval limit from 60 to 20; retain descending `record_date` ordering and the optional override API.
- **Modify** `lib/cook/service/cook_service.dart:14-34` — reduce the cooking feed query limit from 100 to 20; retain descending `createdAt` ordering.
- **Modify** `lib/gallery/service/gallery_service.dart:13-30` — reduce the gallery feed query limit from 100 to 20 and add descending `id` ordering, using the insertion ID as the available chronological key so the displayed set is deterministically the newest 20 photos.

No test files will be added: the existing service classes directly construct Supabase clients and the repository has no database-query test seam or service tests. Creating that infrastructure solely to assert a numeric query limit would expand the scope beyond this change.

## Implementation Steps

### Task 1: Cap the growth-record page data

1. In `lib/record/service/record_service.dart:10-15`, replace `.limit(200)` with `.limit(20)`. Preserve `.order('timestamp', ascending: false)` so the first 20 returned are the newest activity records.
2. In `lib/record/service/morning_ready_service.dart:9-14`, set the default `limit` parameter to 20. All current calls in `lib/record/record.dart:37-62` rely on that default, so initial load and the refresh after marking readiness will both use the same cap without UI changes.

### Task 2: Cap the cooking and gallery page data

3. In `lib/cook/service/cook_service.dart:14-19`, replace `.limit(100)` with `.limit(20)`, leaving the existing descending `createdAt` sort intact.
4. In `lib/gallery/service/gallery_service.dart:13-17`, add descending `id` ordering and replace `.limit(100)` with `.limit(20)`, ensuring the gallery’s featured first card and remaining grid receive the latest photos in a deterministic order.
5. Leave `GalleryService.getCategories()` at `lib/gallery/service/gallery_service.dart:32-39` unchanged, since `AddCategoryPage` and `ModifyCategoryPage` require the complete category set rather than a paginated/latest collection.

## Acceptance Criteria

- The growth-record query requests at most 20 rows and returns them newest-first by `timestamp`.
- The morning-readiness query requests at most 20 rows when called without an explicit limit and returns them newest-first by `record_date`.
- The cooking query requests at most 20 rows and returns them newest-first by `createdAt`.
- The gallery query requests at most 20 rows and returns them newest-first by descending `id`.
- Existing initial-load and refresh call sites in `lib/record/record.dart:34-67`, `lib/cook/cook.dart:19-33`, and `lib/gallery/gallery.dart:20-37` require no API or UI changes and render the returned lists as they do today.
- Category creation and assignment continue to access all category names; no 20-item cap is applied to `getCategories()`.

## Verification Steps

1. Run `flutter analyze` to confirm the altered query chains compile and introduce no lint diagnostics.
2. Run `flutter test` to confirm the existing record analysis and lunar-age tests still pass.
3. With each backing table containing at least 21 rows, launch the app and visit Growth Records, Cooking, and Gallery:
   - confirm each displayed feed contains exactly 20 entries;
   - confirm the first entry is the newest by its relevant field;
   - add or edit an entry and confirm the existing refresh shows it when it belongs in the newest 20.
4. Open gallery category add/edit flows and confirm existing categories beyond the most recent 20 remain available and duplicate-name validation still checks them.

## Risks & Mitigations

- **Gallery does not currently expose a timestamp.** Order by its numeric insertion ID descending, which is the available stable proxy for most recently created photos; if the database’s ID is not monotonic, add/use an actual creation timestamp in a separate schema-backed change.
- **Older records are no longer visible in the current unpaginated screens.** This is the requested behavior; no “load more” control is introduced, so the change remains narrowly scoped.
