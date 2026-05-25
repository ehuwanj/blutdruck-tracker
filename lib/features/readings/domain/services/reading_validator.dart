import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';

class ReadingValidator {
  const ReadingValidator();

  ValidationResult validate({
    required BloodPressureReading reading,
    DateTime? now,
    BloodPressureReading? previousReading,
  }) {
    final errors = <ValidationIssue>[];
    final warnings = <ValidationIssue>[];
    final effectiveNow = now ?? DateTime.now().toUtc();

    _checkIntRange(
      value: reading.systolic,
      min: 50,
      max: 260,
      lowWarning: 80,
      highWarning: 200,
      error: ValidationIssue.systolicOutOfRange,
      warning: ValidationIssue.systolicUnusual,
      errors: errors,
      warnings: warnings,
    );
    _checkIntRange(
      value: reading.diastolic,
      min: 30,
      max: 200,
      lowWarning: 40,
      highWarning: 130,
      error: ValidationIssue.diastolicOutOfRange,
      warning: ValidationIssue.diastolicUnusual,
      errors: errors,
      warnings: warnings,
    );
    final pulse = reading.pulse;
    if (pulse != null) {
      _checkIntRange(
        value: pulse,
        min: 25,
        max: 220,
        lowWarning: 40,
        highWarning: 150,
        error: ValidationIssue.pulseOutOfRange,
        warning: ValidationIssue.pulseUnusual,
        errors: errors,
        warnings: warnings,
      );
    }
    final weightKg = reading.weightKg;
    if (weightKg != null) {
      if (weightKg < 20 || weightKg > 400) {
        errors.add(ValidationIssue.weightOutOfRange);
      } else if (previousReading?.weightKg case final previous?) {
        if ((weightKg - previous).abs() > 5) {
          warnings.add(ValidationIssue.weightStepUnusual);
        }
      }
    }
    if (reading.systolic <= reading.diastolic + 5) {
      warnings.add(ValidationIssue.systolicDiastolicClose);
    }
    if (reading.measuredAt.isAfter(
      effectiveNow.add(const Duration(hours: 1)),
    )) {
      errors.add(ValidationIssue.measuredAtTooFarInFuture);
    }
    if (reading.measuredAt.isBefore(_subtractYears(effectiveNow, 5))) {
      warnings.add(ValidationIssue.measuredAtOlderThanFiveYears);
    }
    if ((reading.note?.length ?? 0) > 500) {
      errors.add(ValidationIssue.noteTooLong);
    }
    if ((reading.medicationNote?.length ?? 0) > 200) {
      errors.add(ValidationIssue.medicationNoteTooLong);
    }

    return ValidationResult(errors: errors, warnings: warnings);
  }

  void _checkIntRange({
    required int value,
    required int min,
    required int max,
    required int lowWarning,
    required int highWarning,
    required ValidationIssue error,
    required ValidationIssue warning,
    required List<ValidationIssue> errors,
    required List<ValidationIssue> warnings,
  }) {
    if (value < min || value > max) {
      errors.add(error);
    } else if (value < lowWarning || value > highWarning) {
      warnings.add(warning);
    }
  }

  DateTime _subtractYears(DateTime date, int years) {
    return DateTime.utc(
      date.year - years,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}

class ValidationResult {
  const ValidationResult({required this.errors, required this.warnings});

  final List<ValidationIssue> errors;
  final List<ValidationIssue> warnings;

  bool get isValid => errors.isEmpty;
}

enum ValidationIssue {
  systolicOutOfRange,
  systolicUnusual,
  diastolicOutOfRange,
  diastolicUnusual,
  pulseOutOfRange,
  pulseUnusual,
  weightOutOfRange,
  weightStepUnusual,
  systolicDiastolicClose,
  measuredAtTooFarInFuture,
  measuredAtOlderThanFiveYears,
  noteTooLong,
  medicationNoteTooLong,
}
