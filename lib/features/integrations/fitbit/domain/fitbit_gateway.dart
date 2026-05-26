import 'package:blutdruck_tracker/features/integrations/fitbit/domain/fitness_summary.dart';

/// Future Fitbit / Google Health (Fitbit Web API) gateway. Read-only
/// fitness context; never a blood-pressure source. Disabled in the MVP
/// — every method on the concrete `DisabledFitbitGateway` throws
/// `UnsupportedError`. See docs/specs/10-future-integrations.md
/// §Fitbit gateway for the rules an enabled implementation must follow
/// (OAuth 2.0 PKCE, no client secret in the mobile binary, tokens in
/// flutter_secure_storage only, opt-in consent, no causal claims).
abstract class FitbitGateway {
  Future<bool> isAvailable();

  /// Starts the OAuth 2.0 PKCE flow. Resolves when the user has either
  /// consented or aborted. Throws on misconfiguration.
  Future<void> connect();

  /// Revokes the access token with Fitbit and clears any cached data.
  Future<void> disconnect();

  /// Returns a per-day aggregate for the window. Network and parsing
  /// errors must surface as typed failures; never partial data without
  /// indication.
  Future<FitnessSummary> readFitnessSummary({
    required DateTime fromUtc,
    required DateTime toUtc,
  });
}
