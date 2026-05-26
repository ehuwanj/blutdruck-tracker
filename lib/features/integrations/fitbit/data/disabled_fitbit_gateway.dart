import 'package:blutdruck_tracker/features/integrations/fitbit/domain/fitbit_gateway.dart';
import 'package:blutdruck_tracker/features/integrations/fitbit/domain/fitness_summary.dart';

/// MVP-default [FitbitGateway]: `isAvailable` returns `false`; every
/// other method throws `UnsupportedError`. No URLs or client IDs are
/// present in this build; the OAuth flow is added only when the
/// gateway is enabled. See docs/specs/10-future-integrations.md.
class DisabledFitbitGateway implements FitbitGateway {
  const DisabledFitbitGateway();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> connect() async {
    throw UnsupportedError('Fitbit integration is disabled in this build.');
  }

  @override
  Future<void> disconnect() async {
    throw UnsupportedError('Fitbit integration is disabled in this build.');
  }

  @override
  Future<FitnessSummary> readFitnessSummary({
    required DateTime fromUtc,
    required DateTime toUtc,
  }) async {
    throw UnsupportedError('Fitbit integration is disabled in this build.');
  }
}
