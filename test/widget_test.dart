import 'package:blutdruck_tracker/app/app.dart';
import 'package:blutdruck_tracker/app/disclaimer/disclaimer_acceptance_provider.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots and shows the placeholder home', (
    WidgetTester tester,
  ) async {
    // Pre-accept the disclaimer so the modal does not obscure the home.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          disclaimerAcceptedVersionProvider.overrideWith(_AcceptedNotifier.new),
        ],
        child: const BlutdruckTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('First-launch disclaimer dialog is shown until accepted', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BlutdruckTrackerApp()));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    // Accept button is rendered; tapping dismisses the dialog.
    final acceptFinder = find.byType(FilledButton);
    expect(acceptFinder, findsOneWidget);
    await tester.tap(acceptFinder);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}

class _AcceptedNotifier extends DisclaimerAcceptanceNotifier {
  @override
  int? build() => kDisclaimerVersion;
}
