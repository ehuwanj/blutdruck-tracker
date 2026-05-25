import 'package:blutdruck_tracker/features/settings/data/datasources/app_settings_local_datasource.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this.dataSource);

  final AppSettingsLocalDataSource dataSource;

  @override
  Future<AppSettings> read() => dataSource.read();

  @override
  Future<void> write(AppSettings settings) => dataSource.write(settings);
}
