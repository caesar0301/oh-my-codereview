# Graph-Guided Workflow

## Purpose

Pattern JSON graphs drive **recommended next steps**. Skills/ops remain freely invocable; the graph records successful paths and unlocks.

Runtime:

1. Read `.ocr/pattern.json` (default **Standard** if missing after init)
2. Derive artifact presence → update `.ocr/tree-state.json`
3. Recommend next node along edges
4. **LENS** is a side-cycle on `analyze` — does not replace edges unless the user stays in the lens loop

## Pattern Library (diff-first)

| Pattern            | File                           | Use when                                                     |
| ------------------ | ------------------------------ | ------------------------------------------------------------ |
| Standard (default) | `patterns/standard.json`       | Normal PR/diff review with gates                             |
| Rapid              | `patterns/rapid.json`          | Quick look, gates off, verdict in one pass                   |
| Deep-Audit         | `patterns/deep-audit.json`     | Whole-repo audit across dimensions                           |
| Security-Focus     | `patterns/security-focus.json` | Change touches auth, secrets, payments, or unsafe parsers    |
| Loop               | `patterns/loop.json`           | Iterative review: author pushes fixes, re-review until clean |

## Standard (default)

```
gather → [Gate G] → analyze ⟲ lens → [Gate T] → [Gate A / QA1] → [Gate P] → report (lenses → Gate D / QA2)
```

- Entry: `gather`
- After gather: Gate G (change-surface completeness) — warn on missing tests/context without opt-out
- After analyze findings: offer correctness + security lenses by default
- After lens: Gate T (more context needed from surfaced gaps?)
- Gate A / QA1 unlocks `report`
- Gate P confirms format / audience / strictness before the report outline
- Report: adversarial lens → Gate D / QA2 → deliverable in `deliverables/`

## Node ↔ Artifact Contracts

| Node      | Requires                | Produces                                                       |
| --------- | ----------------------- | -------------------------------------------------------------- |
| `init`    | —                       | `AGENTS.md`, `.ocr/tree-state.json`, `.ocr/pattern.json`       |
| `gather`  | workspace               | `materials/**`, `docs/index/changes-index.json`, Gate G result |
| `analyze` | diffs + context         | `docs/review/findings-<n>.md`, `docs/review/risk-map.md`       |
| `lens`    | findings                | refined findings (in place after confirm), lens run note       |
| `report`  | **findings** (required) | `docs/review/verdict-draft.md` + `deliverables/*`              |
| `recheck` | findings + newer diff   | updated findings (stamped) + report changelog                  |
| `audit`   | workspace + scope       | `docs/audit/*` dimension reports                               |

## Unlock Rules (tree-state)

```
unlocked always: init, gather
ready analyze: when diffs/context exist, then Gate G passes (change-surface completeness)
unlock report: after Gate A pass (findings exist + gate recorded) + Gate P prefs confirmed
ready recheck: when findings exist and the target head has moved
ready audit: any time (separate surface under docs/audit/)
```

## Cross-Stage Jump Protection (blocking by default)

The graph edges are **recommended** paths, but the agent must enforce **prerequisite artifact checks** before allowing a stage to execute. This prevents the common failure where a user says "give me a verdict" and the agent jumps from GATHER to REPORT, skipping ANALYZE.

The guard is **blocking**. The agent must not proceed past a missing prerequisite without an explicit user override ("skip guard"). A general task instruction does **not** count as an override. When overridden, record `scenario_note: "prerequisite skipped by user override"` in the next gate JSON.

**Prerequisite matrix:** see SKILL.md § Phase-Guard — it is the authoritative table; this file defers to it.

## Cycles

- `analyze ⟲ lens`: repeat until findings are stable across a lens pass (no new findings, no refinements)
- Loop pattern: `report → gather(new diff) → analyze` until verdict is PASS or the user stops
- Every cycle iteration appends to the lens/dispute run notes; silent rewrites of findings are forbidden
