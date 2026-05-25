/// Blood-pressure category used by the classifier. There is no `unknown`
/// value — validation rejects implausible readings before they reach the
/// classifier, so the classifier is exhaustive on persisted readings. See
/// docs/specs/04-business-logic.md §Classification for the 8-step
/// evaluation order.
enum BloodPressureCategory {
  hypotension,
  optimal,
  normal,
  highNormal,
  hypertensionGrade1,
  hypertensionGrade2,
  hypertensionGrade3,
  isolatedSystolic,
}
