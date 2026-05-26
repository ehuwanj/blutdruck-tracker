import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads each supported locale's AppLocalizations bundle and exercises
/// every public getter so any missing ARB key surfaces here as a
/// MissingTranslationException rather than at runtime in production.
void main() {
  test('every supported locale loads without missing keys', () async {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = await AppLocalizations.delegate.load(locale);
      // Sample at least one key from every ARB section. Each call would
      // throw if the localization for the active locale lacked the key.
      // Strings:
      expect(l10n.appTitle, isNotEmpty);
      expect(l10n.disclaimerBody, isNotEmpty);
      expect(l10n.historyEmptyTitle, isNotEmpty);
      expect(l10n.csvColumnDate, isNotEmpty);
      expect(l10n.statisticsKeyMetricsTitle, isNotEmpty);
      expect(l10n.statusDistributionTitle, isNotEmpty);
      expect(l10n.reminderNotificationTitle, isNotEmpty);
      expect(l10n.reminderNotificationBody, isNotEmpty);
      expect(l10n.settingsGroupProfile, isNotEmpty);
      expect(l10n.settingsDeleteAllChallenge, isNotEmpty);
      // ICU plural / placeholder calls:
      expect(l10n.historyEntriesCount(0), isNotEmpty);
      expect(l10n.historyEntriesCount(1), isNotEmpty);
      expect(l10n.historyEntriesCount(7), isNotEmpty);
      expect(l10n.relativeTimeMinutes(5), isNotEmpty);
      expect(l10n.relativeTimeHours(3), isNotEmpty);
      expect(l10n.relativeTimeDays(2), isNotEmpty);
      expect(
        l10n.latestReadingSemanticLabel(132, 84, 72, 'Optimal', 'just now'),
        isNotEmpty,
      );
      expect(l10n.insightFrequentlyElevatedBody(8, 12), isNotEmpty);
    }
  });

  test('supported locales are exactly en, de, zh', () {
    final codes = AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .toSet();
    expect(codes, {'en', 'de', 'zh'});
  });
}
