import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/services/reading_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Auto-disposed so a freshly-opened "Add" form always starts from the
/// empty state, never from whatever values the user typed during a
/// previous Add session. Riverpod ref-counts listeners: when the entry
/// screen widget tree is gone, the notifier is disposed; the next visit
/// triggers a fresh build() that returns ReadingFormState.empty.
final readingFormNotifierProvider =
    AsyncNotifierProvider.autoDispose.family<
      ReadingFormNotifier,
      ReadingFormState,
      String?
    >(ReadingFormNotifier.new);

class ReadingFormNotifier
    extends AutoDisposeFamilyAsyncNotifier<ReadingFormState, String?> {
  static const _validator = ReadingValidator();

  @override
  Future<ReadingFormState> build(String? readingId) async {
    if (readingId == null) {
      return ReadingFormState.empty(now: ref.read(clockProvider).now());
    }
    final reading = await ref.read(getReadingByIdProvider).call(readingId);
    return reading == null
        ? ReadingFormState.empty(now: ref.read(clockProvider).now())
        : ReadingFormState.fromReading(reading);
  }

  void setMeasuredAt(DateTime value) => _update((state) {
    return state.copyWith(measuredAt: value.toUtc());
  });

  void setSystolic(int? value) => _update((state) {
    return state.copyWith(systolic: value, clearSystolic: value == null);
  });

  void setDiastolic(int? value) => _update((state) {
    return state.copyWith(diastolic: value, clearDiastolic: value == null);
  });

  void setPulse(int? value) => _update((state) {
    return state.copyWith(pulse: value, clearPulse: value == null);
  });

  void setWeightKg(double? value) => _update((state) {
    return state.copyWith(weightKg: value, clearWeightKg: value == null);
  });

  void setNote(String? value) => _update((state) {
    final normalized = _blankToNull(value);
    return state.copyWith(note: normalized, clearNote: normalized == null);
  });

  Future<bool> submit() async {
    final current = state.valueOrNull;
    if (current == null) {
      return false;
    }
    final validated = _validated(current);
    state = AsyncData(validated);
    if (!validated.canSubmit) {
      return false;
    }
    final now = ref.read(clockProvider).now();
    final reading = validated.toReading(now: now);
    if (validated.readingId == null) {
      await ref.read(addReadingProvider).call(reading);
    } else {
      await ref.read(updateReadingProvider).call(reading);
    }
    return true;
  }

  void _update(ReadingFormState Function(ReadingFormState state) update) {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    state = AsyncData(_validated(update(current)));
  }

  ReadingFormState _validated(ReadingFormState draft) {
    if (draft.systolic == null || draft.diastolic == null) {
      return draft.copyWith(validation: _emptyValidation);
    }
    return draft.copyWith(
      validation: _validator.validate(
        reading: draft.toReading(now: ref.read(clockProvider).now()),
        now: ref.read(clockProvider).now(),
      ),
    );
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

const _emptyValidation = ValidationResult(errors: [], warnings: []);

class ReadingFormState {
  const ReadingFormState({
    required this.measuredAt,
    required this.validation,
    required this.createdAt,
    this.readingId,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.weightKg,
    this.note,
  });

  factory ReadingFormState.empty({required DateTime now}) {
    return ReadingFormState(
      measuredAt: now,
      createdAt: now,
      validation: _emptyValidation,
    );
  }

  factory ReadingFormState.fromReading(BloodPressureReading reading) {
    return ReadingFormState(
      readingId: reading.id,
      measuredAt: reading.measuredAt,
      createdAt: reading.createdAt,
      systolic: reading.systolic,
      diastolic: reading.diastolic,
      pulse: reading.pulse,
      weightKg: reading.weightKg,
      note: reading.note,
      validation: _emptyValidation,
    );
  }

  final String? readingId;
  final DateTime measuredAt;
  final DateTime createdAt;
  final int? systolic;
  final int? diastolic;
  final int? pulse;
  final double? weightKg;
  final String? note;
  final ValidationResult validation;

  bool get canSubmit {
    return systolic != null && diastolic != null && validation.errors.isEmpty;
  }

  ReadingFormState copyWith({
    String? readingId,
    DateTime? measuredAt,
    DateTime? createdAt,
    int? systolic,
    int? diastolic,
    int? pulse,
    double? weightKg,
    String? note,
    ValidationResult? validation,
    bool clearSystolic = false,
    bool clearDiastolic = false,
    bool clearPulse = false,
    bool clearWeightKg = false,
    bool clearNote = false,
  }) {
    return ReadingFormState(
      readingId: readingId ?? this.readingId,
      measuredAt: measuredAt ?? this.measuredAt,
      createdAt: createdAt ?? this.createdAt,
      systolic: clearSystolic ? null : systolic ?? this.systolic,
      diastolic: clearDiastolic ? null : diastolic ?? this.diastolic,
      pulse: clearPulse ? null : pulse ?? this.pulse,
      weightKg: clearWeightKg ? null : weightKg ?? this.weightKg,
      note: clearNote ? null : note ?? this.note,
      validation: validation ?? this.validation,
    );
  }

  BloodPressureReading toReading({required DateTime now}) {
    return BloodPressureReading(
      id: readingId ?? const Uuid().v4(),
      measuredAt: measuredAt.toUtc(),
      systolic: systolic ?? 120,
      diastolic: diastolic ?? 80,
      pulse: pulse,
      weightKg: weightKg,
      note: note,
      source: ReadingSource.manual,
      createdAt: readingId == null ? now : createdAt,
      updatedAt: now,
    );
  }
}
