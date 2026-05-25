import 'package:blutdruck_tracker/core/utils/date_time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('startOfLocalDay', () {
    test('snaps a local timestamp back to 00:00:00 of the same day', () {
      final input = DateTime(2026, 5, 25, 7, 30, 12, 345);
      final result = startOfLocalDay(input);
      expect(result, DateTime(2026, 5, 25));
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
      expect(result.millisecond, 0);
    });

    test('converts UTC to local before slicing', () {
      // Two UTC instants 15 minutes apart can fall on different local days
      // depending on the device time zone. Either way, startOfLocalDay must
      // be stable for each (i.e., never return a UTC midnight).
      final a = DateTime.utc(2026, 5, 25, 22, 50);
      final b = DateTime.utc(2026, 5, 25, 23, 05);
      final dayA = startOfLocalDay(a);
      final dayB = startOfLocalDay(b);
      expect(dayA.isUtc, isFalse);
      expect(dayB.isUtc, isFalse);
      // Each day boundary equals the local midnight of its input.
      final aLocal = a.toLocal();
      final bLocal = b.toLocal();
      expect(dayA, DateTime(aLocal.year, aLocal.month, aLocal.day));
      expect(dayB, DateTime(bLocal.year, bLocal.month, bLocal.day));
    });
  });

  group('isSameLocalDay', () {
    test('treats two local instants on the same calendar day as equal', () {
      final morning = DateTime(2026, 5, 25, 7);
      final evening = DateTime(2026, 5, 25, 21, 30);
      expect(isSameLocalDay(morning, evening), isTrue);
    });

    test('separates adjacent local days', () {
      final lastMinute = DateTime(2026, 5, 25, 23, 59);
      final firstMinute = DateTime(2026, 5, 26, 0, 1);
      expect(isSameLocalDay(lastMinute, firstMinute), isFalse);
    });

    test('works across a DST boundary using local-time semantics', () {
      // Central European DST: spring forward on 2026-03-29 02:00 local →
      // 03:00 local (01:00 UTC → 02:00 UTC). Two instants on opposite
      // sides of that wall-clock skip still belong to the same local day
      // 2026-03-29.
      final beforeSkip = DateTime(2026, 3, 29, 1, 30);
      final afterSkip = DateTime(2026, 3, 29, 4, 30);
      expect(isSameLocalDay(beforeSkip, afterSkip), isTrue);
      expect(startOfLocalDay(beforeSkip), startOfLocalDay(afterSkip));
    });
  });

  group('endOfLocalDay', () {
    test('returns 23:59:59.999 of the local day', () {
      final input = DateTime(2026, 5, 25, 7, 30);
      final result = endOfLocalDay(input);
      expect(result, DateTime(2026, 5, 25, 23, 59, 59, 999));
    });
  });
}
