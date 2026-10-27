# AUDIT — Whole-Repository Mode

`audit [--focus <dimension>]` reviews an entire repository rather than a diff. Use when there is no change to review, or when the user asks for code health, security debt, or architecture assessment.

## Dimensions

| Dimension      | Scope                                                                       |
| -------------- | --------------------------------------------------------------------------- |
| `architecture` | Module boundaries, dependency direction, layering violations, circular deps |
| `code-health`  | Dead code, duplication, error-handling consistency, TODO debt               |
| `security`     | Secret handling, dependency vulnerabilities, authz patterns, unsafe sinks   |
| `dependencies` | Outdated/vulnerable deps, lockfile hygiene, license conflicts               |
| `tests`        | Coverage shape (which subsystems are untested), test quality, CI gaps       |
| `performance`  | Known hot paths, obvious algorithmic risks, resource lifecycle              |

Default: run `architecture` + `code-health` + `tests`; add others by `--focus`.

## Pipeline differences

- **GATHER** becomes scoping: repo map, module inventory, dependency manifest, CI config → `materials/context/`
- **ANALYZE** produces an audit report per dimension with the same evidence rules (file:line, quoted code, consequence) — severity maps to the same rubric, where `blocker` means "exploitable or data-loss risk in current state"
- **REPORT** verdict semantics change: PASS = no blockers found in audited dimensions; the report always lists which dimensions were **not** audited

## Boundaries

- An audit samples; it does not prove absence. State coverage explicitly ("12 of 34 modules reviewed in depth").
- Findings aggregate into themes (e.g. "error handling is inconsistent across 6 modules") rather than 200 line items — lead with themes, attach representative evidence.
