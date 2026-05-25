import 'package:blutdruck_tracker/app/disclaimer/disclaimer_dialog.dart';
import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Root widget. Step 0 ships an empty home scaffold; feature screens land
/// in step 5 (app shell + routing).
class BlutdruckTrackerApp extends StatelessWidget {
  const BlutdruckTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DisclaimerGate(child: _PlaceholderHome()),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Step 0 foundation in place. Feature screens land in step 5.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
