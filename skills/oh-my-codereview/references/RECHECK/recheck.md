# RECHECK — Findings vs New Commits

`recheck` runs when the target moved after findings were written: new commits on the PR, a forced push, or working-tree edits.

## Behavior

1. **Detect drift**: gather the new diff (`materials/diffs/`, new batch) and diff it against the previously gathered surface.
2. **Blast radius per finding**:
   - Finding's file/lines untouched → carry forward, mark `unchanged`
   - Finding's file changed → re-verify against the new code; stamp `confirmed`, `refined`, or `withdrawn`
   - Change fixes a finding → stamp `resolved` with the commit as evidence
3. **New surface**: code added since the last gather enters ANALYZE as new findings (`F-0NN` continues).
4. **Report update**: verdict recomputed from the carried-forward + new findings; the report changelog states what moved.

## Why not re-review from zero

Carrying findings forward preserves review continuity and keeps dispute history. A full re-review discards verified evidence and re-litigates settled questions. Re-review from zero only when the user explicitly asks (e.g. "fresh review").

## Tree state

Mark `recheck` in `.ocr/tree-state.json` notes with the head ref checked; unlock REPORT when the recomputed findings pass Gate A again.
