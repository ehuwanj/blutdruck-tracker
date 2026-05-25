/// WHO BMI categories. See docs/specs/04-business-logic.md §BMI for
/// threshold boundaries.
enum BmiCategory {
  /// `bmi < 18.5`
  underweight,

  /// `18.5 <= bmi < 25`
  normal,

  /// `25 <= bmi < 30`
  overweight,

  /// `bmi >= 30`
  obese,
}
