import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> read();
  Future<void> write(AppSettings settings);
}
