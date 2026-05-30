import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 5, 25, 7, 30);

  BloodPressureReading make({int systolic = 132, int diastolic = 84}) {
    return BloodPressureReading(
      id: 'r1',
      measuredAt: now,
      systolic: systolic,
      diastolic: diastolic,
      pulse: 72,
      weightKg: 78.5,
      note: 'after coffee',
      source: ReadingSource.manual,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('constructs with all fields and copyWith replaces systolic', () {
    final r = make();
    expect(r.systolic, 132);
    expect(r.note, 'after coffee');
    final r2 = r.copyWith(systolic: 140);
    expect(r2.systolic, 140);
    expect(r2.diastolic, r.diastolic);
  });

  test('pulsePressure = systolic - diastolic', () {
    final r = make(systolic: 140, diastolic: 90);
    expect(r.pulsePressure, 50);
  });

  test('meanArterialPressure = diastolic + pulsePressure / 3', () {
    final r = make(systolic: 140, diastolic: 90);
    // 90 + 50 / 3 = 106.666…
    expect(r.meanArterialPressure, closeTo(106.6667, 1e-4));
  });
}
