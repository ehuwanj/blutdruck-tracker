import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Profile weight (kg). Mirrors `HeightSettingTile` exactly because the
/// UX is the same — both are single-value profile settings that feed BMI.
/// Weight is no longer captured per reading; the user enters it once and
/// updates when it changes.
class WeightSettingTile extends ConsumerStatefulWidget {
  const WeightSettingTile({required this.settings, super.key});

  final AppSettings settings;

  @override
  ConsumerState<WeightSettingTile> createState() => _WeightSettingTileState();
}

class _WeightSettingTileState extends ConsumerState<WeightSettingTile> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.settings.weightKg == null
          ? ''
          : widget.settings.weightKg!.toStringAsFixed(1),
    );
  }

  @override
  void didUpdateWidget(covariant WeightSettingTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.settings.weightKg == null
        ? ''
        : widget.settings.weightKg!.toStringAsFixed(1);
    if (newText != _controller.text) {
      _controller.text = newText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final text = _controller.text.trim();
    if (text.isEmpty) {
      // Empty input clears the stored value. AppSettings is freezed and
      // copyWith can't pass null on a nullable field, so rebuild explicitly.
      final cleared = AppSettings(
        locale: widget.settings.locale,
        themeMode: widget.settings.themeMode,
        weightUnit: widget.settings.weightUnit,
        remindersEnabled: widget.settings.remindersEnabled,
        timeSlotWidthMinutes: widget.settings.timeSlotWidthMinutes,
        recentEntriesCount: widget.settings.recentEntriesCount,
        heightCm: widget.settings.heightCm,
        pinnedTimeSlotStartMinutes: widget.settings.pinnedTimeSlotStartMinutes,
        disclaimerAcceptedVersion: widget.settings.disclaimerAcceptedVersion,
        lastExportDirectoryHint: widget.settings.lastExportDirectoryHint,
      );
      await ref.read(settingsProvider.notifier).save(cleared);
      setState(() => _errorText = null);
      return;
    }
    final parsed = double.tryParse(text);
    if (parsed == null) {
      setState(() => _errorText = l10n.settingsWeightInvalid);
      return;
    }
    if (parsed < 20 || parsed > 400) {
      setState(() => _errorText = l10n.settingsWeightOutOfRange);
      return;
    }
    setState(() => _errorText = null);
    await ref
        .read(settingsProvider.notifier)
        .save(widget.settings.copyWith(weightKg: parsed));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.settingsWeightLabel,
              suffixText: l10n.settingsWeightSuffix,
              helperText: l10n.settingsWeightHint,
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _save(),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: _save,
              child: Text(l10n.settingsHeightSaveAction),
            ),
          ),
        ],
      ),
    );
  }
}
