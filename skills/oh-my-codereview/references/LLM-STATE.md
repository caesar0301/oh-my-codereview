# LLM State — Agent-Owned JSON

State under `.ocr/` is authored and maintained by the agent (not by scripts). Update it after every op; a stale state is a bug, not a suggestion.

## tree-state.json

```json
{
  "workspace": "<target>",
  "base_ref": "main",
  "head_ref": "feature/x @ abc1234",
  "pattern": "standard",
  "stages": {
    "init": "completed",
    "gather": "completed",
    "analyze": "in_progress",
    "lens": "unlocked",
    "report": "locked"
  },
  "notes": "gather batch 2: CI logs unavailable, user opted out",
  "updated_at": "2026-10-27T18:00:00Z"
}
```

Stage values: `locked` → `unlocked` → `ready` → `in_progress` → `completed`.

## pattern.json

`{ "name": "standard", "gates": "semi-automated", "switched_from": null }`

## review-state.json (report drafting)

`{ "report_format": "md", "audience": "maintainer", "strictness": "default", "findings_file": "docs/review/findings-2.md", "verdict_draft": "PASS_WITH_ISSUES" }`

## versions.json / quality-gates/

`versions.json` records tags (see `VERSION/version.md`). `quality-gates/<gate>-<n>.json` records gate runs (see `GATES.md`).

## Tree-state pre-flight check

At the start of any op: read tree-state; if a stage is marked `in_progress` from a previous session, treat the workflow as interrupted — reconcile disk artifacts first (`qa state-check` semantics), then resume. If tree-state is missing but artifacts exist, reconstruct it from disk before proceeding.

## Overrides

A user override ("skip guard", "no confirmations") is recorded in the next gate JSON as `scenario_note` and in tree-state `notes`. Overrides are per-op, never persistent.
