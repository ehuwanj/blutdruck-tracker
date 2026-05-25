/// Helpers around local-day boundaries. Storage stays UTC; the UI groups
/// and renders in the device's current time zone, so these helpers always
/// pivot through `toLocal()` before slicing.
library;

/// 00:00:00 of the local day containing [instant].
DateTime startOfLocalDay(DateTime instant) {
  final local = instant.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// 23:59:59.999 of the local day containing [instant].
DateTime endOfLocalDay(DateTime instant) {
  final local = instant.toLocal();
  return DateTime(local.year, local.month, local.day, 23, 59, 59, 999);
}

/// True when [a] and [b] fall on the same local calendar day. Works
/// correctly across DST boundaries because both inputs are converted to
/// local time before comparison.
bool isSameLocalDay(DateTime a, DateTime b) {
  final la = a.toLocal();
  final lb = b.toLocal();
  return la.year == lb.year && la.month == lb.month && la.day == lb.day;
}
