import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/readings/domain/services/reading_validator.dart';
import 'package:blutdruck_tracker/features/readings/presentation/providers/reading_form_provider.dart';
import 'package:blutdruck_tracker/features/readings/presentation/widgets/reading_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Auto-advance thresholds. Once the parsed integer exceeds the threshold,
/// focus jumps to the next numeric field so the user can type the whole
/// reading (132/84/72) without lifting their finger to tab between fields.
/// Strict `>` (not `>=`) so users entering 60 / 30 / 30 exactly stay put.
const _systolicAdvanceAt = 60;
const _diastolicAdvanceAt = 30;
const _pulseAdvanceAt = 30;

class ReadingForm extends ConsumerStatefulWidget {
  const ReadingForm({required this.state, required this.readingId, super.key});

  final ReadingFormState state;
  final String? readingId;

  @override
  ConsumerState<ReadingForm> createState() => _ReadingFormState();
}

class _ReadingFormState extends ConsumerState<ReadingForm> {
  final _systolicFocus = FocusNode(debugLabel: 'systolic');
  final _diastolicFocus = FocusNode(debugLabel: 'diastolic');
  final _pulseFocus = FocusNode(debugLabel: 'pulse');
  final _weightFocus = FocusNode(debugLabel: 'weight');

  @override
  void dispose() {
    _systolicFocus.dispose();
    _diastolicFocus.dispose();
    _pulseFocus.dispose();
    _weightFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(
      readingFormNotifierProvider(widget.readingId).notifier,
    );
    final state = widget.state;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.measuredAtLabel),
            subtitle: Text(
              DateFormat.yMMMd().add_Hm().format(state.measuredAt.toLocal()),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.systolicLabel,
            initialValue: state.systolic?.toString(),
            suffixText: 'mmHg',
            keyboardType: TextInputType.number,
            focusNode: _systolicFocus,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              notifier.setSystolic(parsed);
              if (parsed != null && parsed > _systolicAdvanceAt) {
                _diastolicFocus.requestFocus();
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.diastolicLabel,
            initialValue: state.diastolic?.toString(),
            suffixText: 'mmHg',
            keyboardType: TextInputType.number,
            focusNode: _diastolicFocus,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              notifier.setDiastolic(parsed);
              if (parsed != null && parsed > _diastolicAdvanceAt) {
                _pulseFocus.requestFocus();
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.pulseLabel,
            initialValue: state.pulse?.toString(),
            suffixText: 'bpm',
            keyboardType: TextInputType.number,
            focusNode: _pulseFocus,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              notifier.setPulse(parsed);
              if (parsed != null && parsed > _pulseAdvanceAt) {
                _weightFocus.requestFocus();
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.weightLabel,
            initialValue: state.weightKg?.toString(),
            suffixText: 'kg',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            focusNode: _weightFocus,
            // The note field comes after weight; "next" jumps to it.
            textInputAction: TextInputAction.next,
            onChanged: (value) => notifier.setWeightKg(double.tryParse(value)),
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.noteLabel,
            initialValue: state.note,
            maxLines: 4,
            onChanged: notifier.setNote,
          ),
          const SizedBox(height: AppSpacing.md),
          ...state.validation.errors.map((issue) {
            return _ValidationText(text: _message(l10n, issue), isError: true);
          }),
          ...state.validation.warnings.map((issue) {
            return _ValidationText(text: _message(l10n, issue), isError: false);
          }),
        ],
      ),
    );
  }

  String _message(AppLocalizations l10n, ValidationIssue issue) {
    return switch (issue) {
      ValidationIssue.systolicDiastolicClose =>
        l10n.validationSystolicDiastolic,
      ValidationIssue.noteTooLong => l10n.validationNoteTooLong,
      ValidationIssue.measuredAtTooFarInFuture => l10n.validationFutureDate,
      _ => l10n.validationRange,
    };
  }
}

class _ValidationText extends StatelessWidget {
  const _ValidationText({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: TextStyle(color: color)),
    );
  }
}
