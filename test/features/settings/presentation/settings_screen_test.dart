import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:blutdruck_tracker/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:blutdruck_tracker/features/settings/domain/services/data_wiper.dart';
import 'package:blutdruck_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Tall viewport — settings has many tiles in a ListView.
  void useTallViewport(WidgetTester tester) {
    final originalSize = tester.view.physicalSize;
    final originalRatio = tester.view.devicePixelRatio;
    tester.view.physicalSize = const Size(1080, 4800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.physicalSize = originalSize;
      tester.view.devicePixelRatio = originalRatio;
    });
  }

  testWidgets('height input rejects values outside 80..250', (tester) async {
    useTallViewport(tester);
    final repo = _FakeSettingsRepository(AppSettings.defaults());
    await tester.pumpScreen(settingsRepository: repo);

    final field = find.byType(TextField).first;
    await tester.enterText(field, '300');
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    expect(find.text('Enter a value between 80 and 250.'), findsOneWidget);
    expect(repo.value.heightCm, isNull);
  });

  testWidgets('height input accepts a value in range and persists', (
    tester,
  ) async {
    useTallViewport(tester);
    final repo = _FakeSettingsRepository(AppSettings.defaults());
    await tester.pumpScreen(settingsRepository: repo);

    final field = find.byType(TextField).first;
    await tester.enterText(field, '178');
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    expect(repo.value.heightCm, 178);
  });

  testWidgets('slot-width dropdown writes the new width', (tester) async {
    useTallViewport(tester);
    final repo = _FakeSettingsRepository(AppSettings.defaults());
    await tester.pumpScreen(settingsRepository: repo);

    // Find the slot-width dropdown by its current label.
    await tester.tap(find.text('1 h').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 h').last);
    await tester.pumpAndSettle();

    expect(repo.value.timeSlotWidthMinutes, 120);
  });

  testWidgets('pinned-start tile is disabled when auto-detect toggle is on', (
    tester,
  ) async {
    useTallViewport(tester);
    final repo = _FakeSettingsRepository(AppSettings.defaults());
    await tester.pumpScreen(settingsRepository: repo);

    // The pinned-start ListTile carries the "Not set" subtitle when null.
    final tile = tester.widget<ListTile>(
      find.ancestor(of: find.text('Not set'), matching: find.byType(ListTile)),
    );
    expect(tile.enabled, isFalse);
  });

  testWidgets('delete-all flow requires both confirmations before wiping', (
    tester,
  ) async {
    useTallViewport(tester);
    final wiper = _SpyDataWiper();
    final scheduler = _NoopScheduler();
    final repo = _FakeSettingsRepository(AppSettings.defaults());
    await tester.pumpScreen(
      settingsRepository: repo,
      dataWiper: wiper,
      scheduler: scheduler,
    );

    await tester.ensureVisible(find.text('Delete all data'));
    await tester.tap(find.text('Delete all data'));
    await tester.pumpAndSettle();

    // First confirmation dialog: cancel first to prove nothing is wiped yet.
    expect(find.text('Delete all data?'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(wiper.wipeCount, 0);

    // Reopen and continue through the first dialog.
    await tester.ensureVisible(find.text('Delete all data'));
    await tester.tap(find.text('Delete all data'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    // Second dialog: typing the challenge unlocks Delete.
    expect(find.text('Last chance'), findsOneWidget);
    final deleteButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Delete'),
    );
    expect(deleteButton.onPressed, isNull);
    expect(wiper.wipeCount, 0);

    // The height input is also a TextField on the underlying screen, so
    // scope to the dialog before typing the challenge.
    final challengeField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(challengeField, 'DELETE');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(wiper.wipeCount, 1);
    expect(scheduler.cancelCount, greaterThanOrEqualTo(1));
  });
}

extension on WidgetTester {
  Future<void> pumpScreen({
    required _FakeSettingsRepository settingsRepository,
    _SpyDataWiper? dataWiper,
    _NoopScheduler? scheduler,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(settingsRepository),
          readingRepositoryProvider.overrideWithValue(_NoopReadingRepository()),
          reminderRepositoryProvider.overrideWithValue(
            _NoopReminderRepository(),
          ),
          if (dataWiper != null) dataWiperProvider.overrideWithValue(dataWiper),
          if (scheduler != null)
            reminderSchedulerProvider.overrideWithValue(scheduler),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    );
    await pumpAndSettle();
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this.value);
  AppSettings value;

  @override
  Future<AppSettings> read() async => value;

  @override
  Future<void> write(AppSettings settings) async {
    value = settings;
  }
}

class _SpyDataWiper implements DataWiper {
  int wipeCount = 0;

  @override
  Future<void> wipeAll() async {
    wipeCount++;
  }
}

class _NoopScheduler implements ReminderScheduler {
  int cancelCount = 0;
  int scheduleCount = 0;

  @override
  Future<void> cancelAll() async {
    cancelCount++;
  }

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleAll(
    List<Reminder> reminders, {
    required String title,
    required String body,
  }) async {
    scheduleCount++;
  }
}

class _NoopReadingRepository implements ReadingRepository {
  @override
  Future<void> upsert(BloodPressureReading reading) async {}

  @override
  Future<void> deleteById(String id) async {}

  @override
  Future<BloodPressureReading?> findById(String id) async => null;

  @override
  Future<BloodPressureReading?> findLatest() async => null;

  @override
  Stream<List<BloodPressureReading>> watchAll() => Stream.value(const []);

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(const []);
  }
}

class _NoopReminderRepository implements ReminderRepository {
  @override
  Stream<List<Reminder>> watchAll() => Stream.value(const []);

  @override
  Future<List<Reminder>> readAll() async => const [];

  @override
  Future<void> upsert(Reminder reminder) async {}

  @override
  Future<void> deleteById(String id) async {}
}
