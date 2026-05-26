import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeightSettingTile extends ConsumerStatefulWidget {
  const HeightSettingTile({required this.settings, super.key});

  final AppSettings settings;

  @override
  ConsumerState<HeightSettingTile> createState() => _HeightSettingTileState();
}

class _HeightSettingTileState extends ConsumerState<HeightSettingTile> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.settings.heightCm == null
          ? ''
          : widget.settings.heightCm!.toStringAsFixed(0),
    );
  }

  @override
  void didUpdateWidget(covariant HeightSettingTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.settings.heightCm == null
        ? ''
        : widget.settings.heightCm!.toStringAsFixed(0);
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
      // Empty input clears the value. Construct a fresh AppSettings so
      // heightCm is explicitly omitted (freezed's copyWith can't pass
      // `null` for nullable fields).
      final cleared = AppSettings(
        locale: widget.settings.locale,
        themeMode: widget.settings.themeMode,
        weightUnit: widget.settings.weightUnit,
        remindersEnabled: widget.settings.remindersEnabled,
        timeSlotWidthMinutes: widget.settings.timeSlotWidthMinutes,
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
      setState(() => _errorText = l10n.settingsHeightInvalid);
      return;
    }
    if (parsed < 80 || parsed > 250) {
      setState(() => _errorText = l10n.settingsHeightOutOfRange);
      return;
    }
    setState(() => _errorText = null);
    await ref
        .read(settingsProvider.notifier)
        .save(widget.settings.copyWith(heightCm: parsed));
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
              labelText: l10n.settingsHeightLabel,
              suffixText: l10n.settingsHeightSuffix,
              helperText: l10n.settingsHeightHint,
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
