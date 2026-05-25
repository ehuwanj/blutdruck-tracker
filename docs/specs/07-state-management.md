# 07 — State Management

## Library

**Riverpod** (`flutter_riverpod`). The whole app is wrapped in a single
`ProviderScope` in `main.dart`. Providers are declared at module scope
(top level of their file), never inside widgets.

## Provider categories

| Category | Provider type | Notes |
|---|---|---|
| Singletons (DB, datasources, repositories) | `Provider` | Override in tests with mocks |
| One-shot async (fetch latest reading once) | `FutureProvider` | Rare; prefer streams |
| Live data (history list, latest reading) | `StreamProvider` | Backed by Drift `Stream` |
| Derived data (statistics for selected period) | `Provider` / `FutureProvider.family` | Pure computation off the readings stream |
| Screen-local mutable state | `NotifierProvider` / `AsyncNotifierProvider` | Form state, period selection |
| Settings | `AsyncNotifierProvider<AppSettings>` | Persisted via repository |

Avoid `StateProvider` and `StateNotifierProvider` — use `Notifier`/
`AsyncNotifier` (Riverpod 2.x API) for clarity.

## Layered example

```dart
// Infrastructure
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final readingLocalDataSourceProvider = Provider<ReadingLocalDataSource>((ref) {
  return DriftReadingLocalDataSource(ref.watch(databaseProvider));
});

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepositoryImpl(ref.watch(readingLocalDataSourceProvider));
});

// Use cases
final getReadingsProvider = Provider(
  (ref) => GetReadings(ref.watch(readingRepositoryProvider)),
);

final addReadingProvider = Provider(
  (ref) => AddReading(ref.watch(readingRepositoryProvider)),
);

// Data streams
final readingsStreamProvider = StreamProvider.autoDispose<List<BloodPressureReading>>(
  (ref) => ref.watch(readingRepositoryProvider).watchAll(),
);

final latestReadingProvider = Provider<AsyncValue<BloodPressureReading?>>((ref) {
  return ref
      .watch(readingsStreamProvider)
      .whenData((list) => list.isEmpty ? null : list.first);
});

// Period selection (UI state)
class PeriodNotifier extends Notifier<DateTimeRange> {
  @override
  DateTimeRange build() => DateRangePresets.last30Days();
  void setPreset(DateRangePreset p) => state = p.range();
  void setCustom(DateTimeRange r) => state = r;
}
final periodProvider = NotifierProvider<PeriodNotifier, DateTimeRange>(
  PeriodNotifier.new,
);

// Derived data
final statisticsProvider = Provider<AsyncValue<StatisticsResult>>((ref) {
  final period = ref.watch(periodProvider);
  final readings = ref.watch(readingsStreamProvider);
  final settings = ref.watch(settingsProvider).valueOrNull;
  return readings.whenData(
    (all) => const StatisticsCalculator().calculate(
      readings: all,
      period: period,
      settings: settings,
    ),
  );
});

// Time-slot detector input is INDEPENDENT of `periodProvider`:
// the detector always looks at the last 30 days regardless of the
// chart-period chip selection. See [04-business-logic.md].
final timeSlotDetectorInputProvider =
    Provider<AsyncValue<List<BloodPressureReading>>>((ref) {
  final readings = ref.watch(readingsStreamProvider);
  final now = ref.watch(clockProvider).now();
  final cutoff = now.subtract(const Duration(days: 30));
  return readings.whenData(
    (all) => all.where((r) => r.measuredAt.isAfter(cutoff)).toList(),
  );
});

final timeSlotPickProvider = Provider<AsyncValue<TimeSlotPick?>>((ref) {
  final input = ref.watch(timeSlotDetectorInputProvider);
  final settings = ref.watch(settingsProvider).valueOrNull;
  return input.whenData((readings) {
    if (settings == null) return null;
    return const TimeSlotDetector().detect(
      readings: readings,
      widthMinutes: settings.timeSlotWidthMinutes,
      pinnedStartMinutes: settings.pinnedTimeSlotStartMinutes,
    );
  });
});

final timeSlotSeriesProvider = Provider<AsyncValue<TimeSlotSeries?>>((ref) {
  final pick = ref.watch(timeSlotPickProvider);
  final input = ref.watch(timeSlotDetectorInputProvider);
  return pick.whenData((p) {
    if (p == null) return null;
    final readings = input.valueOrNull ?? const [];
    return const TimeSlotAggregator().aggregate(readings: readings, pick: p);
  });
});
```

**Shared `periodProvider` consumers (binding):**

- `statisticsProvider` (Statistics screen + Status screen + Statistics card on overview)
- The **blood-pressure chart card** on the overview Verlauf tab

**Time-slot card consumers** use the independent
`timeSlotDetectorInputProvider` chain above and **do not** read
`periodProvider`. Changing the chart-period chip on the overview must
not change which slot is selected.

## Rules

1. **Widgets stay declarative.** Use `Consumer`, `ConsumerWidget`, or
   `ref.watch` inside `build`. No `setState` for app state.
2. **No business logic in providers.** Providers wire dependencies and
   expose state. The math lives in services. The data access lives in
   repositories.
3. **Prefer streams** for anything that should react to DB changes
   (overview, history, statistics).
4. **`AsyncValue.when(loading, error, data)`** is the only way to render
   async state. No null-spam, no try/catch in widgets.
5. **`autoDispose`** is the default for screen-scoped data. Long-lived
   singletons (DB, repositories) don't use it.
6. **`family`** is used when state varies by a parameter (e.g.,
   `readingByIdProvider.family(String id)`).
7. **Cross-feature reads** go through domain repositories, never by
   importing another feature's providers.

## Form state

The reading entry form takes an optional reading id (null = new reading,
non-null = edit) and is therefore a **family** AsyncNotifier in Riverpod 2.x.
`AsyncNotifier.build()` does not accept arguments; per-instance state needs
`FamilyAsyncNotifier`.

```dart
class ReadingFormNotifier
    extends FamilyAsyncNotifier<ReadingFormState, String?> {
  @override
  Future<ReadingFormState> build(String? readingId) async {
    if (readingId == null) {
      return ReadingFormState.empty(now: ref.read(clockProvider).now());
    }
    final existing = await ref.read(getReadingByIdProvider).call(readingId);
    return ReadingFormState.fromReading(existing);
  }

  void setSystolic(int v) { /* ... */ }
  // ...
  Future<void> submit() async { /* ... */ }
}

final readingFormNotifierProvider = AsyncNotifierProvider
    .family<ReadingFormNotifier, ReadingFormState, String?>(
  ReadingFormNotifier.new,
);
```

Widgets read it as `ref.watch(readingFormNotifierProvider(readingId))`,
where `readingId` is `null` for `/readings/new` and the route param for
`/readings/:id/edit`.

The notifier holds the draft, the current `ValidationResult`, and the
submit lifecycle. The widget reads it via `ref.watch` and renders fields +
inline messages.

## Settings

Settings load asynchronously (DB read) and then become a hot value.
Mutations call the repository and update local state optimistically.

```dart
final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
```

Other parts of the app that need locale or theme observe this provider
through small selector providers to avoid rebuilding on unrelated changes:

```dart
final localeProvider = Provider<Locale?>((ref) {
  return ref.watch(settingsProvider).valueOrNull?.locale.toLocale();
});
```

## Testing

- Override providers with `ProviderContainer(overrides: [...])` in tests.
- Use `mocktail` for repository/datasource fakes.
- For widget tests, wrap with `ProviderScope(overrides: [...], child: ...)`.

## Performance

- Avoid `ref.watch` of large lists inside child widgets that only need a
  single field — use a selector provider.
- Use `const` widget constructors wherever possible.
- For long lists (history), use `ListView.builder` with `itemExtent` or
  `prototypeItem` when row height is fixed.
