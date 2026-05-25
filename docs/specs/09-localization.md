# 09 — Localization

## Setup

- Use Flutter's built-in `gen_l10n` pipeline (ARB → generated
  `AppLocalizations`).
- Config in `l10n.yaml` at the project root.
- ARB files live in `lib/app/localization/arb/`.
- Generated output in `lib/app/localization/generated/` (committed).

```yaml
# l10n.yaml
arb-dir: lib/app/localization/arb
template-arb-file: app_en.arb           # English is the source of truth
output-localization-file: app_localizations.dart
output-dir: lib/app/localization/generated
synthetic-package: false
nullable-getter: false
```

ARB files: `app_en.arb` (template / default), `app_de.arb`, `app_zh.arb`.
Every key present in `app_en.arb` MUST exist in `app_de.arb` and
`app_zh.arb`. Missing-key analyzer warnings are treated as errors in CI.

## Supported locales

- `en` — English (**default**; the template ARB; copy decisions are made in EN first)
- `de` — German
- `zh` — Chinese, Simplified (`zh-Hans`); region-neutral until a Traditional variant is requested

Locale resolution priority:

1. Explicit user choice in settings.
2. Device locale, if supported. Chinese device locales (`zh`, `zh-CN`,
   `zh-Hans-*`, `zh-SG`) resolve to `zh`. Traditional variants
   (`zh-Hant`, `zh-TW`, `zh-HK`) also resolve to `zh` for the MVP —
   document this in the privacy/about screen so the choice is explicit.
3. Fallback to `en`.

The settings picker shows three options plus "System": **English**,
**Deutsch**, **中文**.

## Rules

- **No hardcoded UI strings** in widgets once localization is wired up.
  During very early prototyping, strings may live inline, but they must
  be moved into ARB before the feature ships.
- Pluralization uses ICU `plural` syntax in ARB, not string concatenation.
- Dates and numbers use `intl` formatters with the active locale —
  never `toString()` for user-facing values.
- Singletons that need locale awareness (e.g., the rule-based insight
  engine) receive a `AppLocalizations` instance via parameter, not via a
  global lookup. This keeps them testable.

## Numeric formatting

- Blood pressure values: no decimals.
- Pulse: no decimals.
- Pulse pressure, MAP: no decimals.
- Weight: one decimal, with the user's selected unit.
- Locale-aware decimal separator (`.` in EN and ZH, `,` in DE) via `intl`
  `NumberFormat`. Never call `toString()` on a number for UI.
- Dates: `intl` `DateFormat.yMMMd(locale)` (EN: "May 30, 2026", DE:
  "30. Mai 2026", ZH: "2026年5月30日"). Times: `Hm` (24 h) in all locales.

## Terminology — English ↔ German ↔ Chinese

English is the source of truth (template ARB). German and Chinese are
maintained alongside.

| English | German | 中文 |
|---|---|---|
| Overview | Überblick | 概览 |
| History | Verlauf | 历史 |
| Statistics | Statistiken | 统计 |
| Status / Classification | Status | 状态 |
| Reading | Messung / Eintrag | 测量记录 |
| Add reading | Messung erfassen | 添加记录 |
| Edit reading | Messung bearbeiten | 编辑记录 |
| Delete reading | Messung löschen | 删除记录 |
| Systolic | Systolisch | 收缩压 |
| Diastolic | Diastolisch | 舒张压 |
| Pulse | Puls | 脉搏 |
| Blood pressure | Blutdruck | 血压 |
| Weight | Gewicht | 体重 |
| Height | Größe | 身高 |
| BMI | BMI | BMI |
| BMI — underweight / normal / overweight / obese | Untergewicht / Normalgewicht / Übergewicht / Adipositas | 偏瘦 / 正常 / 超重 / 肥胖 |
| Profile | Profil | 个人资料 |
| Notes | Notiz | 备注 |
| Medication note | Medikament | 用药备注 |
| Arm — left/right | Arm — links/rechts | 测量手臂 — 左 / 右 |
| Body position | Körperhaltung | 测量姿势 |
| Sitting / Lying / Standing | sitzend / liegend / stehend | 坐 / 卧 / 立 |
| Stress level | Stress | 压力等级 |
| Report period | Berichtszeitraum | 报告时段 |
| Entries | Einträge | 条目 |
| Average | Mittel | 平均 |
| Minimum | Min | 最小 |
| Maximum | Max | 最大 |
| Pulse pressure | Pulsdruck | 脉压 |
| Mean arterial pressure | Mittlerer arterieller Druck (MAD) | 平均动脉压 (MAP) |
| Trend — up/down/stable/unknown | Trend — steigend/fallend/stabil/unbekannt | 趋势 — 上升 / 下降 / 稳定 / 未知 |
| Optimal | optimal | 理想 |
| Normal | normal | 正常 |
| High normal | hochnormal | 正常偏高 |
| Hypertension grade 1/2/3 | Bluthochdruck Grad 1/2/3 | 高血压 1 / 2 / 3 级 |
| Isolated systolic hypertension | Isolierte systolische Hypertonie | 单纯收缩期高血压 |
| Hypotension | niedriger Blutdruck | 低血压 |
| Settings | Einstellungen | 设置 |
| Units | Einheiten | 单位 |
| Language | Sprache | 语言 |
| Theme | Erscheinungsbild | 主题 |
| Reminders | Erinnerungen | 提醒 |
| Export | Exportieren | 导出 |
| Privacy info | Datenschutz | 隐私说明 |
| Disclaimer | Hinweis | 免责声明 |
| Save | Speichern | 保存 |
| Cancel | Abbrechen | 取消 |
| Delete | Löschen | 删除 |
| Confirm | Bestätigen | 确认 |
| Empty state — no readings | Noch keine Einträge | 暂无记录 |
| First reading CTA | Erste Messung erfassen | 记录第一次测量 |
| Time slot | Zeitfenster | 时间段 |
| Slot width | Fensterbreite | 时间段长度 |
| Slot start | Slot-Start | 起始时间 |
| Auto-detect slot | Slot automatisch wählen | 自动选择时间段 |
| Auto-detected | automatisch erkannt | 自动识别 |
| Pinned | festgelegt | 已固定 |
| Fitbit / Google Health | Fitbit / Google Health | Fitbit / Google Health |
| Sleep | Schlaf | 睡眠 |
| Activity | Aktivität | 活动 |
| Steps | Schritte | 步数 |
| Resting heart rate | Ruhepuls | 静息心率 |
| Active minutes | Aktive Minuten | 活动时长 |
| Connect (account) | Verbinden | 连接 |
| Disconnect | Trennen | 断开 |
| Coming soon | Bald verfügbar | 即将推出 |

This table is the source of truth for any in-app term. Add new rows as
features land; never invent ad-hoc translations in widgets.

## Disclaimer strings

Stored as **three long-form keys** — one per supported locale — in ARB,
identical in meaning to the text in
[12-privacy-and-medical.md](12-privacy-and-medical.md). Never re-author
the disclaimer in widgets; always read from i18n. The Chinese disclaimer
goes through medical-language review before shipping; until then, the
Chinese build falls back to the English disclaimer with a small note that
the German/English text is canonical.
