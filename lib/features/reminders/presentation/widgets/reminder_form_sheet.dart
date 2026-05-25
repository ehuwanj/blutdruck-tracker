import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:flutter/material.dart';

/// Bottom sheet for creating or editing a [Reminder]. Pops the new value
/// (or `null` on cancel). The caller persists via the repository so this
/// widget stays platform-free.
class ReminderFormSheet extends StatefulWidget {
  const ReminderFormSheet({this.initial, super.key});

  final Reminder? initial;

  @override
  State<ReminderFormSheet> createState() => _ReminderFormSheetState();
}

class _ReminderFormSheetState extends State<ReminderFormSheet> {
  late TimeOfDay _time;
  late Set<int> _weekdays;
  late TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _time = initial != null
        ? TimeOfDay(hour: initial.hour, minute: initial.minute)
        : const TimeOfDay(hour: 7, minute: 0);
    _weekdays = {...?initial?.weekdays};
    _labelController = TextEditingController(text: initial?.label ?? '');
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEdit = widget.initial != null;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? l10n.reminderEditTitle : l10n.reminderAddTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: Text(l10n.reminderTimeLabel),
              subtitle: Text(_time.format(context)),
              onTap: _pickTime,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.reminderWeekdaysLabel),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final weekday in const [
                  DateTime.monday,
                  DateTime.tuesday,
                  DateTime.wednesday,
                  DateTime.thursday,
                  DateTime.friday,
                  DateTime.saturday,
                  DateTime.sunday,
                ])
                  FilterChip(
                    label: Text(_shortWeekday(l10n, weekday)),
                    selected: _weekdays.contains(weekday),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _weekdays.add(weekday);
                        } else {
                          _weekdays.remove(weekday);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                labelText: l10n.reminderLabelLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancelButton),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(onPressed: _save, child: Text(l10n.saveButton)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null || !mounted) return;
    setState(() => _time = picked);
  }

  void _save() {
    final label = _labelController.text.trim();
    final reminder = Reminder(
      id: widget.initial?.id ?? '',
      hour: _time.hour,
      minute: _time.minute,
      weekdays: _weekdays,
      enabled: widget.initial?.enabled ?? true,
      label: label.isEmpty ? null : label,
    );
    Navigator.of(context).pop(reminder);
  }
}

String _shortWeekday(AppLocalizations l10n, int weekday) {
  return switch (weekday) {
    DateTime.monday => l10n.weekdayMon,
    DateTime.tuesday => l10n.weekdayTue,
    DateTime.wednesday => l10n.weekdayWed,
    DateTime.thursday => l10n.weekdayThu,
    DateTime.friday => l10n.weekdayFri,
    DateTime.saturday => l10n.weekdaySat,
    DateTime.sunday => l10n.weekdaySun,
    _ => '',
  };
}
