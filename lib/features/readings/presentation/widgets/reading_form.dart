import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/measurement_arm.dart';
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
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.armLabel, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'none', label: Text(l10n.unspecifiedLabel)),
              ButtonSegment(value: 'left', label: Text(l10n.armLeftLabel)),
              ButtonSegment(value: 'right', label: Text(l10n.armRightLabel)),
            ],
            selected: {state.arm?.name ?? 'none'},
            onSelectionChanged: (selection) {
              final selected = selection.single;
              notifier.setArm(
                selected == 'left'
                    ? MeasurementArm.left
                    : selected == 'right'
                    ? MeasurementArm.right
                    : null,
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.stressLevelLabel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 0, label: Text(l10n.unspecifiedLabel)),
              for (var i = 1; i <= 5; i++)
                ButtonSegment(value: i, label: Text('$i')),
            ],
            selected: {state.stressLevel ?? 0},
            onSelectionChanged: (selection) {
              final selected = selection.single;
              notifier.setStressLevel(selected == 0 ? null : selected);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingFormField(
            label: l10n.medicationNoteLabel,
            initialValue: state.medicationNote,
            onChanged: notifier.setMedicationNote,
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
      ValidationIssue.medicationNoteTooLong => l10n.validationMedicationTooLong,
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
