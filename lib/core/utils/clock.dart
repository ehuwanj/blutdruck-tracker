// ignore: one_member_abstracts, required by docs/specs/07-state-management.md.
abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}
