# 01 — Architecture

## Style

Feature-based **Clean Architecture** with three layers per feature:

```
presentation  ──▶  domain  ◀──  data
```

- **Presentation** depends on **domain** only.
- **Data** depends on **domain** only.
- **Domain** depends on nothing app-specific (pure Dart + freezed).

The UI never touches Drift, JSON, files, or platform plugins directly. It goes
through repositories defined in `domain/` and implemented in `data/`.

## Folder structure

```
lib/
  main.dart

  app/
    app.dart                 # Root MaterialApp / ProviderScope
    router.dart              # go_router config
    theme/
      app_theme.dart
      app_colors.dart
      app_typography.dart
    localization/            # generated ARB output is referenced here

  core/
    database/
      app_database.dart      # Drift DB; only data layers import this
      tables/
      migrations/
    errors/
      app_exception.dart
      failure.dart
    utils/
      date_time_utils.dart
      number_format_utils.dart
    widgets/                 # generic, feature-agnostic widgets
      app_card.dart
      app_empty_state.dart
      app_error_view.dart
      app_loading_view.dart
    constants/
      app_constants.dart

  features/
    readings/                # entry, edit, delete, fetch
      domain/
        entities/
        repositories/
        usecases/
        services/
      data/
        datasources/
        repositories/
        mappers/
      presentation/
        screens/
        widgets/
        providers/

    overview/                # presentation-only feature
      presentation/

    statistics/
      domain/
      presentation/

    insights/                # rule-based for MVP; LLM-ready
      domain/
      data/
      presentation/

    export/
      domain/
      presentation/

    reminders/
      domain/
      data/
      presentation/

    settings/
      presentation/

    integrations/
      health/                # disabled gateway + README for future work
        domain/
        data/
      fitbit/                # disabled gateway + README for future work
        domain/              # FitbitGateway, FitnessSummary, DailyFitness
        data/                # DisabledFitbitGateway + README
      llm/                   # disabled gateway + README for future work
        domain/
        data/
```

## Dependencies

Pinned to current stable. Concrete versions resolved at `flutter pub get` time.

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State & routing
  flutter_riverpod:
  go_router:

  # Persistence
  drift:
  drift_flutter:
  sqlite3_flutter_libs:
  path_provider:
  path:

  # Formatting & i18n
  intl:

  # Charts
  fl_chart:

  # Export
  csv:
  pdf:
  printing:
  share_plus:                # platform share sheet for CSV/PDF

  # Reminders
  flutter_local_notifications:
  timezone:                  # required by flutter_local_notifications

  # Secure storage (future secrets only; no health data here)
  flutter_secure_storage:

  # Modeling
  uuid:
  freezed_annotation:
  json_annotation:
  collection:                # convenience for grouping / sorting

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter

  build_runner:
  drift_dev:
  freezed:
  json_serializable:
  mocktail:
  very_good_analysis:
```

**Do not add** any dependency that isn't listed here without a written reason
in the PR description. Specifically: no analytics, no ads, no Firebase, no
crash reporters in the MVP.

## Layering rules

1. **Widgets stay declarative.** Side effects belong in providers or services.
2. **Business logic lives in `domain/services` and use cases**, not in widgets
   and not in repositories.
3. **Repositories** expose domain entities; they never leak Drift row classes,
   JSON maps, or platform types.
4. **Datasources** are the only place that talks to Drift / files / plugins.
5. **Mappers** convert between data rows and domain entities. They are pure
   functions and unit-tested.
6. **`core/`** holds reusable building blocks. It must not import from
   `features/`.
7. **A feature must not import from another feature's `data/` or `presentation/`.**
   Cross-feature use happens through `domain/` only.

## File size & cohesion

- One public class per file; supporting private types in the same file are fine.
- Aim for files under ~250 lines. Split when responsibilities diverge.
- Group helpers with the thing they help, not in a generic `utils.dart`.

## Lint & format

- `analysis_options.yaml` includes `package:very_good_analysis/analysis_options.yaml`.
- `flutter format .` before every commit.
- `flutter analyze` must be clean. No `// ignore: ...` without a justification
  comment in the same line.

## Build & code generation

The project uses code generation for Drift, Freezed, and JSON.

```
dart run build_runner build --delete-conflicting-outputs
# or, while developing:
dart run build_runner watch --delete-conflicting-outputs
```

(`flutter pub run build_runner …` still works but is the older form;
the Dart 3.x toolchain prefers `dart run …`.)

Generated files (`*.g.dart`, `*.freezed.dart`, `*.drift.dart`) are committed
so CI doesn't need to run the generator.
