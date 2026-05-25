# 06 — Design System

## Tone

Calm, trustworthy, clinical-but-warm. Closer to a wellness journal than a
medical device dashboard. Generous whitespace, rounded shapes, restrained
color.

## Theme

Use Material 3 with a custom `ColorScheme.fromSeed(...)`. Both light and
dark themes are first-class. Theme selection follows
`AppSettings.themeMode` and defaults to `system`.

```dart
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: Brightness.light,
  ),
  textTheme: AppTypography.textTheme,
  cardTheme: AppTheme.cardTheme,
  ...
);
```

## Color tokens — `app_colors.dart`

| Token | Light | Dark | Use |
|-------|-------|------|-----|
| `seed` | `#3F6F84` | same | Material seed color |
| `success` | `#2E7D5B` | `#7FCBA8` | optimal/normal categories |
| `info` | `#3F6F84` | `#9BC6D6` | neutral metadata, MAP |
| `caution` | `#C19A2B` | `#E7C766` | highNormal / soft warnings |
| `warn` | `#B86E2B` | `#E89C66` | grade 1 hypertension |
| `alert` | `#A04341` | `#E08583` | grade 2/3 hypertension, hypotension |
| `surface` | `#F7F6F2` | `#15171A` | screen background |
| `surfaceVariant` | `#FFFFFF` | `#1E2125` | card background |
| `outline` | `#D9D7D0` | `#2F3338` | dividers |
| `text` | `#1C1B1F` | `#ECECEC` | primary text |
| `textMuted` | `#5E5F62` | `#A2A4A8` | secondary text |

Avoid pure red (`#FF0000`); the strongest "warning" color is `alert`. Color
is **never** the only indicator — pair with an icon, a label, or both.

### Binding to ThemeData

Define the semantic tokens as a `ThemeExtension` so widgets read them via
`Theme.of(context).extension<AppColors>()` and dark/light variants flow
naturally from `ThemeData`:

```dart
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.info,
    required this.caution,
    required this.warn,
    required this.alert,
    required this.textMuted,
    // surface, surfaceVariant, outline, text already come from ColorScheme
  });

  final Color success;
  final Color info;
  final Color caution;
  final Color warn;
  final Color alert;
  final Color textMuted;

  @override
  AppColors copyWith({/* … */}) { /* … */ }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) { /* … */ }
}
```

Register `AppColors.light` / `AppColors.dark` via
`ThemeData(extensions: [...])`. **Do not** add `AppColors` as a plain
static-fields class; that path breaks dark-mode swapping. Surface and
text colors stay on `ColorScheme`; only the semantic categories (success,
caution, warn, alert, info, textMuted) live on the extension.

## Typography — `app_typography.dart`

- Base font: system default (San Francisco on iOS, Roboto on Android).
- Optional: bundle a monospaced-figures variant for large numeric displays.

Scale (Material 3 names retained, sizes adjusted):

| Style | Size | Weight | Use |
|-------|------|--------|-----|
| `displayLarge` | 48 | w600 | latest reading numbers |
| `displayMedium` | 36 | w600 | stat headlines |
| `titleLarge` | 22 | w600 | screen titles |
| `titleMedium` | 18 | w600 | card titles |
| `bodyLarge` | 16 | w400 | primary text |
| `bodyMedium` | 14 | w400 | secondary text |
| `labelLarge` | 14 | w500 | buttons |
| `labelSmall` | 12 | w500 | chips, captions |

Numeric values that need to align in columns (statistics card) use the
`fontFeatures: [FontFeature.tabularFigures()]` flag.

## Spacing

Use a 4-pt base scale. Define constants in `core/constants/app_constants.dart`:

| Token | Value |
|-------|-------|
| `spaceXxs` | 2 |
| `spaceXs` | 4 |
| `spaceSm` | 8 |
| `spaceMd` | 12 |
| `spaceLg` | 16 |
| `spaceXl` | 24 |
| `spaceXxl` | 32 |

Card padding default: `spaceLg` on all sides. Screen edge padding: `spaceLg`.

## Radii

- Card: 16
- Button: 12
- Input: 12
- Chip: 999 (pill)

## Shadows

- Light mode: subtle (`elevation: 1` + a 1 dp y-shadow).
- Dark mode: no elevation; rely on `surfaceVariant` contrast.

## Shared widgets — `core/widgets/`

These are the building blocks every feature uses.

### `AppCard`

Rounded surface container with consistent padding. Wraps content; never
contains business logic.

```dart
AppCard(
  title: 'Statistik',
  trailing: IconButton(icon: const Icon(Icons.tune), onPressed: ...),
  child: ...,
);
```

### `AppLoadingView`

Centered, restrained `CircularProgressIndicator`. Used as the loading
fallback in every `AsyncValue.when`.

### `AppEmptyState`

Icon + headline + body + optional CTA button. Used when a list is empty,
no readings exist yet, etc.

### `AppErrorView`

Icon + headline + body + optional "Wiederholen" button. Used in
`AsyncValue.when` error branches.

### `BloodPressureValueDisplay`

Composite widget for systolic/diastolic display with consistent sizing,
optional pulse, and an optional category dot.

### `CategoryDot`

Small circle in the category color. Always rendered with a tooltip and
semantic label so it is not "color-only" information.

### `TrendIcon`

Up/down/stable/unknown arrow with localized accessible label.

## Iconography

- Use Material symbols by default.
- Avoid heart-rate iconography on anything that isn't the pulse value.
- Avoid medical/clinical icons (stethoscope, syringe) anywhere in the app.

## Charts (`fl_chart`)

- Two-line chart: systolic (primary), diastolic (secondary). Stroke widths
  equal; differentiate by color + line style (solid vs. dashed) so users
  with color-vision differences can still tell them apart.
- Y-axis labels every 20 mmHg for blood pressure; auto for weight.
- X-axis labels: short date format. Avoid showing every label; let
  `fl_chart` skip.
- Tooltips on tap: show date+time, systolic, diastolic, pulse if present.
- No animation on first paint — it should look ready, not "performing".

## Accessibility

- Minimum text contrast meets WCAG AA against background.
- Minimum hit target 48×48 dp.
- Support text scaling up to 200% without clipping. Test the latest-reading
  card specifically — the large numbers must reflow gracefully.
- Every interactive widget has a `Semantics` label, especially icon-only
  buttons.
- VoiceOver/TalkBack reads the latest reading as a single sentence:
  "Letzte Messung: 132 zu 84, Puls 72, Kategorie hochnormal, vor zwei Stunden".

## Motion

- Respect `MediaQuery.disableAnimations` (reduced motion).
- Avoid parallax, decorative motion, page transitions longer than 300 ms.
