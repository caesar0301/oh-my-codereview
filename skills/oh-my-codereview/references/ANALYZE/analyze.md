# ANALYZE — Findings with Evidence

`analyze` turns the change surface into a findings set: severity, category, evidence, consequence.

Run Gate G first if not yet recorded. Then read the full context files — not just hunks — and produce `docs/review/findings-<n>.md`.

## Finding format

Each finding is a numbered record (`F-001`, `F-002`, …):

```markdown
### F-003 — <one-line title>

- Severity: blocker | major | minor | nit
- Category: correctness | security | performance | concurrency | api-contract | test-coverage | maintainability
- Evidence: path/to/file.py:42 — quoted code from the gathered surface
- Reasoning: why this is wrong, with the concrete consequence ("when X, Y happens because Z")
- Suggestion: concrete fix direction (diff sketch when useful)
- Confidence: high | medium | low
```

Also produce `docs/review/risk-map.md`: which subsystems the change touches, blast radius, untested paths.

## Evidence boundaries

- **File:line is sacred.** Line numbers refer to files gathered in `materials/context/` (or the diff itself). Never cite a line you have not read.
- **Mechanical before claimed.** If tests/type-check/build can run, run them and cite output. If they cannot run, say so and lower confidence.
- **Intent vs implementation.** Read commit messages; a behavior change may be intended. Mark such findings `possible-intent` and ask at Gate A rather than blocking.
- **No style findings from taste alone.** If a linter would catch it, gather linter output instead; else it is at most a `nit`.

## Severity rubric (summary)

| Severity | Meaning                                                               |
| -------- | --------------------------------------------------------------------- |
| blocker  | Bug, vulnerability, or data-loss path that must be fixed before merge |
| major    | Should fix: wrong edge case, missing test for risky path, API misuse  |
| minor    | Real improvement, limited consequence                                 |
| nit      | Taste, naming, style — no behavioral consequence                      |

Full rubric: `../../assets/templates/verdict-rubric.md`.

## After analyze

Run **Gate A / QA1** (see `../GATES.md`): every finding has valid file:line evidence and a consequence; severities are rubric-consistent; no duplicates. Then offer the default lenses (correctness, security) before REPORT.
