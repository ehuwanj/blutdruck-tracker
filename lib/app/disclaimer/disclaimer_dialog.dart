import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modal, non-dismissable disclaimer the user must accept once per
/// `kDisclaimerVersion` bump. See docs/specs/05-screens.md and
/// docs/specs/12-privacy-and-medical.md.
class DisclaimerDialog extends ConsumerWidget {
  const DisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(l10n.disclaimerTitle),
        content: SingleChildScrollView(child: Text(l10n.disclaimerBody)),
        actions: [
          FilledButton(
            onPressed: () {
              // Capture navigator + notifier BEFORE touching state. The
              // notifier's save() sets `state = AsyncValue.data(...)`
              // synchronously, which schedules a rebuild of every
              // settingsProvider watcher including DisclaimerGate. By the
              // time we reach the pop call, `context` may have rebuilt
              // under us. Capturing rootNavigator up front sidesteps that
              // entirely and pops the modal route directly.
              final navigator = Navigator.of(context, rootNavigator: true);
              final notifier = ref.read(settingsProvider.notifier);
              final settings = ref.read(settingsProvider).valueOrNull;
              navigator.pop();
              if (settings != null) {
                notifier.save(
                  settings.copyWith(
                    disclaimerAcceptedVersion: kDisclaimerVersion,
                  ),
                );
              }
            },
            child: Text(l10n.disclaimerAccept),
          ),
        ],
      ),
    );
  }
}

/// Watches the acceptance state and shows the dialog once on first frame
/// when re-acceptance is needed.
class DisclaimerGate extends ConsumerStatefulWidget {
  const DisclaimerGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<DisclaimerGate> createState() => _DisclaimerGateState();
}

class _DisclaimerGateState extends ConsumerState<DisclaimerGate> {
  bool _scheduled = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    if (!settings.hasValue) {
      return widget.child;
    }
    final accepted = settings.valueOrNull?.disclaimerAcceptedVersion;
    final needsAcceptance = accepted == null || accepted < kDisclaimerVersion;

    if (needsAcceptance && !_scheduled) {
      _scheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const DisclaimerDialog(),
        );
      });
    }

    return widget.child;
  }
}
