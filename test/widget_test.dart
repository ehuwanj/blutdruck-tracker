import 'package:blutdruck_tracker/app/app.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/router.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots to overview and FAB navigates to new reading', (
    tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingRepositoryProvider.overrideWithValue(_FakeReadingRepository()),
          settingsRepositoryProvider.overrideWithValue(
            _FakeSettingsRepository(
              AppSettings.defaults().copyWith(
                disclaimerAcceptedVersion: kDisclaimerVersion,
              ),
            ),
          ),
        ],
        child: const BlutdruckTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsWidgets);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add reading'), findsWidgets);
  });

  testWidgets('disclaimer blocks interaction until accepted', (tester) async {
    appRouter.go('/');
    final repository = _FakeSettingsRepository(AppSettings.defaults());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingRepositoryProvider.overrideWithValue(_FakeReadingRepository()),
          settingsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const BlutdruckTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    // Scope the finder to the dialog: an empty-state CTA also renders a
    // FilledButton in the LatestReadingCard behind the dialog, so a global
    // FilledButton finder is ambiguous.
    final acceptFinder = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(FilledButton),
    );
    await tester.tap(acceptFinder);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.value.disclaimerAcceptedVersion, kDisclaimerVersion);
  });

  testWidgets('settings language picker switches locale', (tester) async {
    final repository = _FakeSettingsRepository(
      AppSettings.defaults().copyWith(
        disclaimerAcceptedVersion: kDisclaimerVersion,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readingRepositoryProvider.overrideWithValue(_FakeReadingRepository()),
          settingsRepositoryProvider.overrideWithValue(repository),
        ],
        child: const BlutdruckTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/settings');
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);

    // The language picker is a DropdownButton; open it, then pick Deutsch
    // from the now-visible menu.
    await tester.tap(find.byType(DropdownButton<LocaleSetting>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch').last);
    await tester.pumpAndSettle();

    expect(repository.value.locale.name, 'de');
    expect(find.text('Einstellungen'), findsWidgets);
  });
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

class _FakeReadingRepository implements ReadingRepository {
  @override
  Future<void> upsert(BloodPressureReading reading) async {}

  @override
  Future<void> deleteById(String id) async {}

  @override
  Future<BloodPressureReading?> findById(String id) async => null;

  @override
  Stream<List<BloodPressureReading>> watchAll() => Stream.value(const []);

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(const []);
  }

  @override
  Future<BloodPressureReading?> findLatest() async => null;
}
