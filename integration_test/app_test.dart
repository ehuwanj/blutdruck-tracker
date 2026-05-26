import 'dart:io';

import 'package:blutdruck_tracker/app/app.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/router.dart';
import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// End-to-end flow per docs/specs/11-testing.md §Integration tests:
/// cold start → empty state → add reading via the form → see it in the
/// overview → export CSV (write only, share sheet is not asserted).
///
/// Execution model (spec 11 §CI gates):
/// - On CI / a real Android emulator, run with
///   `flutter test integration_test/`. The IntegrationTestWidgetsFlutterBinding
///   drives the host device.
/// - Locally without a connected device, `flutter test integration_test/`
///   exits with "No supported devices connected" — spec 11 allows CI to
///   skip this gate when no emulator is attached. To exercise the same
///   scenarios on the host VM, run this file as a regular widget test:
///   `flutter test integration_test/app_test.dart`. The share_plus method
///   channel is stubbed and path_provider is faked, so no platform surface
///   is required for the file write to be observable.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase database;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('blutdruck-int-');
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);
    // Swallow the share_plus method-channel call: in this test there is
    // no device share sheet, but we still want the export flow to write
    // the CSV file to disk before share_plus is reached.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          (call) async => null,
        );
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          null,
        );
    await database.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('cold start to CSV export end-to-end', (tester) async {
    // Comfortable surface so the ListView slivers below the fold (history
    // section on the overview) are eagerly built.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          reminderSchedulerProvider.overrideWithValue(_NoopScheduler()),
        ],
        child: const BlutdruckTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1) Disclaimer dialog blocks interaction on first launch — accept it.
    expect(find.byType(AlertDialog), findsOneWidget);
    final acceptFinder = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(FilledButton),
    );
    await tester.tap(acceptFinder);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    // 2) Empty state visible on overview.
    expect(find.text('No readings yet'), findsOneWidget);

    // 3) Tap FAB → reading entry form.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Add reading'), findsWidgets);

    // 4) Fill systolic + diastolic.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Systolic'),
      '132',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Diastolic'),
      '84',
    );
    await tester.pumpAndSettle();

    // 5) Save.
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    // 6) Overview now shows the recorded reading.
    expect(find.text('132 / 84'), findsOneWidget);

    // 7) Navigate to /export.
    appRouter.go('/export');
    await tester.pumpAndSettle();

    // 8) Trigger generate. share_plus is stubbed; the file write happens
    //    before share, so disk state is observable regardless of whether
    //    share succeeded or threw.
    await tester.tap(find.widgetWithText(FilledButton, 'Generate and share'));
    await tester.pumpAndSettle();

    // 9) A CSV file landed under <documents>/exports/.
    final exportsDir = Directory(p.join(tempDir.path, 'exports'));
    expect(exportsDir.existsSync(), isTrue);
    final files = exportsDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.csv'))
        .toList();
    expect(files, isNotEmpty);

    // 10) Header row + at least one data row (132 / 84).
    final csv = files.first.readAsStringSync();
    expect(csv, contains('Systolic'));
    expect(csv, contains('132'));
    expect(csv, contains('84'));
  });
}

class _FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProviderPlatform(this.basePath);

  final String basePath;

  @override
  Future<String?> getApplicationDocumentsPath() async => basePath;

  @override
  Future<String?> getTemporaryPath() async => basePath;

  @override
  Future<String?> getApplicationSupportPath() async => basePath;

  @override
  Future<String?> getDownloadsPath() async => basePath;
}

class _NoopScheduler implements ReminderScheduler {
  @override
  Future<void> cancelAll() async {}

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleAll(
    List<Reminder> reminders, {
    required String title,
    required String body,
  }) async {}
}
