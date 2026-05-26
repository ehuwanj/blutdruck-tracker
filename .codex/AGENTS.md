# Codex Project Instructions

This project was originally driven by Claude Code. Codex must preserve that
workflow instead of inventing a competing one.

## Authoritative Project Guidance

Always read [`.claude/CLAUDE.md`](../.claude/CLAUDE.md) before making code
changes. Treat it as the project spine for non-negotiables, medical/privacy
rules, architecture, localization, testing gates, generated files, and commit
conventions.

The detailed source of truth lives in [`docs/specs/`](../docs/specs/). When a
spec and `.claude/CLAUDE.md` disagree, follow the spec and call out the
contradiction. Update the spec first if the user asks for a behavior change.

Implementation sequencing is defined in
[`docs/IMPLEMENTATION_PROMPTS.md`](../docs/IMPLEMENTATION_PROMPTS.md). For any
request shaped like `implement <N>`, follow the protocol in `.claude/CLAUDE.md`:

1. Open `docs/IMPLEMENTATION_PROMPTS.md`.
2. Find step `<N>`.
3. Read every spec listed under "Specs to read" before editing.
4. Implement only the listed deliverables.
5. Add exactly the listed tests.
6. Do not touch out-of-scope areas.
7. Run the required format, analyze, and test commands before declaring done.

## Project Snapshot

This is a Flutter/Dart app for personal blood pressure tracking:

- Local-first MVP, no backend and no remote network calls.
- Android-first, iOS-compatible.
- Feature-based Clean Architecture under `lib/features/`.
- Riverpod 2.x for state management.
- Drift/SQLite planned for persistence.
- Freezed models are generated and committed.
- Localization uses ARB files under `lib/app/localization/arb/` with generated
  output under `lib/app/localization/generated/`.
- Current code appears to be around the foundation/domain-model stage: app
  shell, theme, disclaimer stub, localization files, domain entities, and
  Freezed outputs are present; later feature/data/UI layers are still pending.

## Non-Negotiables To Recheck On Every Change

Follow `.claude/CLAUDE.md` for the full wording. The highest-risk rules are:

- The app is not a medical device. Do not add diagnosis, treatment advice,
  medication suggestions, emergency prompts, risk scores, or alarming labels.
- Do not log health values or other private health information.
- Do not add analytics, ads, crash reporting, Firebase, telemetry, or remote
  network calls for the MVP.
- Keep domain code pure Dart. No Flutter, Drift, platform plugins, or JSON in
  `domain/`.
- UI must not import Drift, files, or platform plugins directly.
- Cross-feature access must go through `domain/`, not another feature's `data/`
  or `presentation/`.
- No hardcoded visible UI strings in widgets. Use `AppLocalizations` and ARB.
- Disabled future gateways must throw `UnsupportedError` and must not contain
  real endpoints, tokens, client IDs, or commented-out API URLs.

## Codex Workflow

- Prefer small, step-scoped edits. Do not do opportunistic refactors.
- Read the relevant spec files before touching code.
- Use existing patterns in this repository before introducing new abstractions.
- Use `rg`/`rg --files` for searches.
- Use `apply_patch` for manual edits.
- Do not edit generated files directly. Change the source file and rerun the
  generator when needed.
- Do not run `dart run build_runner build --delete-conflicting-outputs` unless
  adding or changing Drift tables, Freezed classes, or JSON models.
- Generated files (`*.freezed.dart`, `*.g.dart`, `*.drift.dart`) are expected
  to be committed when their source changes.
- Preserve user changes in the worktree. Never revert unrelated edits unless
  the user explicitly asks.

## Commands

Use Git Bash for all `git` commands in this workspace. The configured Git Bash
launcher is:

```powershell
C:\Users\27750358\AppData\Local\Programs\Git\git-bash.exe
```

For non-interactive Codex command execution, use the same Git installation's
shell entry point and run project Git commands from the repository root, for
example:

```powershell
& 'C:\Users\27750358\AppData\Local\Programs\Git\bin\bash.exe' -lc 'cd /c/Data/ideas/blutdruck-tracker && git status --short'
```

For non-Git project commands, the Codex shell may still be PowerShell.

Common verification commands:

```powershell
dart format .
flutter analyze
flutter test
```

For CI-style formatting checks:

```powershell
dart format --set-exit-if-changed .
```

For code generation when required by the implementation step:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

If Flutter dependencies are missing, run:

```powershell
flutter pub get
```

## Architecture Reminders

Expected shape:

```text
lib/
  app/
  core/
  features/
    <feature>/
      domain/
      data/
      presentation/
```

Domain owns entities, repository interfaces, use cases, and pure services.
Data owns Drift, platform/file/plugin datasources, repository implementations,
and mappers. Presentation owns screens, widgets, and Riverpod-facing UI state.

Keep files cohesive, with one public class per file where practical. Aim for
files under about 250 lines, as requested in `.claude/CLAUDE.md`.

## Localization

Supported locales are English, German, and Simplified Chinese. The template ARB
is `app_en.arb`.

When adding a visible string:

1. Add the key to `lib/app/localization/arb/app_en.arb`.
2. Add matching keys to `app_de.arb` and `app_zh.arb`.
3. Regenerate localization output if needed.
4. Read strings through `AppLocalizations`.

Do not place disclaimer copy directly in widgets. The canonical text is defined
by `docs/specs/12-privacy-and-medical.md` and surfaced through localization.

## Testing Expectations

Scale tests to the risk of the change, but for numbered implementation steps
use the exact tests listed in `docs/IMPLEMENTATION_PROMPTS.md` and
`docs/specs/11-testing.md`.

Pure calculations and classifiers need unit tests. Screens need widget tests.
Database schema/migration work needs Drift-focused tests. The final MVP needs
the integration flow described in spec 11.

Do not declare a step complete while `flutter analyze` or `flutter test` is
failing unless the user explicitly asks to stop at a failing state.
