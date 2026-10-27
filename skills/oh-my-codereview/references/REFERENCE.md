# Reference — Oh-My-CodeReview Operations

Complete operation guide. SKILL.md is the entry point; this file is the detail.

## Operation Index

| Op                     | Reference                       | Purpose                             |
| ---------------------- | ------------------------------- | ----------------------------------- |
| `init "<target>"`      | `INIT/init.md`                  | Bootstrap review workspace          |
| `gather <pr            | diff                            | range                               | repo>` | `GATHER/gather.md` | Build the change surface + Gate G |
| `analyze`              | `ANALYZE/analyze.md`            | Findings with evidence + Gate A     |
| `lens [name]`          | `LENS/lens.md`                  | Structured review passes            |
| `report [opts]`        | `REPORT/report.md`              | Verdict report + Gate P/D           |
| `recheck`              | `RECHECK/recheck.md`            | Findings vs new commits             |
| `audit [--focus]`      | `AUDIT/audit.md`                | Whole-repo mode                     |
| `version …`            | `VERSION/version.md`            | Tag / backup artifacts              |
| `workflow [--pattern]` | `WORKFLOW/workflow-overview.md` | Guided multi-step run               |
| `qa …`                 | `GATES.md`                      | QA checklists, state reconciliation |

## Artifact Naming

| Artifact               | Pattern                                                                 |
| ---------------------- | ----------------------------------------------------------------------- |
| Findings set           | `docs/review/findings-<n>.md` (n increments per gather batch / recheck) |
| Risk map               | `docs/review/risk-map.md`                                               |
| Verdict draft          | `docs/review/verdict-draft.md`                                          |
| Dispute notes          | `docs/review/disputes.md`                                               |
| Audit dimension report | `docs/audit/<dimension>-<n>.md`                                         |
| Deliverable            | `deliverables/<target>-review-<lang>.<ext>`                             |
| Gate record            | `.ocr/quality-gates/<gate>-<n>.json`                                    |

Finding ids `F-0NN` are stable across rechecks: a finding is never silently renumbered; `withdrawn`/`resolved` ids stay reserved.

## Evidence Boundaries (canonical statement)

1. **file:line is sacred** — only cite lines read in gathered context or the diff itself
2. **mechanical before claimed** — run tests/type-check/build when possible; else grade confidence down and say so
3. **intent vs implementation** — commit messages are evidence; behavior changes may be intended (`possible-intent`, resolve at Gate A/B)
4. **consequence required** — a finding without a concrete "when X, Y happens because Z" is a nit at best, withdrawn at worst
5. **silence must mean checked** — the report's "what was checked and passed" section makes non-findings explicit

## Tree State

See `LLM-STATE.md`. Update after every op; reconcile at op start; overrides are recorded, never persistent.

## Troubleshooting

| Symptom                                         | Cause                                    | Fix                                                              |
| ----------------------------------------------- | ---------------------------------------- | ---------------------------------------------------------------- |
| Findings cite lines that do not exist           | Analyzed from hunks without full context | Re-run GATHER with context files; withdraw unverifiable findings |
| Verdict feels too soft                          | Gate D skipped or rubric not applied     | `qa qa2`; recompute verdict from severity counts                 |
| Review repeats from zero each push              | RECHECK not used                         | Follow `RECHECK/recheck.md`; carry findings forward              |
| tree-state says report unlocked but no findings | Stale state                              | `qa state-check`, rebuild from disk                              |
| Report full of workflow jargon                  | Gate D leak check skipped                | Apply `REPORT/report.md` publishing rules                        |
