import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory stub for the disclaimer-accepted version.
///
/// Step 0 only: real persistence lands in step 3 when the `app_settings`
/// table exists. This stub keeps the dialog flow testable end-to-end now.
///
/// `null` = never accepted; the first-launch dialog appears.
/// An integer value = the `kDisclaimerVersion` the user accepted.
final disclaimerAcceptedVersionProvider =
    NotifierProvider<DisclaimerAcceptanceNotifier, int?>(
      DisclaimerAcceptanceNotifier.new,
    );

class DisclaimerAcceptanceNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  /// Records that the user accepted the disclaimer of [version]. An
  /// action verb at the call sites reads clearer than `notifier.state = v`,
  /// and a paired getter would just shadow `Notifier.state`.
  // ignore: use_setters_to_change_properties
  void markAccepted(int version) => state = version;
}
