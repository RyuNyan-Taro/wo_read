# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze / lint
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/record/use_cases/lunar_age_test.dart

# Regenerate Riverpod code (required after editing @riverpod annotated files)
dart run build_runner build

# Install dependencies
flutter pub get
```

## Architecture Overview

This is a **Flutter app for child development tracking**, with six feature modules. The app is Japanese-language only (strings are hardcoded in enum maps — there is no i18n framework).

**Backend:** Supabase (PostgreSQL + Storage) is the sole persistent backend. The Google Gemini API (`google_generative_ai`) is used for AI-generated meal comments.

**Environment:** A `.env` file at the project root is required at startup (loaded via `flutter_dotenv`). Required keys: `SUPABASE_PROJECT_URL`, `SUPABASE_ANON_KEY`, `GOOGLE_AI_API_KEY`, `CHILD_BIRTHDAY`.

## Module Structure

Each feature lives under `lib/<module>/` and follows a consistent layering:

| Layer | Location | Purpose |
|---|---|---|
| Page (UI entry) | `<module>/<module>.dart` | Top-level StatefulWidget, owns list state |
| Screens | `<module>/screens/` | Sub-pages and card widgets |
| Controllers | `<module>/controllers/` | Business logic, form state, orchestrates services |
| Services | `<module>/service/` | Supabase queries and external API calls |
| Use cases | `<module>/use_cases/` | Pure business logic (no I/O) |
| Models | `<module>/models/` | Data classes and enums |

The six modules and what they do:

- **record** — Growth milestone tracking grouped by lunar age; uses `LunarAge` calc logic and an AI label service (`label_service.dart`) to classify emotions and Denver developmental categories.
- **cook** — Meal logging with image upload (Supabase Storage) and AI-generated comments via Gemini; image manipulation (rotation) is done in `cook_form_controller.dart` using the `image` package.
- **gallery** — Photo gallery with categories; images are stored in Supabase Storage, URLs persisted in the DB.
- **hiragana** — Static Japanese hiragana learning with text-to-speech (`flutter_tts`). No backend.
- **hair** — Stateless character customization view backed by hardcoded data in `character_data.dart`.
- **shape_move** — Interactive gesture/shape game; the only module using **Riverpod** (`@riverpod` annotation on `shapes_provider.dart`). Its `*.g.dart` file is generated — do not edit it manually.

## State Management

Three patterns coexist in this codebase:

1. **StatefulWidget + setState** — default for page-level list state (record, cook, gallery, hiragana).
2. **Custom Controller classes** (e.g. `AddRecordController`, `CookFormController`) — encapsulate form and async state; passed into sub-pages via constructor.
3. **Riverpod StateNotifier** — used only in `shape_move/`; `shapes_provider.dart` uses `@riverpod` annotations and requires `build_runner` for code generation.

## Navigation

Standard `Navigator.push()` with no named routes or `go_router`. Child pages receive a callback parameter to trigger parent list refresh on return.

## Code Generation

`shape_move/providers/shapes_provider.dart` is annotated with `@riverpod`. After any change to it, run:

```bash
dart run build_runner build
```

The generated file `shapes_provider.g.dart` is committed to the repo.

## Testing

Tests live in `test/` and mirror the `lib/` structure. The only existing tests are parameterized unit tests for `LunarAge` logic in `test/record/use_cases/lunar_age_test.dart`, using the `parameterized_test` package.
