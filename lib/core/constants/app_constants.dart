/// Cross-cutting constants. Keep this file small; per-feature constants
/// belong with their feature.
library;

/// Disclaimer text version. Bump when the canonical disclaimer copy in
/// `docs/specs/12-privacy-and-medical.md` changes in a way that warrants
/// re-acceptance from the user. The first-launch dialog reappears
/// whenever the stored `disclaimerAcceptedVersion` is less than this.
const int kDisclaimerVersion = 1;

/// 4-pt spacing scale used by every screen and card.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii used by shared widgets.
abstract final class AppRadii {
  static const double card = 16;
  static const double button = 12;
  static const double input = 12;
  static const double chip = 999;
}
