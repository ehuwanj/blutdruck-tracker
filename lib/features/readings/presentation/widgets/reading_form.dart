import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/readings/domain/services/reading_validator.dart';
import 'package:blutdruck_tracker/features/readings/presentation/providers/reading_form_provider.dart';
import 'package:blutdruck_tracker/features/readings/presentation/widgets/reading_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReadingForm extends ConsumerWidget {
  const ReadingForm({required this.state, required this.readingId, super.key});

  final ReadingFormState state;
  final String? readingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(readingFormNotifierProvider(readingId).notifier);
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
            onChanged: (value) => notifier.setSystolic(int.tryParse(value)),
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.diastolicLabel,
            initialValue: state.diastolic?.toString(),
            suffixText: 'mmHg',
            keyboardType: TextInputType.number,
            onChanged: (value) => notifier.setDiastolic(int.tryParse(value)),
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.pulseLabel,
            initialValue: state.pulse?.toString(),
            suffixText: 'bpm',
            keyboardType: TextInputType.number,
            onChanged: (value) => notifier.setPulse(int.tryParse(value)),
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.weightLabel,
            initialValue: state.weightKg?.toString(),
            suffixText: 'kg',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
