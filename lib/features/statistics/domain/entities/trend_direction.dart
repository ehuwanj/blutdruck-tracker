/// Direction of a metric's trend over a selected period. `unknown` is a
/// semantically meaningful state ("not enough data"), unlike the removed
/// `unknown` values on category enums.
enum TrendDirection { up, down, stable, unknown }
